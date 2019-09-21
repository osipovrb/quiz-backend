class Riddle < ApplicationRecord
  def self.get_random_riddle
    Riddle.order('RANDOM()').limit(1).first
  end
end
