require 'trello'

module Hooks
	class AutoAssign
		
		def initialize payload
			@action = Trello::Action.find(payload['action']['id'])
			@member = @action.member_creator
			@data = @action.data
		end

		def execute
			if card_moved_to? "Doing"
				card = @action.card
				unless card.member_ids.include? @member.id		
					card.add_member @member
				end
			end

			200
		end

		def card_moved_to?(destination)
			card_update? and card_moved? and list_after_name.eql? destination
		end

		def card_moved?
			@data.include? "listAfter"
		end

		def card_update?
			@action.type.eql? "updateCard"
		end

		def list_after_name
			@data["listAfter"]["name"]
		end
	end
end
