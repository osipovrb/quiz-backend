class ApplicationController < ActionController::API

	def require_guest
		head(403) unless request.try(:authorization).nil?
	end

	def require_user
		token, username = request.authorization.to_s.split(':', 2)
		unless User.token_valid?(token)
			head 400 
			return false
		end
		unless @user ||= User.authenticate(username, token)
			head 401
			return false
		end
	end

end
