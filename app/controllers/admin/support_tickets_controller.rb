module Admin
  class SupportTicketsController < ApplicationController
    include AdminAuthorization
    include AdminLayoutData
    layout "rails_admin/application"
    before_action :set_admin_layout_data, only: [ :index ]
    before_action :set_page_name, only: [ :index ]
    skip_before_action :verify_authenticity_token, only: [ :reply ]

    def index
      authorize :admin, :manage_support_tickets?
    end

    def reply
      @ticket = SupportTicket.find(params[:id])

      if request.post?
        if params[:message].present?
          @ticket.add_admin_reply(params[:message], nil)
          @ticket.update(status: params[:status]) if params[:status].present?
          redirect_to "/admin/support_tickets/#{@ticket.id}", notice: "Reply sent successfully"
        else
          flash[:error] = "Message cannot be blank"
          redirect_to "/admin/support_tickets/#{@ticket.id}/full_reply"
        end
      else
        # Quick reply with default message
        @ticket.add_admin_reply("Thank you for your inquiry. We'll get back to you soon.", nil)
        redirect_to "/admin/support_tickets/#{@ticket.id}", notice: "Quick reply sent successfully"
      end
    end

      private

      def set_page_name
        @page_name = "Support Tickets"
      end
  end
end
