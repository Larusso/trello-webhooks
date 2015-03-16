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

		describe ".find_checklist" do
			let(:payload) { JSON.generate(checklists_details(1) + [named_checklist(actual_name)]) }

			shared_examples_for "find checklist" do
				it { expect(CardHelper.find_checklist card, check_name).not_to be_nil }
				it { expect(CardHelper.find_checklist card, check_name).to be_kind_of(Trello::Checklist) }
				it { expect(CardHelper.find_checklist(card, check_name).name).to eql(actual_name) }
			end

			let(:card) 	{Trello::Card.new cards_details(:create_card)}
			let!(:init) {allow_get "/cards/abcdef123456789123456789/checklists", anything(), payload}

			context "when checklist is available" do
				let(:check_name) {"test list"}
				let(:actual_name) {"test list"}
				
				it_behaves_like "find checklist"
			end

			context "when checklist is available mixcase" do
				let(:check_name) {"test list"}
				let(:actual_name) {"TeSt LiSt"}
				
				it_behaves_like "find checklist"
			end

			context "when checklist is available uppercase" do
				let(:check_name) {"test list"}
				let(:actual_name) {"TEST LIST"}
				
				it_behaves_like "find checklist"
			end

			context "when checklist is not available" do
				let(:check_name) {"unavailable"}
				let(:actual_name) {"test list"}

				it { expect(CardHelper.find_checklist card, check_name).to be_nil }
			end
		end

		describe ".find_label" do
			
		end
	end
end