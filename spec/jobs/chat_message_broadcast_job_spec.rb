require 'rails_helper'

RSpec.describe ChatMessageBroadcastJob, type: :job do
	before { ActiveJob::Base.queue_adapter = :test }
  describe "#perform_now" do
  	it "should broadcast message" do 
      user = create(:user)
      ChatMember.subscribe(user)
  		message = ChatMessage.create!(user: user, content: "Chat message")
  		expected_payload = { 
        content: message.content, 
        username: message.user.username, 
        created_at: message.created_at.utc.to_i
      }.to_json
      expect {
        ChatMessageBroadcastJob.perform_now(message.id)
      }.to have_broadcasted_to("chat").with(expected_payload)
  	end
  end
end
