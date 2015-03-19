require_relative 'base'
require_relative 'hook_helper'

module Hooks
	class SubTaskMovedDone < Base
		def execute
			puts "done"
		end
	end
end