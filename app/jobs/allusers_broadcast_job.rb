class AllusersBroadcastJob < ApplicationJob
  queue_as :default

  def perform(target_user) 
    members = ChatMember.includes(:user).pluck(:username, :score).map { |u| {username: u[0], score: u[1]} }
    stream_for target_user
    broadcast_to target_user, { event: 'current_members', current_members: members }
  end
end
