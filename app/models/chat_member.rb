class ChatMember < ApplicationRecord
  belongs_to :user


  def self.subscribe(user)
		member = self.increment_connections_num(user)
    UsersBroadcastJob.perform_later(user.username, :join, user.score) if member.connections_num == 1
    Quizz.start if ChatMember.count == 1
  end

  def self.unsubscribe(user)
    member = self.decrement_connections_num(user)
    if member.connections_num <= 0
    	member.destroy
      UsersBroadcastJob.perform_later(user.username, :leave, user.score) 
      Quizz.stop if ChatMember.count == 0
    end
  end

  def self.subscribed?(user)
  	ChatMember.exists(user.id)
  end

# -- helpers
  private
    def self.increment_connections_num(user)
      member = ChatMember.find_or_create_by(user_id: user.id)
      member.connections_num += 1
      member.save && member
    end

    def self.decrement_connections_num(user)
      member = ChatMember.find_by(user_id: user.id) 
      unless member.nil?
        member.connections_num -= 1
        member.save && member
      end
    end
end
