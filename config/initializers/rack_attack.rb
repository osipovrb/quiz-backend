#class Rack::Attack

#  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new 

  ### Throttle Spammy Clients ###

  # All requests

#  throttle('req/ip', limit: 60, period: 60.seconds) do |req|
#    req.ip # unless req.path.start_with?('/assets')
#  end

  ### Prevent Brute-Force Login Attacks ###

  # Registration (post /users)

#  throttle('users/ip', limit: 5, period: 20.seconds) do |req|
#    if req.path == '/users' && req.post?
#      req.ip
#    end
#  end

  # Authorization (post /login)

#  throttle('login/username', limit: 10, period: 20.seconds) do |req|
#    if req.path == '/login' && req.post?
#      req.params['username'].presence
#    end
#  end

  # Session check (get /session)
#  throttle('session/ip', limit: 20, period: 10.seconds) do |req|
#    if req.path == '/session' 
#      req.ip
#    end
#  end

#end