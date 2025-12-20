
class FounderOnboardingController < ApplicationController
  include CountryHelper
  STEPS = %w[personal startup professional mentorship confirm]

  # GET /founder_onboarding/new
  def new
    session[:founder_onboarding] = {}
    redirect_to founder_onboarding_path(step: 'personal')
  end

  def show
    @step = params[:step] || session.dig(:founder_onboarding, :onboarding_step) || STEPS.first
    @onboarding_data = session[:founder_onboarding] || {}
    case @step
    when 'personal'
      @user_profile = OpenStruct.new(@onboarding_data[:user_profile] || {})
    when 'startup', 'professional', 'mentorship', 'confirm'
      @user_profile = OpenStruct.new(@onboarding_data[:user_profile] || {})
      @startup_profile = OpenStruct.new(@onboarding_data[:startup_profile] || {})
      if @step == 'mentorship' && @startup_profile.mentorship_areas.present?
        predefined_options = ['Product Development', 'Go-to-market Strategy', 'Fundraising', 'Team Building', 'Marketing & Branding', 'Sales & Customer Acquisition', 'Financial Planning', 'Legal & Regulatory', 'Partnerships', 'Leadership', 'Other']
        custom_areas = Array(@startup_profile.mentorship_areas) - predefined_options
        if custom_areas.any?
          @startup_profile.mentorship_areas = (Array(@startup_profile.mentorship_areas) - custom_areas) + ['Other']
          @other_mentorship_area = custom_areas.first
        end
      end
    end
    # Save current step for resume later
    session[:founder_onboarding] ||= {}
    session[:founder_onboarding][:onboarding_step] = @step
  end

  def update
    @step = params[:step] || STEPS.first
    session[:founder_onboarding] ||= {}
    onboarding_data = session[:founder_onboarding]

    case @step
    when 'personal'
      onboarding_data[:user_profile] = personal_params.to_h
      next_step = 'startup'
    when 'startup'
      onboarding_data[:startup_profile] ||= {}
      onboarding_data[:startup_profile].merge!(startup_params.to_h)
      next_step = 'professional'
    when 'professional'
      onboarding_data[:startup_profile] ||= {}
      onboarding_data[:startup_profile].merge!(professional_params.to_h)
      next_step = 'mentorship'
    when 'mentorship'
      mentorship_data = mentorship_params.to_h
      if mentorship_data[:mentorship_areas].is_a?(Array) && mentorship_data[:mentorship_areas].include?('Other') && mentorship_data[:other_mentorship_area].present?
        mentorship_data[:mentorship_areas] = mentorship_data[:mentorship_areas].map do |area|
          area == 'Other' ? mentorship_data[:other_mentorship_area] : area
        end
      end
      mentorship_data.delete(:other_mentorship_area)
      onboarding_data[:startup_profile] ||= {}
      onboarding_data[:startup_profile].merge!(mentorship_data)
      next_step = 'confirm'
    when 'confirm'
      # At this point, prompt for account creation or login
      redirect_to new_user_registration_path and return
    end

    onboarding_data[:onboarding_step] = next_step if defined?(next_step)
    session[:founder_onboarding] = onboarding_data
    redirect_to founder_onboarding_path(step: next_step)
  end

  private

  def personal_params
    params.require(:founder_onboarding).require(:user_profile).permit(:full_name, :phone, :country, :city)
  end

  def startup_params
    params.require(:founder_onboarding).require(:startup_profile).permit(:startup_name, :description, :stage, :target_market, :value_proposition, :funding_stage, :funding_raised)
  end

  def professional_params
    permitted = params.require(:founder_onboarding).require(:startup_profile).permit(:sector, :other_sector, :funding_stage, :funding_raised)
    # If sector is not 'Other', clear other_sector
    if permitted[:sector] != 'Other'
      permitted[:other_sector] = nil
    end
    permitted
  end

  def mentorship_params
    params.require(:founder_onboarding).require(:startup_profile).permit(:mentorship_areas, :challenge_details, :preferred_mentorship_mode, :other_mentorship_area)
  end

  def cast_boolean_param(attributes, key)
    return attributes unless attributes.key?(key)
    attributes[key] = ActiveModel::Type::Boolean.new.cast(attributes[key])
    attributes
  end
end
