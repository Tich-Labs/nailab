class DashboardController < ApplicationController
  before_action :authenticate_user!

  def show
    @mentorship_requests = current_user.mentorship_requests.order(created_at: :desc)
    @approved_requests = @mentorship_requests.approved
    @pending_requests = @mentorship_requests.pending
  end
end
