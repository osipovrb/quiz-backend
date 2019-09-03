require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before { create :user, username: generate(:username_seed) }

  let(:post_valid_user) do
    post :create,  params: { user: attributes_for(:user, username: generate(:username_seed)) } 
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
      initial_user_count = User.count
      post_valid_user
      expect(response).to have_http_status(201)
      expect(User.count).to eq (initial_user_count + 1)
    end

    it "rejects when authorization header is set" do
      request.headers['Authorization'] = "#{'a'*24}:JohnDoe"
      post_valid_user
      expect(response).to have_http_status(403)
    end

    # traits with invalid input
    FactoryBot.factories[:user].definition.defined_traits.map(&:name).each do |trait_name| 
      it "fails to create with #{trait_name}" do
        post :create,  params: { user: attributes_for(:user, trait_name) }
        expect(response).to have_http_status(422)
        expect(response.body.blank?).not_to eq true
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

end
