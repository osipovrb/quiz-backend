class ApplicationController < ActionController::API

	def require_user
		token, username = request.authorization.to_s.split(':', 2)
		unless @user ||= User.find_by(username: username, token: token)
			head 401
			return false
		end
	end

end
