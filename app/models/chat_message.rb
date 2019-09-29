class ChatMessage < ApplicationRecord
  belongs_to :user

  validates :content, presence: true, length: { maximum: 500 }

  after_create_commit do
    ChatMessageBroadcastJob.perform_later(id)
    Redis.new.publish(:quiz, "chat_message:#{user.id}:#{content}")  
  end

end
