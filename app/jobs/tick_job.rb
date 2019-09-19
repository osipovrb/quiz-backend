class TickJob < ApplicationJob
  queue_as :default

  def perform() 
    redis = Redis.new
    terminate = false
    while !terminate do
      redis.publish(:quiz, 'tick')
      if redis.get('tick') == 'stop'
        redis.set('tick', '')
        terminate = true
      end
      sleep 1
    end
  end

end
