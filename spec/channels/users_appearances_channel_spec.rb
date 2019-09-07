require "rails_helper"

RSpec.describe UsersAppearancesChannel, type: :channel do
  it "subscribes and streams from users" do
    user = create(:user)
    stub_connection current_user: user
    subscribe
    expect(subscription).to be_confirmed
  end
end

