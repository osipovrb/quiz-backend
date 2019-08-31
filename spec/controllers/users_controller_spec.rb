# TODO: DRY via shared modules
require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before do # seed database with some users
    10.times do |index|
      User.create!(username: "SomeUser_#{index}", password: 'SomePassword')
    end
  end

  let(:invalid_users) do 
    [
      {username: 'a' * 33, password: 'SomePassword'},
      {username: 'SomeUser', password: 'a' * 73}
    ]
  end

  describe "GET #index" do
    it "returns all users" do
      get :index
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).count).to eq 10
    end
  end

  describe "POST #create" do
    it "creates user with valid input" do
      post :create,  params: { user: { username: 'SomeUser', password: 'SomePassword' } }
      expect(response).to have_http_status(201)
    end

    it "fails to create user with invalid input" do
      invalid_users.each do |invalid_user|
        post :create,  params: { user: invalid_user }
        expect(response).to have_http_status(422)
      end
    end

    it "fails to create user with non-unique username" do
      post :create, params: { user: { username: 'SomeUser_1', password: 'SomePassword' } }
      expect(response).to have_http_status(422)
    end
  end

  describe "DELETE #drop" do
    it "deletes all users" do
      expect(User.count).to eq 10
      delete :drop
      expect(response).to have_http_status(200)
      expect(User.count).to eq 0
    end
  end

end
