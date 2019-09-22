class ChatMessage < ApplicationRecord
  belongs_to :user

  validates :content, presence: true, length: { maximum: 500 }
  validate :chat_subscription

  after_create_commit do
    ChatMessageBroadcastJob.perform_later(id)
    Redis.new.publish(:quiz, "chat_message:#{user.id}:#{content}")  
  end

  private
  	def chat_subscription
  		if user.nil? || !ChatMember.subscribed?(user) 
 				errors.add(:user, "not subscribed to a chat")
 			end
  	end
end
