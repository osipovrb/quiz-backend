class User < ApplicationRecord
  has_secure_password
  validates :username, presence: true, length: { maximum: 32 }, uniqueness: true
  validates :password, presence: true, length: { maximum: 72 }
end
