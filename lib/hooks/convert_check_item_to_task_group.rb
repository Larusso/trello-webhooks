require_relative 'base'

module Hooks
	class ConvertCheckItemToTaskGroup < Base
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
	end
end