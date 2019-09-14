class ChatChannel < ApplicationCable::Channel
  def subscribed
    ChatMember.subscribe(current_user)
    stream_from "chat"
  end

  def unsubscribed
    ChatMember.unsubscribe(current_user)
  end

  def message(data)
    ChatMessage.create(user: current_user, content: data['message'])
  end
end
