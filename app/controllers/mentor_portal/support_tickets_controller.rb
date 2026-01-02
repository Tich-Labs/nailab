module MentorPortal
  class SupportTicketsController < MentorPortal::BaseController
    def create
      ticket = SupportTicket.create!(
        support_ticket_params.except(:description).merge(
          user: current_user,
          portal: "mentor",
          status: "open" # New tickets start as open
        )
      )

      redirect_to mentor_support_path, notice: "Support ticket submitted successfully."
    rescue ActiveRecord::RecordInvalid
      redirect_to mentor_support_path, alert: "Please complete all required fields and try again."
    end

    def show
      @ticket = current_user.support_tickets.includes(:replies).find(params[:id])
    end

    def reply
      @ticket = current_user.support_tickets.find(params[:id])

      if params[:message].present?
        @ticket.replies.create!(user: current_user, body: params[:message])
        redirect_to mentor_support_ticket_path(@ticket), notice: "Reply sent successfully."
      else
        redirect_to mentor_support_ticket_path(@ticket), alert: "Message cannot be blank."
      end
    end

    private

    def support_ticket_params
      params.require(:support_ticket).permit(:subject, :category, :description)
    end
  end
end
