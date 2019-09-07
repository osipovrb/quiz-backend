require "rails_helper"

RSpec.describe ChatChannel, type: :channel do
  it "subscribes and streams from chat" do
    user = create(:user)
    stub_connection current_user: user
    subscribe
    expect(subscription).to be_confirmed
  end
end