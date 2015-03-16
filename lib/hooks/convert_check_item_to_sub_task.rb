require_relative 'base'
require_relative 'hook_helper'
require_relative '../trello/convert_to_card_action'

module Hooks
	class ConvertCheckItemToSubTask < Base

		include CardHelper

		def initialize action
			case action
			when String
				@action = action.json_into(Trello::ConvertToCardAction)
			when Hash
				@action = Trello::ConvertToCardAction.new action
			when Trello::ConvertToCardAction
				@action = action
			when Trello::Action
				@action = Trello::ConvertToCardAction.convert_from_action action
			end
			raise Failure unless @action.valid?
			@data = @action.data
		end

		def source_card
			@source_card ||= @action.source_card
		end

		def execute
			sub_tasks = find_checklist(source_card, "sub tasks")

			unless sub_tasks.nil?
				#add converted card as checklist item to source card
				sub_tasks.add_item card.short_url
				
				#add link to source card to converted card description
				card.desc="parent task: #{source_card.short_url}\n#{card.desc}"
				card.update!

				#add label to converted card
				add_label_with_name "task:#{source_card.name}", true
			end
		end
	end
end