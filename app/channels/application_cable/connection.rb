module ApplicationCable
  class Connection < ActionCable::Connection::Base
  	identified_by :current_user

    def connect
      self.current_user = find_user
    end

    private
      def find_user
      	token, username = request.authorization.to_s.split(':', 2)
        if User.token_valid?(token) && user = User.authenticate_by_token(token: token, username: username)
          user
        else
          reject_unauthorized_connection
        end
      end
  end
end
