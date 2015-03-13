require_relative '../spec_helper'

module Hooks
	describe CardHelper do
		include Helpers

		let(:client) 	{Trello.client}

		describe ".task_group?" do
			let(:card) 		{Trello::Card.new cards_details(:create_card)}

			it "returns false if no task group checklist is assigned to card" do
				payload = checklists_payload 1
				allow_get "/cards/abcdef123456789123456789/checklists", anything(), payload

				expect(CardHelper.task_group? card).to eql(false)
			end

			it "returns true if task group checklist is assigned to card" do
				payload = JSON.generate(checklists_details(1) + [named_checklist("sub tasks")])
				allow_get "/cards/abcdef123456789123456789/checklists", anything(), payload

				expect(CardHelper.task_group? card).to eql(true)
			end

			it "returns true if task group checklist uppercase is assigned to card" do
				payload = JSON.generate(checklists_details(1) + [named_checklist("SUB TASKS")])
				allow_get "/cards/abcdef123456789123456789/checklists", anything(), payload

				expect(CardHelper.task_group? card).to eql(true)
			end

			it "returns true if task group checklist mixcase is assigned to card" do
				payload = JSON.generate(checklists_details(1) + [named_checklist("SuB TaSks")])
				allow_get "/cards/abcdef123456789123456789/checklists", anything(), payload

				expect(CardHelper.task_group? card).to eql(true)
			end
		end

		describe ".find_sub_task_list" do
		end
	end
end