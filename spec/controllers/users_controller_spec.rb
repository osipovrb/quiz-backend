require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before do
    10.times { create :user, username: generate(:username_seed) } 
  end

  describe "GET #index" do
    it "returns all users" do
      get :index
      expect(response).to have_http_status(200)
      expect(User.count).to eq 10
      expect(JSON.parse(response.body).count).to eq 10
    end
  end

  describe "POST #create" do
    it "creates user with valid input" do
      post :create,  params: { user: attributes_for(:user) }
      expect(response).to have_http_status(201)
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
      expect(response).to have_http_status(200)
      expect(response.body.blank?).to eq true
    end
  end

  context "Login & logout" do
    describe "POST #login" do
      it "logs in valid user and returns token" do
        user = create(:user)
        post :login, params: { username: user.username, password: user.password }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq ({ "username" => user.username, "token" => user.token })
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
        post :login, params: { username: user.username, password: user.password }
        token = JSON.parse(response.body)[:token]
        request.headers['Authorization'] = "#{user.token}:#{user.username}" 
        delete :logout
        expect(response).to have_http_status(200)
        user.reload
        expect(user.token).to be_blank
      end
    end
  end

end
