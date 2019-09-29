class ChatChannel < ApplicationCable::Channel
  def subscribed
    ChatMember.subscribe(current_user)
    stream_for current_user
    stream_from 'chat'
  end

  def unsubscribed
    ChatMember.unsubscribe(current_user)
  end

  def get_last_messages
      last_messages = ChatMessage.includes(:user).limit(30).order(id: :desc).map do |m|
        {
          content: m.content,
          username: m.user.username,
          created_at: m.created_at.utc.to_f 
        }
      end
      broadcast_to current_user, { event: 'last_messages', last_messages: last_messages }
  end

  def send_message(data)
    ChatMessage.create(user: current_user, content: data['content'])
  end

end
