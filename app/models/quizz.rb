class Quizz

  def initialize
    @host_user = init_host_user
    # TODO: заглушка
    @current_question = Riddle.get_random_riddle
    @timer = 5
    @state = :waiting_for_question
    @redis = Redis.new
    start_ticker
  end

  def process(message)
    if message.start_with?('chat_message') && @state == :accepting_answers
      _, user_id, content = message.split(':', 3)
      check_answer(user_id, content)
    elsif message == 'stop'
      stop_ticker
    elsif message == 'tick'
      if @timer == 30 && @state == :accepting_answers && @current_question.answer.length >= 3
        send_message(hint_message)
        @timer -= 1
      elsif @timer == 0
        if @state == :waiting_for_question
          # TODO: тащить новые @current_question
          send_message(question_message)
          @state = :accepting_answers
          @timer = 60
        elsif @state == :accepting_answers
          send_message(timeout_message)
          @state = :waiting_for_question
          @timer = 5
          @current_question = Riddle.get_random_riddle
        end
      else
        @timer -= 1
      end
    end
  end

  def start_new_question
    @state = :waiting_for_question
    @timer = 5
  end

  def check_answer(user_id, answer)
    return nil if @current_question.nil?
    if @current_question.answer == answer.strip.downcase
      user = User.find_by_id(user_id)
      plus_score = (@timer > 30 ) ? 2 : 1
      score = user.score + plus_score
      user.update_attribute(:score, score)
      send_message(correct_answer_message(user.username, plus_score, score))
      send_score_update(user.username, user.score)
      @current_question = Riddle.get_random_riddle
      @state = :waiting_for_question
      @timer = 5
    end
  end

  # Start/stop methods
  def self.start
    Redis.new.set 'quiz', 'running'
    QuizzJob.perform_later
  end

  def self.stop
    r = Redis.new
    r.set 'quiz', 'stopped'
    r.publish :quiz, 'stop'
  end

  def self.running?
    Redis.new.get('quiz') == 'running'
  end

  private

    def start_ticker
      @ticker ||= Concurrent::TimerTask.new(execution_interval: 1) do        
        @redis.publish(:quiz, 'tick')
      end
      @ticker.execute
    end

    def stop_ticker
      @ticker.shutdown
    end

    def send_message(content)
      ChatMessage.create(user: @host_user, content: content)
    end

    def send_score_update(username, score)
      UsersBroadcastJob.perform_later(username, :score, score)
    end

    def init_host_user
      host = User.find_by_username("Ведущий")
      if host.nil?
        host = User.new
        host.username = "Ведущий"
        host.save(validate: false)
        host.update_attribute(:token, nil)
      end
      host
    end

    def question_message
      "Внимание, вопрос! #{@current_question.question}"
    end

    def hint_message
      filler = ' _' * (@current_question.answer.length-2)
      hint = "#{@current_question.answer[0]} #{@current_question.answer[1]}#{filler}"
      "Подсказка: #{hint}"
    end

    def correct_answer_message(username, score, total_score)
      score = (score == 2) ? "2 очка" : "1 очко"
      "#{username}, правильно! + #{score} (всего очков: #{total_score}). Верный ответ: #{@current_question.answer}. Следующий вопрос через 5 секунд..."
    end

    def timeout_message
      "Время вышло! Никто не ответил правильно. Ответ: #{@current_question.answer}. Следующий вопрос через 5 секунд..."
    end 
end