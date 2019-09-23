class ChatChannel < ApplicationCable::Channel
  def subscribed
    ChatMember.subscribe(current_user)
  end

  def unsubscribed
    ChatMember.unsubscribe(current_user)
  end

  def start
    #unless current_user.instance_variable_defined?(:@chat_channel_started)
      broadcast_last_messages
      stream_from 'chat'
      #current_user.instance_variable_set(:@chat_channel_started, true)
    #end
  end

  def message(data)
    ChatMessage.create(user: current_user, content: data['content'])
  end

  private
    def broadcast_last_messages(messages_num: 30)
      last_messages = ChatMessage.includes(:user).limit(messages_num).order(id: :desc).map do |m|
        {
          content: m.content,
          username: m.user.username,
          created_at: m.created_at.utc.to_i
        }
      end
      stream_for current_user
      broadcast_to current_user, { event: 'last_messages', last_messages: last_messages }
    end
end
