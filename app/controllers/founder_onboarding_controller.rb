require "ostruct"

class FounderOnboardingController < ApplicationController
  include CountryHelper
  before_action :ensure_signed_in

  STEPS = %w[personal startup professional mentorship confirm]

  def show
    prepare_profiles
  end

  def update
    @step = params[:step] || STEPS.first

    step_params = case @step
    when "personal" then personal_params
    when "startup" then startup_params
    when "professional" then professional_params
    when "mentorship" then mentorship_params
    else {}
    end

    # If the user is signed in but previously completed steps as a guest, merge any
    # session-stored onboarding data into the user's profiles before persisting the
    # final confirmation step. This ensures required fields (full_name, phone, bio, etc.)
    # are present and validations won't block the `confirm` update.
    if current_user
      begin
        Onboarding::SessionMerger.merge(current_user, session)
      rescue => e
        Rails.logger.error("FounderOnboarding: session merge failed: #{e.message}")
      end
    end

    service_result = Onboarding::Core.call(actor: current_user, role: :founders, step: @step, params: step_params, session: session)

    Rails.logger.info("[FounderOnboarding] service_result: #{service_result.inspect}")

    if service_result.success?
      if service_result.completed?
        payload = service_result.respond_to?(:changed_models) ? service_result.changed_models : {}
        Notifications::OnboardingNotifier.notify_user_on_completion(user: current_user, role: :founders, payload: payload)
        Notifications::OnboardingNotifier.notify_admin_of_submission(user: current_user, role: :founders, payload: payload)
        Jobs::SendWelcomeEmailJob.perform_later(current_user.id, "founder", payload) if defined?(Jobs::SendWelcomeEmailJob)
        if defined?(Analytics::Tracker)
          Analytics::Tracker.track(event: "onboarding_completed", user_id: current_user.id, role: "founder", payload: payload)
        end
        redirect_to founder_root_path, notice: "Welcome! Your founder profile has been created."
      else
        redirect_to founder_onboarding_path(step: service_result.next_step)
      end
      else
        redirect_to founder_onboarding_path(step: service_result.next_step)
      end
    else
      # render with errors
      @errors = service_result.errors
      Rails.logger.warn("[FounderOnboarding] onboarding failed: ")
      Rails.logger.warn(@errors.inspect)
      @step = @step
      prepare_profiles unless defined?(@user_profile) && @user_profile
      render :show, status: :unprocessable_entity
    end
  end

  def save_and_exit
    @step = params[:step] || STEPS.first
    step_params = case @step
    when "personal" then personal_params
    when "startup" then startup_params
    when "professional" then professional_params
    when "mentorship" then mentorship_params
    else {}
    end
    service_result = Onboarding::Core.call(actor: current_user, role: :founders, step: @step, params: step_params, session: session)

    if service_result.success?
      redirect_to founder_root_path, notice: "Your progress has been saved. You can continue onboarding later."
    else
      @errors = service_result.errors
      prepare_profiles unless defined?(@user_profile) && @user_profile
      render :show, status: :unprocessable_entity
    end
  end

  def completed
    render "mentor_onboarding/completed"
  end

  private

  def personal_params
    params.require(:founder_onboarding).require(:user_profile).permit(:full_name, :phone, :country, :city, :bio)
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

  def prepare_profiles
    @step = params[:step] || session[:founder_onboarding_step] || STEPS.first
    @user_profile = current_user.user_profile || current_user.build_user_profile
    @startup_profile = current_user.startup_profile || current_user.build_startup_profile
    @user_profile.update(onboarding_step: @step) unless @user_profile.onboarding_step == @step
  end

  def cast_boolean_param(attributes, key)
    return attributes unless attributes.key?(key)
    attributes[key] = ActiveModel::Type::Boolean.new.cast(attributes[key])
    attributes
  end
end
