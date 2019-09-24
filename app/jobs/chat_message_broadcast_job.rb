class ChatMessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
  	payload = { 
      event: 'message',
  		content: message.content, 
  		username: message.user.username, 
  		created_at: message.created_at.utc.to_f
  	}
    ActionCable.server.broadcast "chat", payload
  end
end