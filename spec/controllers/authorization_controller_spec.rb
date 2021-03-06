require 'rails_helper'

RSpec.describe AuthorizationController, type: :controller do

  let(:set_random_authorization_header) { request.headers['Authorization'] = "#{'a'*24}:JonhDoe" }
  let(:set_malicious_authorization_header) { request.headers['Authorization'] = "#{'a'*25}:Hackerman" }

  let(:post_valid_user) do
    user = create(:user)
    post :login, params: { username: user.username, password: user.password }
    return user
  end

  let(:post_invalid_user) do
    post :login, params: { user: attributes_for(:user, username: generate(:username_seed)) }
  end

  describe "POST #login" do
    it "logs in valid user and returns token" do
      user = post_valid_user
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq ({ "token" => user.token, "username" => user.username })
    end

    it "fails to log in wrong user" do
      post_invalid_user
      expect(response).to have_http_status(401)
    end

    it "rejects when authorization header is set" do
      set_random_authorization_header
      post_valid_user
      expect(response).to have_http_status(403)
    end
  end

  describe "DELETE #logout" do
    it "reqire authorization when user is not logged in" do
      delete :logout
      expect(response).to have_http_status(401) 
    end

    it "rejects with malicious token" do
      set_malicious_authorization_header 
      delete :logout
      expect(response).to have_http_status(400)
    end

    it "destroys token when user is logged in" do
      user = post_valid_user
      token = user.token
      request.headers['Authorization'] = "#{token}:#{user.username}" 
      delete :logout
      expect(response).to have_http_status(204)
      expect(token).not_to eq user.reload.token
    end
  end

  describe "GET #session" do
    it "rejects non authorized user" do
      set_random_authorization_header
      get :session
      expect(response).to have_http_status(401)
    end

    it "reqire authorization when authorization header is not set" do
      get :session
      expect(response).to have_http_status(401)
    end

    it "rejects malicious token" do
      set_malicious_authorization_header
      get :session
      expect(response).to have_http_status(400)
    end

    it "gives some information when logged in" do
      user = post_valid_user
      request.headers['Authorization'] = "#{user.token}:#{user.username}"
      get :session
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["username"]).to eq user.username
    end
  end

end
