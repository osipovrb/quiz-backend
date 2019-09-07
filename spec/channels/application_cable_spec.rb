require "rails_helper"

RSpec.describe ApplicationCable::Connection, type: :channel do
  it "successfully connects" do
  	user = create(:user)
    connect "/cable", headers: { "Authorization" => "#{user.token}:#{user.username}" }
    expect(connection.current_user.id).to eq user.id
  end

  it "rejects connection with invalid user" do
  	invalid_authorization = { "Authorization" => "#{'a'*24}:JohnDoe" }
    expect { connect("/cable", headers: invalid_authorization) }.to have_rejected_connection
  end
end