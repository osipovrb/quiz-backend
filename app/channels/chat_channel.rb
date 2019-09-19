class ChatChannel < ApplicationCable::Channel
  def subscribed
    ChatMember.subscribe(current_user)
    # send last 30 message after subscription
    last_messages = ChatMessage.includes(:user).limit(30).order(:desc)
    payload = last_messages.map do |m|
      {
        content: m.content,
        username: m.user.username,
        created_at: m.created_at.utc.to_i
      }
    end
    stream_for current_user
    broadcast_to current_user, payload.to_json
    stream_from "chat"
  end

  def unsubscribed
    ChatMember.unsubscribe(current_user)
  end

  def message(data)
    ChatMessage.create(user: current_user, content: data['content'])
  end
end
