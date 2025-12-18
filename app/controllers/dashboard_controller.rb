class DashboardController < ApplicationController
  before_action :authenticate_user!

  def show
    @user_profile = current_user.user_profile
    @startup_profile = current_user.startup_profile if @user_profile&.role == 'founder'
    @mentorship_requests = if @user_profile&.role == 'mentor'
      MentorshipRequest.where(mentor_id: current_user.id).order(created_at: :desc)
    elsif @user_profile&.role == 'founder'
      MentorshipRequest.where(founder_id: current_user.id).order(created_at: :desc)
    else
      []
    end
    @notifications = Notification.where(user_id: current_user.id).order(created_at: :desc).limit(10)
  end

  def profile
    @user_profile = current_user.user_profile
    @startup_profile = current_user.startup_profile
  end
end