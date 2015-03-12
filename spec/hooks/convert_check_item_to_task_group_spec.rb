require_relative '../spec_helper'

module Hooks
	describe ConvertCheckItemToTaskGroup do
		include Helpers

		let(:action) 	{Trello::Action.new action_details(c)}
		let(:card) 		{Trello::Card.new cards_details(c)}
		let(:list) 		{Trello::List.new lists_details(c)}
		let(:board) 	{Trello::Board.new boards_details}
		let(:member) 	{Trello::Member.new user_details}
		let(:client) 	{Trello.client}
		let(:c) 		{ :create_card }

		subject {Hooks::ConvertCheckItemToTaskGroup.new action}

		before(:each) do
			logger_mock = double('Logger').as_null_object
    		allow(Hooks).to receive(:logger).and_return(logger_mock)
    		allow_get "/actions/abcdef123456789123456789", anything(), action_payload(c)
    	end

    	describe '#new' do
    		context 'when creating with invalid action (create card)' do
    			let(:c) {:create_card}

    			it 'fails with json' do
    				expect{ Hooks::ConvertCheckItemToTaskGroup.new action_payload(c) }.to raise_error(Failure)	
    			end

    			it 'fails with Hash' do
    				expect{ Hooks::ConvertCheckItemToTaskGroup.new action_details(c) }.to raise_error(Failure)	
    			end

    			it 'fails with Trello::Action' do
    				expect{ Hooks::ConvertCheckItemToTaskGroup.new(Trello::Action.new action_details(c)) }.to raise_error(Failure)	
    			end

    			it 'fails with Trello::ConvertToCardAction' do
    				expect{ Hooks::ConvertCheckItemToTaskGroup.new(Trello::ConvertToCardAction.new action_details(c)) }.to raise_error(Failure)	
    			end
    		end

    		context 'when creating with valid action (convertToCardFromCheckItem)' do
    			let(:c) {:convert_card}

    			it 'succeeds with json' do
    				expect{ Hooks::ConvertCheckItemToTaskGroup.new action_payload(c) }.not_to raise_error
    			end

    			it 'succeeds with Hash' do
    				expect{ Hooks::ConvertCheckItemToTaskGroup.new action_details(c) }.not_to raise_error
    			end

    			it 'succeeds with Trello::Action' do
    				expect{ Hooks::ConvertCheckItemToTaskGroup.new(Trello::Action.new action_details(c)) }.not_to raise_error	
    			end

    			it 'succeeds with Trello::ConvertToCardAction' do
    				expect{ Hooks::ConvertCheckItemToTaskGroup.new(Trello::ConvertToCardAction.new action_details(c)) }.not_to raise_error	
    			end
    		end
		end
	end
end