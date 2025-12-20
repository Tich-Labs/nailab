class Founder::MessagesController < Founder::BaseController
  before_action :set_conversation

  def create
    @message = @conversation.messages.build(message_params.merge(sender: current_user))
    if @message.save
      redirect_to founder_message_path(@conversation), notice: 'Message sent.'
    else
      redirect_back fallback_location: founder_message_path(@conversation), alert: 'Error.'
    end
  end

  private

  def set_conversation
    @conversation = current_user.conversations.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end