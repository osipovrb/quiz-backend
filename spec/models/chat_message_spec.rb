require 'rails_helper'

RSpec.describe ChatMessage, type: :model do
	describe "validations" do
		it { should validate_presence_of(:content) }
		it { should validate_length_of(:content).is_at_most(500) }
		it { should belong_to(:user) }
	end

	describe "chat messages" do
		before { ActiveJob::Base.queue_adapter = :test }

		it "should enqueue broadcast job after commit" do
			message = ChatMessage.create(user: create(:user), content: "Some Message")
			expect(ChatMessageBroadcastJob).to have_been_enqueued.with(message)
		end
	end

end
