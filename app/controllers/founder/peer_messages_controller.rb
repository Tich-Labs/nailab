class Founder::PeerMessagesController < Founder::BaseController
  def create
    @message = PeerMessage.create(peer_message_params.merge(sender: current_user))
    if @message.save
      # Notify recipient
      begin
        recipient = User.find(peer_message_params[:recipient_id])
        Notification.create!(user: recipient,
                 title: "New message",
                 message: "#{current_user.name} sent you a message (subscription: #{current_user.subscription&.tier || 'free'})",
                 link: pricing_path,
                 notif_type: "message",
                 metadata: { sender_subscription: current_user.subscription&.tier })
      rescue => _e
        # ignore notification failures
      end
      redirect_to founder_peer_messages_path, notice: "Message sent."
    else
      redirect_back fallback_location: founder_community_path, alert: "Error."
    end
  end

  def index
    @sent = current_user.peer_messages.order(created_at: :desc)
    @received = current_user.received_peer_messages.order(created_at: :desc)
  end

  private

  def peer_message_params
    params.require(:peer_message).permit(:recipient_id, :content)
  end
end
