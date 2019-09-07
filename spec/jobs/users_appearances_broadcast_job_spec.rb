require 'rails_helper'

RSpec.describe UsersAppearancesBroadcastJob, type: :job do
  before { ActiveJob::Base.queue_adapter = :test }
  describe "#perform_now" do
    it "should broadcast message when user joined" do 
      user = create(:user)
      [:join, :leave].each do |event|
        payload = { event: event, username: user.username }.to_json
        expect {
          UsersAppearancesBroadcastJob.perform_now(user.username, event)
        }.to have_broadcasted_to("users").with(payload)
      end
    end
  end
end
