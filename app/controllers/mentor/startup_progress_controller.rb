module Mentor
  class StartupProgressController < Mentor::BaseController
    def show
      mentor_ids = MentorshipConnection.where(mentor_id: current_mentor.id).pluck(:founder_id)
      @startup = StartupProfile.where(user_id: mentor_ids).find(params[:startup_id])
      # Placeholder for progress tracking
    end
  end
end