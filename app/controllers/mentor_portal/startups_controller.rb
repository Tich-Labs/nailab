module MentorPortal
  class StartupsController < MentorPortal::BaseController
    def index
      # Get startups that have mentorship connections with current mentor
      mentor_ids = MentorshipConnection.where(mentor_id: current_mentor.id).pluck(:founder_id)
      @startups = StartupProfile.where(user_id: mentor_ids)
    end

    def show
      mentor_ids = MentorshipConnection.where(mentor_id: current_mentor.id).pluck(:founder_id)
      @startup = StartupProfile.where(user_id: mentor_ids).find(params[:id])
    end
  end
end