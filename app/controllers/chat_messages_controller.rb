class ChatMessagesController < ApplicationController
	before_action :require_user

  def create
  	chat_message = ChatMessage.new(user: @user, content: params[:content])
  	if chat_message.save
  		head 204
  	else
  		render json: chat_message.errors.full_messages, status: 422
  	end
  end
end
