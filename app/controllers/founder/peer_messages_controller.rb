class Founder::PeerMessagesController < Founder::BaseController

  def create
    @message = PeerMessage.create(peer_message_params.merge(sender: current_user))
    if @message.save
      redirect_back fallback_location: founder_community_path, notice: 'Message sent.'
    else
      redirect_back fallback_location: founder_community_path, alert: 'Error.'
    end
  end

  private

  def peer_message_params
    params.require(:peer_message).permit(:recipient_id, :content)
  end
end