require 'logger'

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
			board.labels.each do |label|
				return label if label.name.eql? name
			end
			nil
		end

		def add_label_with_name label_name, force_create=false
			label = find_label board, label_name
			
			if label.nil? && force_create
				Hooks.logger.info("board needs new label")
				label = Trello::Label.create name:label_name, board_id:board.id, color:nil
			end

			card.add_label label unless label.nil?
		end
	end
end