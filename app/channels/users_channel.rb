class UsersChannel < ApplicationCable::Channel
  def subscribed
    broadcast_all_members
    stream_from 'users'
  end

  def unsubscribed
  end

  private
    def broadcast_all_members
      members = ChatMember.includes(:user).pluck(:username, :score).map { |u| {username: u[0], score: u[1]} }
      stream_for current_user
      broadcast_to current_user, members.to_json
    end
end
