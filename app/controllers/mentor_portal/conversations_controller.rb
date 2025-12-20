module MentorPortal
  class ConversationsController < MentorPortal::BaseController
    def index
      @conversations = current_user.conversations
    end

    def show
      @conversation = current_user.conversations.find(params[:id])
      @messages = @conversation.messages
    end
  end
end