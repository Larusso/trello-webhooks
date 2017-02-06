require_relative '../spec_helper'

module Hooks
	describe SubTaskMovedDone do
		include Helpers

		let(:action) 	{Trello::Action.new action_details(c)}
		let(:client) 	{Trello.client}
		let(:board) 	{Trello::Board.new boards_details}
		let(:c) 		{:move_card}

		subject {Hooks::SubTaskMovedDone.new action}

		before(:each) do
			logger_mock = double('Logger').as_null_object
    		allow(Hooks).to receive(:logger).and_return(logger_mock)
    		allow_get "/actions/abcdef123456789123456789", anything(), action_payload(c)
    		allow_get "/actions/abcdef123456789123456789/card", anything(), cards_payload(c)
    	end


		describe '#new' do

    		subject {Hooks::SubTaskMovedDone}

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
    				hook = subject.new(Trello::CardMovedAction.new action_details(c))
    				expect(hook).not_to be_valid
    			end
    		end

    		context 'when creating with valid action (move card)' do
    			let(:c) {:move_card}

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
    				hook = subject.new(Trello::CardMovedAction.new action_details(c))
    				expect(hook).to be_valid
    			end
    		end
		end

		describe ".list_name_match?" do
			let(:list) {Trello::List.new lists_details :card_moved_done_version }

			it {expect(subject.list_name_match? list, 'Done').to be_boolean }
			it {expect(subject.list_name_match? list, 'Done').to eql(true) }
			it {expect(subject.list_name_match? list, 'DONE').to eql(true) }
			it {expect(subject.list_name_match? list, 'Fix').to eql(false) }
			it {expect(subject.list_name_match? list, 'done').to eql(true) }
		end

		describe ".find_card_link_in_text" do
			context "when text contains link" do
				let(:text) {"parent task: https://trello.com/c/dbjJddkO\n some more"}
				it {expect(subject.find_card_link_in_text text).to eql('https://trello.com/c/dbjJddkO')}
			end

			context "when text contains no card link" do
				let(:text) {"some text with no information"}
				it { expect(subject.find_card_link_in_text text).to be_nil }
			end
		end

		describe ".short_id_from_card_link" do
			it {expect(subject.short_id_from_card_link "https://trello.com/c/dbjJddkO").to eql('dbjJddkO')}
		end

		describe ".execute" do
			context "when hook is valid" do
                let(:c) { :sub_tasks_moved_done }
                let(:list) {Trello::List.new lists_details(c)}
                before :all do
                    allow_get "/lists/abcdef123456789123456789", anything(), list
                end

				context "when to list name matches done" do

				end
			end
		end
	end
end