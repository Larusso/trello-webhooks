module Hooks
	module CardHelper

		module_function
		def task_group? card
			card.labels.map {|label| label.name.downcase}.include?("task group")
		end
	end
end