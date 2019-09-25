class QuizzJob < ApplicationJob
  queue_as :default

  def perform() 
  	redis = Redis.new
  	quizz = Quizz.new
  	redis.subscribe(:quiz) do |on|
  		on.message do |_, message|
        if message == 'stop'
          redis.unsubscribe
        else
          quizz.process message
        end
  		end
  	end
  end

end
