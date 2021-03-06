class User < ApplicationRecord
  has_secure_password
  has_secure_token

  has_one :chat_member, dependent: :destroy
  has_many :chat_messages, dependent: :destroy
  has_many :channel_subscriptions, dependent: :destroy

  validates :username, presence: true, length: { minimum: 4, maximum: 20 }, uniqueness: true, exclusion: { in: %w(Ведущий) }
  validates :password, presence: true, length: { maximum: 72 }

  def self.authenticate_by_token(username, token)
  	return false unless User.token_valid?(token) 
  	User.find_by(username: username, token: token)
  end

  def self.token_valid?(token)
  	(token =~ /^[\d[a-zA-Z][^0OIl]]{24}$/) ? true : false
  end

end
