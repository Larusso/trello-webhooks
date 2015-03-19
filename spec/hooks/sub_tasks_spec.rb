require_relative '../spec_helper'

module Hooks
	describe SubTasks do
		include Helpers

		describe ".execute" do
			let(:subject) {Hooks::SubTasks.new action}
			
			shared_examples_for "a hook group" do
				let(:hook) {instance_double hook_class}
				let(:action_double) {instance_double(Trello::Action, id: action['id'])}

				it "executes correct hook implementation" do
					allow(hook_class).to receive(:new).once.with(action_double).and_return hook
					expect(hook).to receive(:execute).once
					subject.execute
				end
			end

			context "when action type is convertToCardFromCheckItem" do
				let(:action) { action_details :convert_card }
				let(:hook_class) { Hooks::ConvertCheckItemToSubTask }

				it_behaves_like "a hook group"
			end

			context "when action type is cardUpdated" do
				let(:action) { action_details :move_card }
				let(:hook_class) { Hooks::SubTaskMovedDone }
				
				it_behaves_like "a hook group"
			end
		end
	end
end