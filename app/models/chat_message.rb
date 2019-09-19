class ChatMessage < ApplicationRecord
  belongs_to :user, dependent: :destroy

  validates :content, presence: true, length: { maximum: 500 }
  validate :chat_subscription

  after_create_commit { ChatMessageBroadcastJob.perform_later(self) } 

  private
  	def chat_subscription
  		if user.nil? || !ChatMember.subscribed?(user) 
 				errors.add(:user, "not subscribed to a chat")
 			end
  	end
end
