class AuthorizationController < ApplicationController

  before_action :require_guest, only: :login
  before_action :require_user, only: :logout

  def login # post /users/login
    user = User.find_by_username params[:username]
    if user && user.authenticate(params[:password])
      render json: { token: user.token, username: user.username }
    else
      head 401
    end
  end

  def logout # delete /users/logout
    if @user.update_attribute(:token, User.generate_unique_secure_token)
      head 204
    else
      head 500
    end
  end

end
