class FounderOnboardingController < ApplicationController
  include CountryHelper
  before_action :authenticate_user!

  STEPS = %w[personal startup professional mentorship confirm]

  def show
    @step = params[:step] || STEPS.first
    case @step
    when 'personal'
      @user_profile = current_user.user_profile || current_user.build_user_profile
    when 'startup'
      @startup_profile = current_user.startup_profile || current_user.build_startup_profile
    when 'professional'
      @startup_profile = current_user.startup_profile || current_user.build_startup_profile
    when 'mentorship'
      @startup_profile = current_user.startup_profile || current_user.build_startup_profile
    when 'confirm'
      @user_profile = current_user.user_profile
      @startup_profile = current_user.startup_profile
    end
  end

  def update
    @step = params[:step] || STEPS.first
    case @step
    when 'personal'
      @user_profile = current_user.user_profile || current_user.build_user_profile
      if @user_profile.update(personal_params)
        redirect_to founder_onboarding_path(step: 'startup')
      else
        render :show, status: :unprocessable_entity
      end
    when 'startup'
      @startup_profile = current_user.startup_profile || current_user.build_startup_profile
      if @startup_profile.update(startup_params)
        redirect_to founder_onboarding_path(step: 'professional')
      else
        render :show, status: :unprocessable_entity
      end
    when 'professional'
      @startup_profile = current_user.startup_profile || current_user.build_startup_profile
      if @startup_profile.update(professional_params)
        redirect_to founder_onboarding_path(step: 'mentorship')
      else
        render :show, status: :unprocessable_entity
      end
    when 'mentorship'
      @startup_profile = current_user.startup_profile || current_user.build_startup_profile
      if @startup_profile.update(mentorship_params)
        redirect_to founder_onboarding_path(step: 'confirm')
      else
        render :show, status: :unprocessable_entity
      end
    when 'confirm'
      @user_profile = current_user.user_profile
      @user_profile.update(onboarding_completed: true)
      redirect_to founder_root_path
    end
  end

  private

  def personal_params
    params.require(:founder_onboarding).require(:user_profile).permit(:full_name, :phone, :country, :city)
  end

  def startup_params
    params.require(:founder_onboarding).require(:startup_profile).permit(:startup_name, :logo_url, :description, :stage, :target_market, :value_proposition)
  end

  def professional_params
    params.require(:founder_onboarding).require(:startup_profile).permit(:sector, :stage, :funding_stage, :funding_raised)
  end

  def mentorship_params
    params.require(:founder_onboarding).require(:startup_profile).permit(:mentorship_areas, :challenge_details, :preferred_mentorship_mode)
  end
end
