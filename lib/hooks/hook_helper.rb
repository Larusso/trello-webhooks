module Hooks
	module CardHelper

		module_function
		def task_group? card, name="sub tasks"
			card.checklists.map {|checklists| checklists.name.downcase}.include?(name)
		end

		def find_checklist card, name
			card.checklists.each do |checklist|
				return checklist if checklist.name.downcase.eql? name.downcase
			end
			nil
		end

		def find_label board, name

		end
	end
end