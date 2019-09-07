require 'rails_helper'

RSpec.describe ChatMember, type: :model do
	describe "validations" do
		it { should belong_to(:user) }
	end

	describe "enqueing jobs" do
		before do 
			ActiveJob::Base.queue_adapter = :test
			@user = create(:user)
		end

		it "should enqueue a job after user subscription" do
			ChatMember.subscribe(@user)
			expect(ChatMember.subscribed?(@user)).to eq true
			expect(UsersAppearancesBroadcastJob).to have_been_enqueued.with(@user.username, :join)
		end

		it "should enqueue another job after user unsubscription" do
			ChatMember.unsubscribe(@user)
			expect(ChatMember.subscribed?(@user)).to eq false
			expect(UsersAppearancesBroadcastJob).to have_been_enqueued.with(@user.username, :leave)
		end

	end
end
