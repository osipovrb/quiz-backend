class Rack::Attack

  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new 

  ### Throttle Spammy Clients ###

  # All requests

  throttle('req/ip', limit: 30, period: 60.seconds) do |req|
    req.ip # unless req.path.start_with?('/assets')
  end

  ### Prevent Brute-Force Login Attacks ###

  # Registration (post /users)

  throttle('users/ip', limit: 5, period: 20.seconds) do |req|
    if req.path == '/users' && req.post?
      req.ip
    end
  end

  # Authorization (post /sessions)

  throttle("sessions/username", limit: 10, period: 20.seconds) do |req|
    if req.path == '/sessions' && req.post?
      req.params['username'].presence
    end
  end
  
end