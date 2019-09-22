require 'rails_helper'

RSpec.describe ChatMember, type: :model do
	describe "validations" do
		it { should belong_to(:user) }
	end

	describe "proper subscriptions" do
		before do 
			ActiveJob::Base.queue_adapter = :test
			@user = create(:user)
		end

		let(:subscribe_once)    { ChatMember.subscribe(@user) }
		let(:unsubscribe_once)  { ChatMember.unsubscribe(@user) }
		let(:subscribe_twice)   { ChatMember.subscribe(@user) && ChatMember.subscribe(@user) }
		let(:unsubscribe_twice) { ChatMember.unsubscribe(@user) && ChatMember.unsubscribe(@user) }

		it "should enqueue a job after user subscription" do
			subscribe_once
			expect(ChatMember.subscribed?(@user)).to eq true
			expect(UsersBroadcastJob).to have_been_enqueued.with(@user.username, :join, @user.score)
		end

		it "should increment connections_num after second subscription" do
			subscribe_twice
			expect(ChatMember.find_by(user: @user).connections_num).to eq 2
		end

		it "should not enqueue a job before all connections are gone" do
			subscribe_twice
			unsubscribe_once
			expect(ChatMember.find_by(user: @user).connections_num).to eq 1
			expect(UsersBroadcastJob).not_to have_been_enqueued.with(@user.username, :leave, @user.score)
		end

		it "should enqueue job when user leaves and no connections are left" do
			subscribe_twice
			unsubscribe_twice
			expect(ChatMember.subscribed?(@user)).to eq false
			expect(UsersBroadcastJob).to have_been_enqueued.with(@user.username, :leave, @user.score)
		end

		it "should enqueue QuizzJob after user subscription" do
			subscribe_once
			expect(Quizz.running?).to eq true
		end

	end
end
