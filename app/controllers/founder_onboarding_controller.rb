class FounderOnboardingController < ApplicationController
  include CountryHelper

  STEPS = %w[personal startup professional mentorship confirm]

  def show
    @step = params[:step] || session[:founder_onboarding_step] || STEPS.first
    if current_user
      @user_profile = current_user.user_profile || current_user.build_user_profile
      case @step
      when "personal"
        # @user_profile already set above
      when "startup", "professional", "mentorship", "confirm"
        @startup_profile = current_user.startup_profile || current_user.build_startup_profile
      end
      @user_profile.update(onboarding_step: @step) unless @user_profile.onboarding_step == @step
    else
      @user_profile = OpenStruct.new(session[:founder_onboarding_user_profile] || {})
      @startup_profile = OpenStruct.new(session[:founder_onboarding_startup_profile] || {})
      session[:founder_onboarding_step] = @step
    end
  def update
    @step = params[:step] || STEPS.first
    if current_user
      @user_profile = current_user.user_profile || current_user.build_user_profile
      case @step
      when "personal"
        if @user_profile.update(personal_params)
          redirect_to founder_onboarding_path(step: "startup")
        else
          render :show, status: :unprocessable_entity
        end
      when "startup"
        @startup_profile = current_user.startup_profile || current_user.build_startup_profile
        if @startup_profile.update(startup_params)
          redirect_to founder_onboarding_path(step: "professional")
        else
          render :show, status: :unprocessable_entity
        end
      when "professional"
        @startup_profile = current_user.startup_profile || current_user.build_startup_profile
        if @startup_profile.update(professional_params)
          redirect_to founder_onboarding_path(step: "mentorship")
        else
          render :show, status: :unprocessable_entity
        end
      when "mentorship"
        @startup_profile = current_user.startup_profile || current_user.build_startup_profile
        if @startup_profile.update(mentorship_params)
          redirect_to founder_onboarding_path(step: "confirm")
        else
          render :show, status: :unprocessable_entity
        end
      when "confirm"
        @user_profile.update(onboarding_completed: true)
        redirect_to founder_root_path
      end
    else
      # Unauthenticated: store data in session
      case @step
      when "personal"
        session[:founder_onboarding_user_profile] = personal_params.to_h
        redirect_to founder_onboarding_path(step: "startup")
      when "startup"
        session[:founder_onboarding_startup_profile] ||= {}
        session[:founder_onboarding_startup_profile].merge!(startup_params.to_h)
        redirect_to founder_onboarding_path(step: "professional")
      when "professional"
        session[:founder_onboarding_startup_profile] ||= {}
        session[:founder_onboarding_startup_profile].merge!(professional_params.to_h)
        redirect_to founder_onboarding_path(step: "mentorship")
      when "mentorship"
        session[:founder_onboarding_startup_profile] ||= {}
        session[:founder_onboarding_startup_profile].merge!(mentorship_params.to_h)
        redirect_to founder_onboarding_path(step: "confirm")
      when "confirm"
        # At this point, onboarding is complete but user is not registered
        redirect_to new_founder_registration_path, notice: "Please create an account to complete your onboarding."
      end
      session[:founder_onboarding_step] = @step
    end
  end
  end

  def save_and_exit
    @user_profile = current_user.user_profile || current_user.build_user_profile
    @step = params[:step] || STEPS.first

    # Save current step data before exiting
    success = case @step
    when "personal"
      @user_profile.update(personal_params)
    when "startup"
      @startup_profile = current_user.startup_profile || current_user.build_startup_profile
      @startup_profile.update(startup_params)
    when "professional"
      @startup_profile = current_user.startup_profile || current_user.build_startup_profile
      @startup_profile.update(professional_params)
    when "mentorship"
      @startup_profile = current_user.startup_profile || current_user.build_startup_profile
      @startup_profile.update(mentorship_params)
    else
      true
    end

    if success
      @user_profile.update(onboarding_step: @step)
      redirect_to founder_root_path, notice: "Your progress has been saved. You can continue onboarding later."
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def personal_params
    params.require(:founder_onboarding).require(:user_profile).permit(:full_name, :phone, :country, :city)
  end

  def startup_params
    cast_boolean_param(
      params.require(:founder_onboarding).require(:startup_profile).permit(:startup_name, :logo_url, :description, :stage, :target_market, :value_proposition, :profile_visibility),
      :profile_visibility
    )
  end

  def professional_params
    params.require(:founder_onboarding).require(:startup_profile).permit(:sector, :stage, :funding_stage, :funding_raised)
  end

  def mentorship_params
    params.require(:founder_onboarding).require(:startup_profile).permit(:mentorship_areas, :challenge_details, :preferred_mentorship_mode)
  end

  def cast_boolean_param(attributes, key)
    return attributes unless attributes.key?(key)
    attributes[key] = ActiveModel::Type::Boolean.new.cast(attributes[key])
    attributes
  end
end
