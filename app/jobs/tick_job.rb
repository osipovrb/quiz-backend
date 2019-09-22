class TickJob < ApplicationJob
  queue_as :default

  def perform() 
    redis = Redis.new
    terminate = false
    while !terminate do
      redis.publish(:quiz, 'tick')
      terminate = true unless Quizz.running?
      sleep 1
    end
  end

end
