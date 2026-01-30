class ConversationChannel < ApplicationCable::Channel
  def subscribed
    @conversation = PeerMessage.where(
      "sender_id = ? OR recipient_id = ?",
      current_user.id,
      current_user.id
    )
    stream_for "peer_messages_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
