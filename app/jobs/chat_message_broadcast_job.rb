class ChatMessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
  	payload = { message: message.content, username: message.user.username }
    ActionCable.server.broadcast "chat", payload.to_json
  end
end