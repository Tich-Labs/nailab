module MentorPortal
  class SupportController < MentorPortal::BaseController
    def show
      @support_tickets = current_user.support_tickets.includes(:replies).order(created_at: :desc)
    end
  end
end