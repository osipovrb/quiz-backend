module ApplicationCable
  class Connection < ActionCable::Connection::Base
  	identified_by :current_user

    def connect
      # self.current_user = find_user
      self.current_user = User.first
    end

    private
      def find_user
      	token, username = request.authorization.to_s.split(':', 2)
        if User.token_valid?(token) && user = User.authenticate_by_token(username, token)
          user
        else
          reject_unauthorized_connection
        end
      end
  end
end
