class Founder::DashboardController < Founder::BaseController

  def show
    @user = current_user
    @startup_profile = @user.startup_profile
    @milestones = @user.milestones
    @recommended_mentors = Mentor.limit(3) # stub, need matching logic
  end
end