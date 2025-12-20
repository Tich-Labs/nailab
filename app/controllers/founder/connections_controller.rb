class Founder::ConnectionsController < Founder::BaseController
  def create
    @connection = current_user.connections.build(connection_params)
    if @connection.save
      redirect_back fallback_location: founder_community_path, notice: "Connected."
    else
      redirect_back fallback_location: founder_community_path, alert: "Error."
    end
  end

  private

  def connection_params
    params.require(:connection).permit(:peer_id)
  end
end
