class MentorOnboardingController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_mentor_role
  before_action :load_profile

  STEPS = %w[basic_details work_experience mentorship_focus mentorship_style availability review]

  def show
    @step = params[:step] || @profile.onboarding_step || STEPS.first
    unless STEPS.include?(@step)
      redirect_to mentor_onboarding_path(step: STEPS.first)
      return
    end

    # Save current step for resume later
    @profile.update(onboarding_step: @step) unless @profile.onboarding_step == @step

    @progress = (STEPS.index(@step) + 1).to_f / STEPS.length * 100
  end

  def update
    @step = params[:step]
    unless STEPS.include?(@step)
      redirect_to mentor_onboarding_path(step: STEPS.first)
      return
    end

    if @profile.update(mentor_params_for_step(@step))
      next_step = next_step(@step)
      if next_step
        redirect_to mentor_onboarding_path(step: next_step)
      else
        complete_onboarding
      end
    else
      @progress = (STEPS.index(@step) + 1).to_f / STEPS.length * 100
      render :show
    end
  end

  def save_and_exit
    @step = params[:step]
    if @profile.update(mentor_params_for_step(@step))
      @profile.update(onboarding_step: @step)
      redirect_to mentor_root_path, notice: 'Your progress has been saved. You can continue onboarding later.'
    else
      @progress = (STEPS.index(@step) + 1).to_f / STEPS.length * 100
      render :show
    end
  end

  private

  def ensure_mentor_role
    unless current_user.user_profile&.role == 'mentor'
      redirect_to root_path, alert: 'Access denied'
    end
  end

  def load_profile
    @profile = current_user.user_profile || current_user.build_user_profile
  end

  def mentor_params_for_step(step)
    case step
    when 'basic_details'
      params.require(:user_profile).permit(:full_name, :bio, :title)
    when 'work_experience'
      params.require(:user_profile).permit(:organization, :years_experience, :advisory_experience, :advisory_description)
    when 'mentorship_focus'
      params.require(:user_profile).permit(sectors: [], expertise: [], stage_preference: [])
    when 'mentorship_style'
      params.require(:user_profile).permit(:mentorship_approach, :motivation)
    when 'availability'
      params.require(:user_profile).permit(:availability_hours_month, :preferred_mentorship_mode, :rate_per_hour, :pro_bono, :linkedin_url, :professional_website, :currency)
    else
      {}
    end
  end

  def next_step(current_step)
    current_index = STEPS.index(current_step)
    STEPS[current_index + 1] if current_index && current_index < STEPS.length - 1
  end

  def complete_onboarding
    @profile.update(onboarding_completed: true, profile_visibility: true)
    redirect_to mentor_root_path, notice: 'Welcome to Nailab! Your mentor profile has been created successfully.'
  end
end