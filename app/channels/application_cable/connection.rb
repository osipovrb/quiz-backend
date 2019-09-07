module ApplicationCable
  class Connection < ActionCable::Connection::Base
  	identified_by :current_user

    def connect
      self.current_user = find_user
    end

    private
      def find_user
      	token, username = request.authorization.to_s.split(':', 2)
        if user = User.find_by(token: token, username: username)
          user
        else
          reject_unauthorized_connection
        end
      end
  end
end
