class Founder::ConnectionsController < Founder::BaseController
  def create
    @connection = current_user.connections.build(connection_params)
    if @connection.save
      # Notify the peer that someone wants to connect
      peer_id = connection_params[:peer_id]
      begin
        peer = User.find(peer_id)
        Notification.create!(user: peer,
                 title: "New connection request",
                 message: "#{current_user.name} wants to connect with you (subscription: #{current_user.subscription&.tier || 'free'})",
                 link: pricing_path,
                 notif_type: "connection",
                 metadata: { sender_subscription: current_user.subscription&.tier })
      rescue => _e
        # don't block on notification failure
      end
      # Redirect to community with recipient pre-selected so user can message
      redirect_to founder_community_path(recipient_id: peer_id), notice: "Connected. You can message them below."
    else
      redirect_back fallback_location: founder_community_path, alert: "Error."
    end
  end

  private

  def connection_params
    params.require(:connection).permit(:peer_id)
  end
end
