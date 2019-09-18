class AuthorizationController < ApplicationController

  before_action :require_guest, only: :login
  before_action :require_user, only: [:logout, :session] 

  def login # post /login
    user = User.find_by_username params[:username]
    if user && user.authenticate(params[:password])
      render json: { token: user.token, username: user.username }
    else
      head 401
    end
  end

  def logout # delete /logout
    if @user.update_attribute(:token, User.generate_unique_secure_token)
      head 204
    else
      head 500
    end
  end

  def session # get /session
    render json: { username: @user.username }
  end

end
