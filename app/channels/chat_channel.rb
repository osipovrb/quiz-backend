class ChatChannel < ApplicationCable::Channel
  def subscribed
  	ChatMember.subscribe(current_user)
    stream_from "chat"
  end

  def unsubscribed
    ChatMember.unsubscribe(current_user)
  end

  def message(content: nil)
  	ChatMessage.create(user_id: current_user.id, content: content)
  end

  def get_all_members
  	members = ChatMember.includes(:user).all.map { |m| m.user.username }
  	broadcast_to(current_user, "chat", members.to_json)
  end
end
