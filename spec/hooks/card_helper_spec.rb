require_relative '../spec_helper'

module Hooks
	describe CardHelper do
		include Helpers

		let(:client) 	{Trello.client}

		describe ".task_group?" do
			let(:card) 		{Trello::Card.new cards_details(:create_card)}

			it "returns false if no task group label is assigned to card" do
				payload = board_labels_payload 1
				allow_get "/cards/abcdef123456789123456789/labels", anything(), payload

				expect(CardHelper.task_group? card).to eql(false)
			end

			it "returns true if task group label is assigned to card" do
				payload = JSON.generate(board_labels(1) + [version_label("task group")])
				allow_get "/cards/abcdef123456789123456789/labels", anything(), payload

				expect(CardHelper.task_group? card).to eql(true)
			end

			it "returns true if task group label uppercase is assigned to card" do
				payload = JSON.generate(board_labels(1) + [version_label("TASK GROUP")])
				allow_get "/cards/abcdef123456789123456789/labels", anything(), payload

				expect(CardHelper.task_group? card).to eql(true)
			end

			it "returns true if task group label mixcase is assigned to card" do
				payload = JSON.generate(board_labels(1) + [version_label("TaSk GrOuP")])
				allow_get "/cards/abcdef123456789123456789/labels", anything(), payload

				expect(CardHelper.task_group? card).to eql(true)
			end
		end
	end
end