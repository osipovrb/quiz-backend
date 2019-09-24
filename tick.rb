require 'redis'

Thread.new do
  redis = Redis.new
  terminate = false
  while !terminate do
    redis.publish(:quiz, 'tick')
    terminate = true if redis.get('tick') == 'stop'
    sleep 1
  end
end.join