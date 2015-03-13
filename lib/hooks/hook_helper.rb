module Hooks
	module CardHelper

		module_function
		def task_group? card, name="sub tasks"
			card.checklists.map {|checklists| checklists.name.downcase}.include?(name)
		end
	end
end