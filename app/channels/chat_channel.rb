class ChatChannel < ApplicationCable::Channel
  before_subscribe do
    @first_connection = ApplicationCable::Channel.user_connected?(ChatChannel, current_user) ? false : true
  end

  after_subscribe do
    broadcast_user_event(:join) if @first_connection
    if @first_connection && ApplicationCable::Channel.connections_num(ChatChannel) == 1
      Quizz.start
    end 
  end
  
  after_unsubscribe do 

  end

  def subscribed
    stream_for current_user
    stream_from 'chat'
  end

  def unsubscribed
    broadcast_user_event(:leave) unless ApplicationCable::Channel.user_connected?(ChatChannel, current_user)
    Quizz.stop unless ApplicationCable::Channel.any_connections?(ChatChannel)
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

  private
    def broadcast_user_event(event)
      UsersBroadcastJob.perform_later(current_user.username, event, current_user.score)
    end

end
