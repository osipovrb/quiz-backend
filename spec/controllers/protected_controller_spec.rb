require 'rails_helper'

RSpec.describe ProtectedController, type: :controller do

  describe "GET #index" do
    it "reject non authorized user" do
    	get :index
    	expect(response).to have_http_status(401)
    end

    it "gives some information when logged in" do
    	user = create(:user)
    	request.headers['Authorization'] = "#{user.token}:#{user.username}"
    	get :index
    	expect(response).to have_http_status(200)
    	expect(JSON.parse(response.body)["username"]).to eq user.username
    end

    it "rejects logged out users" do
    	user = create(:user)
    	user.token = ''
    	request.headers['Authorization'] = "#{user.token}:#{user.username}"
    	get :index
    	expect(response).to have_http_status(401)
    end
  end
end