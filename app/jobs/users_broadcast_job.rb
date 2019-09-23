class UsersBroadcastJob < ApplicationJob
  queue_as :default

  def perform(username, event, score) # type = join || leave || score
  	payload = { event: event, username: username, score: score }
    ActionCable.server.broadcast "users", payload
  end
end
