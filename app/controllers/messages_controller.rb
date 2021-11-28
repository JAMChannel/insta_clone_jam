class MessagesController < ApplicationController
  before_action :require_login, only: %i[create]

  private

  def message_params
    params.require(:message).permit(:body).merge(chatroom_id: params[:chatroom_id])
  end
end
