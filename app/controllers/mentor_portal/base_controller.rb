module MentorPortal
  class BaseController < ApplicationController
    before_action :authenticate_user!
    layout "mentor_dashboard"

    private

    def current_mentor
      @current_mentor ||= Mentor.find_by(user_id: current_user.id)
      unless @current_mentor
        redirect_to root_path, alert: "You need to complete your mentor profile first."
      end
      @current_mentor
    end
    helper_method :current_mentor
  end
end
