require 'rails_helper'

RSpec.describe UsersBroadcastJob, type: :job do
  before { ActiveJob::Base.queue_adapter = :test }
  describe "#perform_now" do
    it "should broadcast message when user joined" do 
      user = create(:user)
      [:join, :leave].each do |event|
        expected_payload = { 
          event: event, 
          username: user.username, 
          score: user.score 
        }.to_json
        expect {
          UsersBroadcastJob.perform_now(user.username, event, user.score)
        }.to have_broadcasted_to("users").with(expected_payload)
      end
    end
  end
end
