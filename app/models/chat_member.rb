class ChatMember < ApplicationRecord
  belongs_to :user


  def self.subscribe(user)
		member = ChatMember.find_or_create_by(user_id: user.id)
    member.connections_num += 1
    member.save
    UsersBroadcastJob.perform_later(user.username, :join, user.score) if member.connections_num == 1
    Quizz.start if self.only_one_user_exists?
  end

  def self.unsubscribe(user)
    if member = find_by(user_id: user.id)
      if (member.connections_num -= 1) <= 0
    	  member.destroy
        UsersBroadcastJob.perform_later(user.username, :leave, user.score) 
        Quizz.stop if self.only_host_user_exists?
      else
        member.save
      end
    end
  end

  def self.subscribed?(user)
  	(ChatMember.find_by_id(user.id)) ? true : false
  end

  def self.only_host_user_exists?
    ChatMember.count == 1 && ChatMember.first.user.username == "Ведущий"
  end

  def self.only_one_user_exists?
    ChatMember.count == 1 && ChatMember.first.user.username != "Ведущий"
  end

end
