class UsersController < ApplicationController
  def index
  	# !!! beware of 9'000'000 records - no pagination
  	users = User.all
  	render json: users
  end

  def create
  	user_params = params.require(:user).permit(:username, :password)
  	user = User.new(user_params)
  	if user.valid? && user.save
  		head 201
  	else
  		head 422
  	end
  end

  def drop
  	# !!! anyone can call this method
  	User.destroy_all
  	head 200
  end
end
