require_relative '../spec_helper'

module Hooks
	describe ConvertCheckItemToSubTask do
		include Helpers

		let(:action) 	{Trello::Action.new action_details(c)}
		let(:client) 	{Trello.client}
		let(:board) 	{Trello::Board.new boards_details}
		let(:c) 		{:convert_card}

		subject {Hooks::ConvertCheckItemToSubTask.new action}

		before(:each) do
			logger_mock = double('Logger').as_null_object
    		allow(Hooks).to receive(:logger).and_return(logger_mock)
    		allow_get "/actions/abcdef123456789123456789", anything(), action_payload(c)
    		allow_get "/actions/abcdef123456789123456789/card", anything(), cards_payload(c)
    	end

    	describe '#new' do

    		subject {Hooks::ConvertCheckItemToSubTask}

    		context 'when creating with invalid action (create card)' do
    			let(:c) {:create_card}

    			it 'fails with json' do
    				hook = subject.new action_payload(c)
    				expect(hook).not_to be_valid
    			end

    			it 'fails with Hash' do
    				hook = subject.new action_details(c)
    				expect(hook).not_to be_valid
    			end

    			it 'fails with Trello::Action' do
    				hook = subject.new(Trello::Action.new action_details(c))
    				expect(hook).not_to be_valid
    			end

    			it 'fails with Trello::ConvertToCardAction' do
    				hook = subject.new(Trello::ConvertToCardAction.new action_details(c))
    				expect(hook).not_to be_valid
    			end
    		end

    		context 'when creating with valid action (convertToCardFromCheckItem)' do
    			let(:c) {:convert_card}

    			it 'succeeds with json' do
    				hook = subject.new action_payload(c)
    				expect(hook).to be_valid
    			end

    			it 'succeeds with Hash' do
    				hook = subject.new action_details(c)
    				expect(hook).to be_valid
    			end

    			it 'succeeds with Trello::Action' do
    				hook = subject.new(Trello::Action.new action_details(c))
    				expect(hook).to be_valid
    			end

    			it 'succeeds with Trello::ConvertToCardAction' do
    				hook = subject.new(Trello::ConvertToCardAction.new action_details(c))
    				expect(hook).to be_valid
    			end
    		end
		end

		describe '.execute' do
			shared_examples_for "convert check item to sub task" do
				let!(:init) {
					allow_put "/cards/abcdef123456789123456789", anything, "nothing"
					allow_post "/checklists/namedabcdef123456789123456789/checkItems", anything, "nothing"
					allow_post "/labels", anything, JSON.generate(version_label("nothing"))
					allow_post "/cards/abcdef123456789123456789/idLabels", anything, "nothing"
					allow_post "/cards/abcdef123456789123456789/actions/comments", anything, "nothing"
					allow_get "/actions/abcdef123456789123456789/board", anything() , boards_payload
					allow_get "/boards/abcdef123456789123456789/labels", anything() , board_labels_payload(:create_card)
					allow_get "/cards/abcdef123456789123456789/labels", anything() , JSON.generate([])
				}

				it "adds checklist item to source card" do
					expect(client).to receive(:post).with("/checklists/namedabcdef123456789123456789/checkItems", hash_including(name: "https://trello.com/c/abcdef12", checked: false))
					subject.execute
				end

				it "adds a link to source card to converted card" do
					expected_card = Trello::Card.new cards_details(:move_card)
					expected_description = "parent task: #{expected_card.short_url}\n#{expected_card.desc}"

					expect(client).to receive(:put).with("/cards/#{expected_card.id}", {desc: expected_description})
					subject.execute
				end

				it "adds a comment with checklist id" do
					expected_card = Trello::Card.new cards_details(:move_card)
					expected_comment = "parent checklist: namedabcdef123456789123456789"
					expect(client).to receive(:post).with("/cards/#{expected_card.id}/actions/comments", {text: expected_comment})
					subject.execute
				end

				context "when source card has labels" do
					it "copies all labels from source card to converted card" do
						allow_get "/cards/abcdef123456789123456789/labels", anything() , board_labels_payload(:create_card)
						expect(client).to receive(:post).exactly(5).times.with("/cards/abcdef123456789123456789/idLabels", {value: '54656d9574d650d5672a06df'})
						subject.execute
					end
				end
			end

			before :each do
				allow_get "/cards/54eef8a54e22aeee50bcee3f", anything(), cards_payload(:create_card)
				allow_get "/cards/abcdef123456789123456789/checklists", anything(), check_list_payload
			end

			context 'when source card hash one sub task' do
				let(:check_list_payload) {JSON.generate( [named_checklist("sub tasks")])}
				
				it_behaves_like "convert check item to sub task"
			end

			context 'when source card hash many sub task' do
				let(:check_list_payload) {JSON.generate(checklists_details + [named_checklist("sub tasks")])}

				it_behaves_like "convert check item to sub task"
			end

			context 'when source card has no sub tasks' do
				let(:check_list_payload) {checklists_payload 1}

				it "adds no checklist item to source card" do
					expect(client).not_to receive(:post).with("/checklists/abcdef123456789123456789/checkItems", anything )
					subject.execute
				end

				it "adds no link to source card to converted card" do
					expect(client).not_to receive(:put).with("/cards/abcdef123456789123456789", anything )
					subject.execute
				end
			end
		end
	end
end