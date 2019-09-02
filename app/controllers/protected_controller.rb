class ProtectedController < ApplicationController
	before_action :require_user, only: :index

	def index
		render json: { username: @user.username }
	end

end
