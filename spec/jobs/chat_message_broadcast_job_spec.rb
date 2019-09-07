require 'rails_helper'

RSpec.describe ChatMessageBroadcastJob, type: :job do
	before { ActiveJob::Base.queue_adapter = :test }
  describe "#perform_now" do
  	it "should broadcast message" do 
  		message = ChatMessage.create(user: create(:user), content: "Chat message")
  		payload = { message: message.content, username: message.user.username }.to_json
      expect {
        ChatMessageBroadcastJob.perform_now(message)
      }.to have_broadcasted_to("chat").with(payload)
  	end
  end
end
