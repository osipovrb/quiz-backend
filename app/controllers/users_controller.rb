class UsersController < ApplicationController

  before_action :require_guest

  def create # post /users
  	user_params = params.require(:user).permit(:username, :password, :password_confirmation)
  	user = User.new(user_params)
  	if user.valid? && user.save
  		head 201
  	else
      render json: user.errors.full_messages, status: 422
  	end
  end

end
