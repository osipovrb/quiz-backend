class ChatMember < ApplicationRecord
  belongs_to :user, dependent: :destroy

  def self.subscribe(user)
		ChatMember.find_or_create_by(user_id: user.id)
  	UsersAppearancesBroadcastJob.perform_later(user.username, :join)
  end

  def self.unsubscribe(user)
  	ChatMember.delete_by(user_id: user.id)
  	UsersAppearancesBroadcastJob.perform_later(user.username, :leave)
  end
end
