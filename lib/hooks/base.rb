require 'trello'
require 'json'

module Hooks
	class Base

		attr_accessor :action, :data

		def initialize action
			case action
			when String
				@action = action.json_into(Trello::Action)
			when Hash
				@action = Trello::Action.new action
			when Trello::Action
				@action = action
			end
			@data = @action.data
		end

		def card= value
			@card = value
		end
		
		def card
			begin
				@card ||= @action.card
			rescue
				nil
			end
		end

		def list
			begin
				@list ||= @action.list
			rescue
				nil
			end
		end

		def board
			begin
				@board ||= @action.board
			rescue
				nil
			end
		end

		def member_creator
			@action.member_creator
		end

		def client
			Trello.client
		end

		def card_moved?
			data.include? "listAfter"
		end

		def card_update?
			@action.type.eql? "updateCard"
		end

		def card_created?
			@action.type.eql? 'createCard'
		end

		def list_updated?
			@action.type.eql? 'updateList'
		end

		def execute
		end
	end
end