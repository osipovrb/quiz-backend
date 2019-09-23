class UsersChannel < ApplicationCable::Channel
  def subscribed
  end

  def unsubscribed
  end

  def start
    #unless current_user.instance_variable_defined?(:@users_channel_started)
      #broadcast_all_members
      AllusersBroadcastJob.perform_later(current_user)
      stream_from 'users'
      #current_user.instance_variable_set(:@users_channel_started, true)
    #end
  end

  private
    #def broadcast_all_members
    #  members = ChatMember.includes(:user).pluck(:username, :score).map { |u| {username: u[0], score: u[1]} }
    #  stream_for current_user
    #  broadcast_to current_user, { event: 'current_members', current_members: members }
    #end
end
