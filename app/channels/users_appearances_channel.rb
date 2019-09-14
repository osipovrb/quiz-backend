class UsersAppearancesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "users"
    members = ChatMember.includes(:user).pluck(:username)
    broadcast_to current_user, members.to_json
  end

  def unsubscribed
  end
end
