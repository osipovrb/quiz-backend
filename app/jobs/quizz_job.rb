class QuizzJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false
  
  def perform() 
  	redis = Redis.new
  	quizz = Quizz.new
  	redis.subscribe(:quiz) do |on|
  		on.message do |_, message|
        quizz.process message
        redis.unsubscribe if message == 'stop'
  		end
  	end
  end

end
