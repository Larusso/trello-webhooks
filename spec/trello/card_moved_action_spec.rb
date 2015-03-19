require_relative '../spec_helper'

module Trello
	describe CardMovedAction do
		include Helpers

		let(:action) { action_details(:move_card) }
		let(:client) { Trello.client }

		subject {Trello::CardMovedAction.new action}

		describe "#new" do
			context "when action is a convert card action" do
				it { should be_valid }
				
				it "the action has a from list" do
					allow_get "/lists/53d77b7e8b272ed7c843a946", anything(), lists_payload(:create_card)
					expect(subject.from_list).not_to be_nil
				end

				it "the action has a to list" do
					allow_get "/lists/54eef8a54e22aeee50bcee3f", anything(), lists_payload(:create_card)
					expect(subject.to_list).not_to be_nil
				end
			end

			context "when action is not a convert card action" do
				let(:action) {action_details(:create_card)}
				it { should_not be_valid }
				it { expect(subject.to_list).to be_nil }
				it { expect(subject.from_list).to be_nil }
			end

			it {should be_kind_of(Trello::Action)}
		end

		describe "#convert_from_action" do
			
			let(:c) { :convert_card }
			let(:action) {Trello::Action.new action_details(c)}
			let(:subject) {Trello::CardMovedAction}

			before :each do
				allow_get "/actions/abcdef123456789123456789", anything(), action_payload(c)
			end

			it {expect(subject.convert_from_action action).not_to be_nil}
			it {expect(subject.convert_from_action action).to be_kind_of(subject)}

			context "with valid convert action" do
				let(:c) { :move_card }
				it {expect(subject.convert_from_action action).to be_valid}
			end

			context "with invalid action" do
				let(:c) { :convert_card }
				it {expect(subject.convert_from_action action).not_to be_valid}
			end
		end
	end
end