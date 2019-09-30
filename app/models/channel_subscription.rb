class ChannelSubscription < ApplicationRecord
  belongs_to :user

  def single?
    subscriptions_num == 1
  end

  def none?
    subscriptions_num == 0
  end
  
end
