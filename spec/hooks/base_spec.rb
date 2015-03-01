require_relative '../spec_helper'

module Hooks
	describe 'Base' do
		include Helpers
		
		let(:action) 	{Trello::Action.new action_details(:create_card)}
		let(:client) 	{double('Trello::Client').as_null_object}
		
		subject {Hooks::AutoVersion.new action}

		describe "#new" do
			context 'when action is json string' do
				let(:action) {action_payload(:create_card)}
				it {should_not be_nil}
			end

			context 'when action is Hash' do
				let(:action) {action_details(:create_card)}
				it {should_not be_nil}
			end

			context 'when action is Trello::Action' do
				let(:action) { Trello::Action.new action_details(:create_card) }			
				it {should_not be_nil}
			end
			
			it {should be_kind_of(Hooks::AutoVersion)}
			it {should be_kind_of(Hooks::Base)}
		end

		describe '.card_created?' do
			it { expect(subject.card_created?).to be_boolean }
		end

		describe '.list_updated?' do
			it { expect(subject.list_updated?).to be_boolean }
		end

		describe '.card_update?' do
			it { expect(subject.card_update?).to be_boolean }
		end

		describe '.card_moved?' do
			it { expect(subject.card_moved?).to be_boolean }
		end

		describe '.versioned_list?' do
			it { expect(subject.versioned_list? subject.list).to be_boolean }
		end
	end
end