class ChatMessage < ApplicationRecord
  belongs_to :user, dependent: :destroy

  validates :content, presence: true, length: { maximum: 500 }

  after_create_commit { ChatMessageBroadcastJob.perform_later(self) } 
end
