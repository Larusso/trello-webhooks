require_relative '../spec_helper'

module Hooks
	describe AutoAssign do
		include Helpers

		let(:action) 	{Trello::Action.new action_details(c)}
		let(:card) 		{Trello::Card.new cards_details(c)}
		let(:list) 		{Trello::List.new lists_details(c)}
		let(:board) 	{Trello::Board.new boards_details}
		let(:member) 	{Trello::Member.new user_details}
		let(:client) 	{Trello.client}
		
		subject {Hooks::AutoAssign.new action}

		before(:each) do
			logger_mock = double('Logger').as_null_object
    		allow(Hooks).to receive(:logger).and_return(logger_mock)

			allow_get "/actions/abcdef123456789123456789/card", anything(), cards_payload(c)
			allow_get "/lists/abcdef123456789123456789", anything(), lists_payload(c)
			allow_get "/members/abcdef123456789123456789", anything, JSON.generate(user_details)
		end

		context 'when card moved to Doing' do
			let(:c) {:card_moved_doing}

			describe '.execute' do
				it 'should set member to card' do
					expect(client).to receive(:post).once.with("/cards/abcdef123456789123456789/members", {:value=>"abcdef123456789123456789"})
					subject.execute
				end
			end
		end

		context 'when list updates' do
			let(:c) {:list_update}
			
			describe '.execute' do
				it 'should set member to card' do
					expect(client).not_to receive(:post)
					subject.execute
				end
			end
		end
	end
end