require_relative 'base'

require 'logger'

module Hooks
	class AutoVersion < Base

		VERSION_PATTERN = %r!\d+\.\d+(\.\d+)?!
		VERSION_GROUP_PATTERN = /(\d+\.\d+(\.\d+)?(\.[\w\d]+)?)/

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
				label_to_add = nil
				unless board_has_label? version
					Hooks.logger.info("board needs new label")
					label_to_add = Trello::Label.create name: version, board_id: board.id, color: Trello::Label.label_colours.sample
				else
					label_to_add = find_label version
				end

				id_labels = card_version_labels(card)
				
				id_labels.each {|label|
					card.remove_label label
				}

				card.add_label(label_to_add) unless label_to_add.nil?
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

		def card_has_label? card, name
			card.labels.map { |label| label.name }.include? name
		end

		def board_has_label? name
			board.labels.map{ |label| label.name }.include? name
		end

		def find_label name
			label = nil
			board.labels.each { |l|
				label = l if l.name.eql? name
				break if label
			}
			label
		end

		def card_labels card
			labels = card.labels
		end

		def board_labels
			labels = board.labels
		end

		def card_version_labels card
			card.labels.select { |label|
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