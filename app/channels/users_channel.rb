class UsersChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def unsubscribed
  end

  def get_all_members
    members = ChatMember.includes(:user).pluck(:username, :score).map { |u| {username: u[0], score: u[1]} }
    broadcast_to current_user, { event: 'current_members', current_members: members }
  end

  def start_stream # REFACTOR: move to ApplicationCable::Channel class
    unless current_user.instance_variable_defined?(:@users_channel_started)
      stream_from 'users'
      current_user.instance_variable_set(:@users_channel_started, true)
    end
  end

end
