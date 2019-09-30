class UsersChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
    stream_from 'users'
  end

  def unsubscribed
  end

  def get_all_members
    members = ChannelSubscription.where(channel: 'ChatChannel').
      includes(:user).
      pluck(:username, :score).
      map { |u| { username: u.first, score: u.last } } 
    broadcast_to current_user, { event: 'current_members', current_members: members }
  end

  private
    def chat_members
      ApplicationCable::Channel.connected_users_for(ChatChannel)
    end
end
