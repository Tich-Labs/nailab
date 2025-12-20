class Founder::ConversationsController < Founder::BaseController
  before_action :set_conversation, only: %i[show]

  def index
    @conversations = current_user.conversations
  end

  def show
    @messages = @conversation.messages
  end

  private

  def set_conversation
    @conversation = current_user.conversations.find(params[:id])
  end
end