class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
    ChatMember.subscribe(current_user)
  end

  def unsubscribed
    ChatMember.unsubscribe(current_user)
  end

  def get_last_messages
      last_messages = ChatMessage.includes(:user).limit(messages_num).order(id: :desc).map do |m|
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

  def start_stream # REFACTOR: move to ApplicationCable::Channel class
    unless current_user.instance_variable_defined?(:@chat_channel_started)
      stream_from 'chat'
      current_user.instance_variable_set(:@chat_channel_started, true)
    end
  end

end
