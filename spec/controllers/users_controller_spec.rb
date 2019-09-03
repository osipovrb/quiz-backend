require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before { create :user, username: generate(:username_seed) }

  describe "GET #index" do
    it "returns all users" do
      get :index
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq User.count
    end
  end

  describe "POST #create" do
    it "creates user with valid input" do
      initial_user_count = User.count
      post :create,  params: { user: attributes_for(:user, username: generate(:username_seed)) }
      expect(response).to have_http_status(201)
      expect(User.count).to eq (initial_user_count + 1)
    end

    # traits with invalid input
    FactoryBot.factories[:user].definition.defined_traits.map(&:name).each do |trait_name| 
      it "fails to create with #{trait_name}" do
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
        post :login, params: { user: attributes_for(:user, username: generate(:username_seed)) }
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
        token = user.token
        request.headers['Authorization'] = "#{token}:#{user.username}" 
        delete :logout
        expect(response).to have_http_status(204)
        expect(token).not_to eq user.reload.token
      end
    end
  end

end
