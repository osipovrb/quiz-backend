class UsersController < ApplicationController

  before_action  :require_user, only: :logout

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
  		head 422
  	end
  end

  def drop # delete /users/drop
  	# !!! любой может вызвать этот метод
  	User.destroy_all
  	head 204
  end

  def login # post /users/login
    user = User.find_by_username params[:username]
    if user && user.authenticate(params[:password])
      user.regenerate_token if user.token.blank?
      render json: { token: user.token, username: user.username }
    else
      head 401
    end
  end

  def logout # delete /users/logout
    @user.update_attribute(:token, '')
    head 204
  end

end
