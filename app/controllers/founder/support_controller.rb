class Founder::SupportController < Founder::BaseController
  def show
    @support_ticket = current_user.support_tickets.build
    load_tickets
  end

  def create
    @support_ticket = current_user.support_tickets.build(support_ticket_params)
    if @support_ticket.save
      SupportTicketMailer.with(support_ticket: @support_ticket).new_support_ticket.deliver_later
      redirect_to founder_support_path, notice: 'Your support ticket has been submitted. Our team will follow up shortly.'
    else
      load_tickets
      render :show, status: :unprocessable_entity
    end
  end

  private

  def load_tickets
    @support_tickets = current_user.support_tickets.order(created_at: :desc).limit(6)
  end

  def support_ticket_params
    params.require(:support_ticket).permit(:subject, :category, :description)
  end
end