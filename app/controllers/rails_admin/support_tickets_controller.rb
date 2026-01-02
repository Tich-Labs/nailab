module RailsAdmin
  class SupportTicketsController < RailsAdmin::MainController
    def reply
      @ticket = SupportTicket.find(params[:id])

      if request.post?
        if params[:message].present?
          @ticket.add_admin_reply(params[:message], current_user || User.first)
          @ticket.update(status: params[:status]) if params[:status].present?
          redirect_to rails_admin.show_path(model_name: 'SupportTicket', id: @ticket.id), notice: "Reply sent successfully"
        else
          flash[:error] = "Message cannot be blank"
          render :reply
        end
      end
    end
  end
end