require_relative '../spec_helper'

module Trello
	describe ConvertToCardAction do
		include Helpers

		let(:action) { action_details(:convert_card) }
		let(:client) { Trello.client }

		subject {Trello::ConvertToCardAction.new action}

		describe "#new" do
			context "when action is a convert card action" do
				it { should be_valid }
				it "the action has a source card" do
					allow_get "/cards/54eef8a54e22aeee50bcee3f", anything(), cards_payload(:create_card)
					expect(subject.source_card).not_to be_nil
				end
			end

			context "when action is not a convert card action" do
				let(:action) {action_details(:create_card)}
				it { should_not be_valid }
				it { expect(subject.source_card).to be_nil }
			end

			it {should be_kind_of(Trello::Action)}
		end
	end
end