# Cleanup channel subscription from users, who was
# connected when server has restarted
begin
  ChannelSubscription.destroy_all
rescue
end