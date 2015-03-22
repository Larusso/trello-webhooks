require_relative 'base'
require_relative 'hook_helper'
require_relative '../trello/card_moved_action'

module Hooks
	class SubTaskMovedDone < Base

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
			match = CARD_LINK_PATTERN.match(text)
			match[0] unless match.nil?
		end

		def short_id_from_card_link card_short_url
			match = CARD_LINK_PATTERN.match(card_short_url)
			match[:short_id] unless match.nil?
		end

		def execute
			return unless valid?
		end
	end
end