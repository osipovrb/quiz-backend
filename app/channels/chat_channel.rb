class ChatChannel < ApplicationCable::Channel

  def subscribed
    subscription = subscribe
    if subscription.single? # first tab/browser/etc connection
      broadcast_user_event :join
      Quizz.start if subscribers_count == 1
    end
    stream_for current_user
    stream_from 'chat'
  end

  def unsubscribed
    subscription = unsubscribe
    if subscription.none? # user disconnected from all tabs/browsers/etc
      subscription.destroy
      broadcast_user_event :leave
      Quizz.stop if subscribers_count == 0
    end
  end

  def get_all_members
    members = ChannelSubscription.where(channel: 'ChatChannel').
      includes(:user).
      pluck(:username, :score).
      map { |u| { username: u.first, score: u.last } } 
    broadcast_to current_user, { event: 'current_members', current_members: members }
  end

  def get_last_messages
      last_messages = ChatMessage.includes(:user).limit(30).order(id: :desc).map do |m|
        {
          content: m.content,
          username: m.user.username,
          created_at: m.created_at.utc.to_f 
        }
      end
      broadcast_to current_user, { event: 'last_messages', last_messages: last_messages }
  end

  def send_message(data)
    ChatMessage.create(user: current_user, content: data['content'])
  end

  private
    def broadcast_user_event(event)
      UsersBroadcastJob.perform_later(current_user.username, event, current_user.score)
    end

    def alter_subscription(action = nil)
      subscription = ChannelSubscription.find_or_create_by(channel: 'ChatChannel', user: current_user)
      case action
        when :join then subscription.subscriptions_num += 1 && subscription.save
        when :leave then subscription.subscriptions_num -= 1 && subscription.save
      end
      subscription
    end

    def subscribe
      alter_subscription :join
    end

    def unsubscribe
      alter_subscription :leave
    end
    
    def subscribers_count
      ChannelSubscription.where(channel: 'ChatChannel').count 
    end

end
