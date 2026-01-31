class Founder::PeerMessagesController < Founder::BaseController
  def create
    @message = PeerMessage.create(peer_message_params.merge(sender: current_user))
    if @message.persisted?
      recipient = User.find_by(id: peer_message_params[:recipient_id])

      # Broadcast to both sender and recipient so UI updates in real-time (conversations view listens on peer_messages_<user_id>)
      Turbo::StreamsChannel.broadcast_append_to(
        "peer_messages_#{current_user.id}",
        target: "peer-messages-container",
        partial: "peer_messages/peer_message",
        locals: { message: @message, current_user: current_user }
      )

      Turbo::StreamsChannel.broadcast_append_to(
        "peer_messages_#{recipient.id}",
        target: "peer-messages-container",
        partial: "peer_messages/peer_message",
        locals: { message: @message, current_user: current_user }
      ) if recipient

      # Create notification linking into the conversations UI
      begin
        Notification.create!(user: recipient,
                 title: "New message from #{current_user.name}",
                 message: @message.content.to_s.truncate(100),
                 link: founder_conversations_path(selected_type: :peer_message, selected_id: @message.id),
                 notif_type: "message")
      rescue => _e
        # ignore notification failures
      end

      respond_to do |format|
        format.html { redirect_to founder_conversations_path(selected_type: :peer_message, selected_id: @message.id), notice: "Message sent." }
        format.turbo_stream { render "peer_messages/create" }
      end
    else
      redirect_back fallback_location: founder_community_path, alert: "Error."
    end
  end

  def index
    # Unified inbox: combine all message types (for now, just peer messages)
    @messages = (current_user.peer_messages + current_user.received_peer_messages).sort_by(&:created_at).reverse
  end

  private

  def peer_message_params
    params.require(:peer_message).permit(:recipient_id, :content)
  end
end
