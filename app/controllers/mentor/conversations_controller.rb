module Mentor
  class ConversationsController < Mentor::BaseController
    def index
      @conversations = current_user.conversations
    end

    def show
      @conversation = current_user.conversations.find(params[:id])
      @messages = @conversation.messages
    end
  end
end