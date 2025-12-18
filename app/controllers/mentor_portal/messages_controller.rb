module MentorPortal
  class MessagesController < MentorPortal::BaseController
    def create
      @conversation = current_user.conversations.find(params[:conversation_id])
      @message = @conversation.messages.build(message_params)
      @message.sender = current_user

      if @message.save
        redirect_to mentor_conversation_path(@conversation), notice: "Message sent."
      else
        redirect_to mentor_conversation_path(@conversation), alert: "Failed to send message."
      end
    end

    private

    def message_params
      params.require(:message).permit(:content)
    end
  end
end