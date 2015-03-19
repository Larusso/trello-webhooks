require_relative 'base'
require_relative 'hook_helper'
require_relative 'convert_check_item_to_sub_task'
require_relative 'sub_task_moved_done'

module Hooks
	class SubTasks < Base

		def sub_hooks_map
			{
				convertToCardFromCheckItem: ConvertCheckItemToSubTask,
				updateCard: SubTaskMovedDone
			}
		end

		def execute
			hook_class = sub_hooks_map[action.type.to_sym]
			hook = hook_class.new action
			hook.execute
		end
	end
end