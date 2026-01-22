class Founder::DashboardController < Founder::BaseController
  def show
    @user = current_user
    @startup = @user.startup

    if @startup.nil?
      # Handle case where founder has no startup yet
      # This might be after signup but before startup profile creation
      redirect_to founder_onboarding_path and return
    end
    
    # Redirect to initial metrics onboarding if no metrics have ever been submitted
    if @startup.monthly_metrics.none?
      redirect_to new_founder_initial_metrics_path
      return
    end

    @latest_metric = @startup.monthly_metrics.order(period: :desc).first
    @monthly_metrics = @startup.monthly_metrics.order(period: :asc)
    @milestones = @startup.milestones
    @recommended_mentors = Mentor.limit(3) # stub, need matching logic
  end
end
