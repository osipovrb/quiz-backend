module ApplicationCable
  class Channel < ActionCable::Channel::Base

    def self.connected_users_for(channel_class) 
      ids = Channel.get_subscription_ids_for channel_class 
      User.find(ids)
    end

    def self.connections_num(channel_class)
      Channel.get_subscription_ids_for(channel_class).count
    end

    def self.user_connected?(channel_class, user)
      Channel.get_subscription_ids_for(channel_class).include?(user.id.to_s)
    end

    def self.any_connections?(channel_class)
      Channel.get_subscription_ids_for(channel_class).any?
    end

    private
      def self.get_subscription_ids_for(channel_class, identifier_class = User)
        pubsub = ActionCable.server.pubsub
        channel_with_prefix = pubsub.send(:channel_with_prefix, channel_class.channel_name)
        channels = pubsub.send(:redis_connection).pubsub('channels', "#{channel_with_prefix}:*")
        subscriptions = channels.map do |channel|
          Base64.decode64(channel.match(/^#{Regexp.escape(channel_with_prefix)}:(.*)$/)[1])
        end
        gid_uri_pattern = /^gid:\/\/.*\/#{Regexp.escape(identifier_class.to_s)}\/(\d+)$/
        ids = subscriptions.map do |subscription|
          subscription.match(gid_uri_pattern)
        end.compact.map { |match| match[1] } # Внимание: ID в массиве - строки
      end
  end
end
