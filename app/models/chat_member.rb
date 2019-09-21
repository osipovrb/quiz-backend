class ChatMember < ApplicationRecord
  belongs_to :user

  after_create { UsersBroadcastJob.perform_later(user.username, :join) if connections_num == 0 }
  after_destroy { UsersBroadcastJob.perform_later(user.username, :leave) }
  after_commit { quizz_start_stop }

  def self.subscribe(user)
		member = ChatMember.find_or_create_by(user_id: user.id)
    member.connections_num += 1
    member.save
  end

  def self.unsubscribe(user)
    member = find_by(user_id: user.id)
    if (member.connections_num -= 1) <= 0
  	  member.destroy
    else
      member.save
    end
  end

  def self.subscribed?(user)
  	(ChatMember.find_by_id(user.id)) ? true : false
  end

  private
    def quizz_start_stop
      if ChatMember.any?
        Quizz.start
      elsif Quizz.running?
        Quizz.stop
      end
    end
end
