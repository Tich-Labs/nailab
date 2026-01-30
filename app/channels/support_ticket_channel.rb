class SupportTicketChannel < ApplicationCable::Channel
  def subscribed
    ticket_id = params[:ticket_id]
    @ticket = SupportTicket.find_by(id: ticket_id, user_id: current_user.id)

    if @ticket
      stream_for "support_ticket_#{@ticket.id}"
    else
      reject
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
