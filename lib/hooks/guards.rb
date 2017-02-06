module Hooks
	class HookDecorator < SimpleDelegator
		def initialize(hook)
    		@hook = hook
    		super
  		end
	end

	class CardMovedGuard < HookDecorator
		def execute
			puts 'CardMovedGuard'
			@hook.execute if card_moved?
		end
	end

	class UpdateCardGuard < HookDecorator
		def execute
			puts 'UpdateCardGuard'
			@hook.execute if card_update?
		end
	end
end