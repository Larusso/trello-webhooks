require_relative 'base'

require 'logger'

module Trello
	# A colored Label attached to a card
	class Label < BasicData
		register_attributes :name, :color, :id
		# Update the fields of a label.
		#
		# Supply a hash of stringkeyed data retrieved from the Trello API representing
		# a label.
		def update_fields(fields)
			attributes[:id] = fields['id']
			attributes[:name] = fields['name']
			attributes[:color] = fields['color']
			self
		end
	end
end

module Hooks
	class AutoVersion < Base

		VERSION_PATTERN = %r!\d+\.\d+(\.\d+)?!
		VERSION_GROUP_PATTERN = /(\d+\.\d+(\.\d+)?(\.[\w\d]+)?)/
		COLORS = ["green", "yellow", "orange", "red", "purple", "blue", "sky", "lime", "pink", "black"]

		def execute
			Hooks.logger.info("execute")
			
			if (card_created? || card_moved?)
				Hooks.logger.info("card created or moved")
			
				card_list = list.nil? ? card.list : list
				if versioned_list? card_list
					version = list_version card_list
					
					Hooks.logger.info("put version #{version} to card #{card.id}")
					update_card_version card, version
				end
			elsif (list_updated? && versioned_list?(list))
				version = list_version list
				list.cards.each {|card|
					update_card_version card, version
				}
			end
		end

		def update_card_version card, version
			Hooks.logger.info("update card #{card.id}, version #{version}")

			unless card_has_label? card, version
				unless board_has_label? version
					Hooks.logger.info("board needs new label")
					body = {name: version, idBoard: board.id, color: COLORS.sample}
					client.post("/labels", body)
				end
				
				label_to_add = find_label version
				id_labels = card_version_labels(card).map {|label| label.id}
				
				id_labels.each {|id|
					client.delete("/cards/#{card.id}/idLabels/#{id}")
				}

				client.post("/cards/#{card.id}/idLabels", {value: label_to_add.id}) unless label_to_add.nil?
			end
		end

		def list_version list
			version = nil
			unless list.nil?
				m = list.name.match(VERSION_GROUP_PATTERN)
				version,g2,g3 = m.captures if m
			end
			version
		end

		def versioned_list? list
			!list_version(list).nil?
		end

		def item_has_label? item_type, id, name
			status = false
			labels = client.find_many(Trello::Label, "/#{item_type}/#{id}/labels", {})
			labels.each { |label|
				status = label.name.eql? name
				break if status
			}
			status
		end

		def card_has_label? card, name
			item_has_label? 'cards', card.id, name
		end

		def board_has_label? name
			item_has_label? 'board', board.id, name
		end

		def find_label name
			label = nil
			labels = client.find_many(Trello::Label, "/board/#{board.id}/labels", {})
			labels.each { |l|
				label = l if l.name.eql? name
				break if label
			}
			label
		end

		def card_labels card
			labels = client.find_many(Trello::Label, "/cards/#{card.id}/labels", {})
		end

		def board_labels
			labels = client.find_many(Trello::Label, "/board/#{board.id}/labels", {})
		end

		def card_version_labels card
			labels = card_labels card
			labels.select { |label|
				!(label.name =~ VERSION_PATTERN).nil?
			}
		end

		def board_version_labels
			labels = board_labels
			labels.select {|label|
				!(label.name =~ VERSION_PATTERN).nil?
			}
		end
	end
end