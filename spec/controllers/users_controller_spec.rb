require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before do
    10.times { create :user, username: generate(:username_seed) } 
  end

  describe "GET #index" do
    it "returns all users" do
      get :index
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq User.count
    end
  end

  describe "POST #create" do
    it "creates user with valid input" do
      user_count = User.count + 1
      post :create,  params: { user: attributes_for(:user) }
      expect(response).to have_http_status(201)
      expect(User.count).to eq user_count
    end

    FactoryBot.factories[:user].definition.defined_traits.map(&:name).each do |trait_name| 
      it "fails with #{trait_name}" do
        post :create,  params: { user: attributes_for(:user, trait_name) }
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "DELETE #drop" do
    it "deletes all users" do
      delete :drop
      expect(response).to have_http_status(204)
      expect(response.body.blank?).to eq true
    end
  end

  context "Login & logout" do
    describe "POST #login" do
      it "logs in valid user and returns token" do
        user = create(:user)
        post :login, params: { username: user.username, password: user.password }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq ({ "token" => user.token, "username" => user.username })
      end

      it "fails to log in wrong user" do
        post :login, params: { user: attributes_for(:user) }
        expect(response).to have_http_status(401)
      end
    end

    describe "DELETE #logout" do
      it "rejects when user is not logged in" do
        delete :logout
        expect(response).to have_http_status(401)
      end

      it "destroys token when user is logged in" do
        user = create(:user)
        request.headers['Authorization'] = "#{user.token}:#{user.username}" 
        delete :logout
        old_token = user.token
        new_token = user.reload.token
        expect(old_token).not_to eq new_token
        expect(response).to have_http_status(204)
      end
    end
  end

end
