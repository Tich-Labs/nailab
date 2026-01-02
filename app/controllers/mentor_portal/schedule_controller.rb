module MentorPortal
  class ScheduleController < MentorPortal::BaseController
    def show
      @sessions = current_user.sessions.where("date >= ?", Date.today).order(:date, :time)
    end
  end
end
