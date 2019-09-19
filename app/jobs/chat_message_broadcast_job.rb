class ChatMessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
  	payload = { 
  		message: message.content, 
  		username: message.user.username, 
  		created_at: message.created_at.utc.to_i
  	}
    ActionCable.server.broadcast "chat", payload.to_json
  end
end