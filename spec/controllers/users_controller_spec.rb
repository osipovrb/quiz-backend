require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before(:each) do
    10.times { User.create(generate(:user_seed)) } 
  end

  describe "GET #index" do
    it "returns all users" do
      get :index
      expect(response).to have_http_status(200)
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


end
