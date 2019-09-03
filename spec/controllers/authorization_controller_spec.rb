require 'rails_helper'

RSpec.describe AuthorizationController, type: :controller do

  describe "POST #login" do
    it "logs in valid user and returns token" do
      user = create(:user)
      post :login, params: { username: user.username, password: user.password }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq ({ "token" => user.token, "username" => user.username })
    end

    it "fails to log in wrong user" do
      post :login, params: { user: attributes_for(:user, username: generate(:username_seed)) }
      expect(response).to have_http_status(401)
    end
  end

  describe "DELETE #logout" do
    it "rejects when user is not logged in" do
      request.headers['Authorization'] = "#{'a'*24}:JohnDoe"
      delete :logout
      expect(response).to have_http_status(401)
    end

    it "rejects with malicious token" do
      request.headers['Authorization'] = "#{'a'*25}:JohnDoe" 
      delete :logout
      expect(response).to have_http_status(400)
    end

    it "destroys token when user is logged in" do
      user = create(:user)
      token = user.token
      request.headers['Authorization'] = "#{token}:#{user.username}" 
      delete :logout
      expect(response).to have_http_status(204)
      expect(token).not_to eq user.reload.token
    end
  end

end
