require 'rails_helper'

RSpec.describe ChatMessagesController, type: :controller do

  let(:set_valid_user) do
    user = create(:user)
    request.headers['Authorization'] = "#{user.token}:#{user.username}"
  end

  let(:set_invalid_user) do
    request.headers['Authorization'] = "#{'a'*24}:JohnDoe"
  end

  let(:post_valid_message) do
    post :create, params: { content: "This is valid message" }
  end

  let(:post_invalid_message) do
    post :create, params: { content: "A"*501 }
  end

  describe "POST #create" do
    it "creates message with valid input" do
      set_valid_user
      post_valid_message
      expect(response).to have_http_status(204)
    end

    it "fails to create with invalid user" do
      set_invalid_user
      post_valid_message
      expect(response).to have_http_status(401)
    end

    it "fails to create with invalid input" do
      set_valid_user
      post_invalid_message
      expect(response).to have_http_status(422)
    end

    it "fails to create without any authorization headers" do
      post_valid_message
      expect(response).to have_http_status(401)
    end
  end

end
