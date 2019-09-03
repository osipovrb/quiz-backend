class UsersController < ApplicationController

  before_action :require_guest, only: :create

  def index # get /users
  	users = User.all.select(:id, :username, :created_at).limit(100)
  	render json: users
  end

  def create # post /users
  	user_params = params.require(:user).permit(:username, :password, :password_confirmation)
  	user = User.new(user_params)
  	if user.valid? && user.save
  		head 201
  	else
      render json: user.errors.full_messages, status: 422
  	end
  end

  def drop # delete /users/drop
  	# !!! любой может вызвать этот метод
  	if User.destroy_all
  	  head 204
    else
      head 500
    end
  end

end
