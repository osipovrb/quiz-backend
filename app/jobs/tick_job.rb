class TickJob < ApplicationJob
  queue_as :default

  def perform() 
    redis = Redis.new
    terminate = false
    while !terminate do
      sleep 1
      redis.publish(:quiz, 'tick')
      terminate = true unless Quizz.running?
    end
  end

end
