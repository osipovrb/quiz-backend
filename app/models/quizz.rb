class Quizz

  def initialize
    @host_user = init_host_user
    ChatMember.subscribe(@host_user) unless ChatMember.subscribed?(@host_user)
    # TODO: заглушка
    @current_question = Riddle.get_random_riddle
    @timer = 5
    @state = :waiting_for_question
  end

  def process(message)
    if message.start_with?('exit')
      ChatMember.unsubscribe(@host_user)
    elsif message.start_with?('chat_message') && @state == :accepting_answers
      _, user_id, content = message.split(':', 3)
      check_answer(user_id, content)
    elsif message == 'tick'
      if @timer == 30 && @state == :accepting_answers
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
      username = User.find_by_id(user_id).try(:username)
      send_message(correct_answer_message(username))
      @state = :waiting_for_question
      @timer = 5
    end
  end

  # Start/stop methods
  def self.start
    Quizz.stop if Quizz.running?
    Redis.new.set 'quiz', 'running'
    QuizzJob.perform_later
    TickJob.perform_later
  end

  def self.stop
    r = Redis.new
    r.publish :quiz, 'stop'
    r.set 'quiz', 'stopped'
  end

  def self.running?
    r = Redis.new
    r.get('quiz') == 'running'
  end

  private
    def send_message(content)
      ChatMessage.create(user: @host_user, content: content)
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

    def correct_answer_message(username)
      "#{username}, правильно! Верный ответ: #{@current_question.answer}. Следующий вопрос через 5 секунд..."
    end

    def timeout_message
      "Время вышло! Никто не ответил правильно. Следующий вопрос через 5 секунд..."
    end
end