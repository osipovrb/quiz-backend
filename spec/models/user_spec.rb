# TODO: DRY via shared modules
require 'rails_helper'

RSpec.describe User, type: :model do
  it 'should have username less or equal than 32 symbols' do
  	user = User.new(username: 'a'*33, password: 'a'*72)
  	expect(user.valid?).to eq false
  end

  it 'should have password less or equal than 72 symbols' do
  	user = User.new(username: 'User', password: 'a'*73)
  	expect(user.valid?).to eq false
  end

  it 'should have unique username' do
  	User.create!(username: 'User', password: 'SomePassword')
  	user = User.new(username: 'User', password: 'SomePassword')
  	expect(user.valid?).to eq false
  end

   it 'should be valid with vaild input' do
    user = User.new(username: 'SomeUser', password: 'SomePassword')
    expect(user.valid?).to eq true
  end
end
