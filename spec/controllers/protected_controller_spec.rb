require 'rails_helper'

RSpec.describe ProtectedController, type: :controller do

  describe "GET #index" do
    it "rejects non authorized user" do
        request.headers['Authorization'] = "#{'a'*24}:JaneDoe"
        get :index
        expect(response).to have_http_status(401)
    end

    it "rejects when authorization header is not set" do
    	get :index
    	expect(response).to have_http_status(400)
    end

    it "rejects malicious token" do
        request.headers['Authorization'] = "#{'a'*25}:Hackermann"
        get :index
        expect(response).to have_http_status(400)
    end

    it "gives some information when logged in" do
    	user = create(:user)
    	request.headers['Authorization'] = "#{user.token}:#{user.username}"
    	get :index
    	expect(response).to have_http_status(200)
    	expect(JSON.parse(response.body)["username"]).to eq user.username
    end
  end
end