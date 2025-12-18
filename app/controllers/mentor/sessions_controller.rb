module Mentor
  class SessionsController < Mentor::BaseController
    def index
      @sessions = current_user.sessions.order(date: :desc)
    end

    def show
      @session = current_user.sessions.find(params[:id])
    end

    def join
      @session = current_user.sessions.find(params[:id])
      # Placeholder for join functionality
      redirect_to mentor_session_path(@session), notice: "Join functionality coming soon."
    end

    def add_to_calendar
      @session = current_user.sessions.find(params[:id])
      # Placeholder for calendar integration
      redirect_to mentor_session_path(@session), notice: "Calendar integration coming soon."
    end
  end
end