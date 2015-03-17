require_relative 'base'
require_relative 'hook_helper'

require 'logger'

module Hooks
	class AutoVersion < Base
		include CardHelper

		VERSION_PATTERN = %r!\d+\.\d+(\.\d+)?!
		VERSION_GROUP_PATTERN = /(\d+\.\d+(\.\d+)?(\.[\w\d]+)?)/

		def execute
			Hooks.logger.info("execute")
			
			if (card_created? || card_moved?)
				Hooks.logger.info("card created or moved")
			
				self.list = list.nil? ? card.list : list
				if versioned_list?
					version = list_version
					
					Hooks.logger.info("put version #{version} to card #{card.id}")
					update_card_version version
				end
			elsif (list_updated? && versioned_list?)
				version = list_version
				list.cards.each { |list_card|
					self.card = list_card
					update_card_version version
				}
			end
		end

		def update_card_version version
			Hooks.logger.info("update card #{card.id}, version #{version}")

			unless card_has_label? card, version
				add_label_with_name version, true

				card_version_labels.each {|label|
					card.remove_label label
				}
			end
		end

		def list_version
			version = nil
			unless list.nil?
				m = list.name.match(VERSION_GROUP_PATTERN)
				version,g2,g3 = m.captures if m
			end
			version
		end

		def versioned_list?
			!list_version.nil?
		end

		def card_has_label? card, name
			card.labels.map { |label| label.name }.include? name
		end

		def board_has_label? name
			board.labels.map{ |label| label.name }.include? name
		end

		def card_version_labels
			card.labels.select { |label|
				!(label.name =~ VERSION_PATTERN).nil?
			}
		end

		def board_version_labels
			board.labels.select {|label|
				!(label.name =~ VERSION_PATTERN).nil?
			}
		end
	end
end