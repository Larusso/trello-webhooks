require_relative 'base'
require 'trello'

module Hooks
	class AutoAssign < Base
		
		def execute
			if card_moved_to? "Doing"
				unless card.member_ids.include? member_creator.id		
					card.add_member member_creator
				end
			end

			200
		end

		def card_moved_to?(destination)
			card_update? and card_moved? and list_after_name.eql? destination
		end

		def list_after_name
			card.list.name
		end
	end
end
