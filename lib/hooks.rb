require 'logger'
require_relative 'hooks/hook_helper'

module Hooks
	autoload :AutoVersion, 						'hooks/auto_version'
	autoload :AutoAssign,  						'hooks/auto_assign'
	autoload :ConvertCheckItemToSubTask,  		'hooks/convert_check_item_to_sub_task'
	autoload :SubTasks,					  		'hooks/sub_tasks'
	autoload :SubTaskMovedDone,					'hooks/sub_task_moved_done'

	def self.logger
		@logger ||= Logger.new(STDOUT)
	end

	def self.logger=(logger)
		@logger = logger
	end

	class Failure < StandardError; end
end