class ChatMessage < ApplicationRecord
  belongs_to :user, dependent: :destroy

  validates :content, presence: true, length: { maximum: 500 }
  validate :chat_subscription

  after_create_commit do
    ChatMessageBroadcastJob.perform_later(self)
    redis = Redis.new
    if content == '/start_quiz'
      QuizzJob.perform_later
      TickJob.perform_later
    elsif content == '/stop_quiz'
      redis.publish(:quiz, 'exit')
      redis.set('tick', 'stop')
    end
    redis.publish(:quiz, "chat_message:#{user_id}:#{content}")  
  end

  private
  	def chat_subscription
  		if user.nil? || !ChatMember.subscribed?(user) 
 				errors.add(:user, "not subscribed to a chat")
 			end
  	end
end
