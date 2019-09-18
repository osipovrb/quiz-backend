class UsersChannel < ApplicationCable::Channel
  def subscribed
    members = ChatMember.includes(:user).pluck(:username)
    broadcast_to current_user, members.to_json
    stream_from "users"
  end

  def unsubscribed
  end
end
