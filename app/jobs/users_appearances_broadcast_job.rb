class UsersAppearancesBroadcastJob < ApplicationJob
  queue_as :default

  def perform(username, event) # type = join || leave
  	payload = { event: event, username: username }
    ActionCable.server.broadcast "users", payload.to_json
  end
end
