class ApplicationController < ActionController::API

	# По какой-то причине авторизованный пользователь может попасть в зону,
	# предназначенную только для неавторизованных гостей (регистрация 
	# пользователя, авторизация, и т.п.). Этот метод не пропускает таких 
	# пользователей. Используется в фильтре before_action
	def require_guest
		unless request.try(:authorization).nil?
			head(403) 
			return false
		end
	end

	# Не позволяет попасть неавторизованным гостям в зону,
	# предназначенную для залогиненных пользователей. Также 
	# делает доступной @user (текущий залогиненный пользователь) 
	# в контроллере. Используется в фильтре before_action
	def require_user
		token, username = request.authorization.to_s.split(':', 2)
		if token.blank? || username.blank?
			head 401
			return false
		elsif !User.token_valid?(token)
			head 400 
			return false
		elsif !@user ||= User.authenticate_by_token(username, token)
			head 401
			return false
		end
	end

end
