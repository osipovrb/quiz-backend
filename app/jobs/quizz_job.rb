class QuizzJob < ApplicationJob
  queue_as :default

  def perform() 
  	redis = Redis.new
  	quizz = Quizz.new
  	redis.subscribe(:quiz) do |on|
  		on.message do |channel, message|
        quizz.process message
				redis.unsubscribe if message == "exit"
  		end
  	end
  end

end
