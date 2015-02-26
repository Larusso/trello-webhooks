require 'trello'
require 'json'

module Hooks
	class Base
			attr_accessor :action, :data

		def initialize action
			@action = action.json_into(Trello::Action)
			@data = @action.data
		end

		def card
			begin
				@action.card
			rescue
				nil
			end
		end

		def list
			begin
				@action.list
			rescue
				nil
			end
		end

		def board
			@action.board
		end

		def member_creator
			@action.member_creator
		end

		def client
			Trello.client
		end

		def execute
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
	end
end