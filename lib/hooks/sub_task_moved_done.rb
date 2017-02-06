require_relative 'base'
require_relative 'hook_helper'
require_relative '../trello/card_moved_action'

module Hooks
	class SubTaskMovedDone < Base

		PARENT_CARD_LINK_PATTERN = /parent task: (?<card_link>https:\/\/trello\.com\/c\/(?<short_id>dbjJddkO))/
		CARD_LINK_PATTERN = /https:\/\/trello\.com\/c\/(?<short_id>dbjJddkO)/

		include CardHelper

		def initialize action
			case action
			when String
				@action = action.json_into(Trello::CardMovedAction)
			when Hash
				@action = Trello::CardMovedAction.new action
			when Trello::CardMovedAction
				@action = action
			when Trello::Action
				@action = Trello::CardMovedAction.convert_from_action action
			end
			@data = @action.data
		end

		def valid?
			@action.valid?
		end

		def list_name_match? list, name
			!(/#{name}/i =~ list.name).nil? 
		end

		def find_card_link_in_text text
			match = PARENT_CARD_LINK_PATTERN.match(text)
			match[:card_link] unless match.nil?
		end

		def short_id_from_card_link card_short_url
			match = CARD_LINK_PATTERN.match(card_short_url)
			match[:short_id] unless match.nil?
		end

		def execute
			return unless valid?

			if list_name_match? card.list, 'done'
				parent_short_link = find_card_link_in_text card.desc
				unless parent_short_link.nil?
					short_id = short_id_from_card_link parent_short_link
					parent_card = Trello::Card.find(short_id)
					unless parent_card.is_a? Trello::Error
						
					end
				end
			end
		end
	end
end