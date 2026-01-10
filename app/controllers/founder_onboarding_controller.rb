class FounderOnboardingController < ApplicationController
  include CountryHelper

  STEPS = %w[personal startup professional mentorship confirm]

  def show
    # Prepare view state from session store (guest) or persisted models (actor)
    @step = params[:step] || session[:founder_onboarding_step] || STEPS.first
    if current_user
      @user_profile = current_user.user_profile || current_user.build_user_profile
      @startup_profile = current_user.startup_profile || current_user.build_startup_profile
      @user_profile.update(onboarding_step: @step) unless @user_profile.onboarding_step == @step
    else
      session_store = Onboarding::SessionStore.new(session, namespace: :founders)
      up = session_store.to_h.select { |k, _| %w[full_name phone country city email].include?(k) }
      sp = session_store.to_h.reject { |k, _| %w[full_name phone country city email].include?(k) }
      @user_profile = OpenStruct.new(up || {})
      @startup_profile = OpenStruct.new(sp || {})
      session[:founder_onboarding_step] = @step
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

    service_result = Onboarding::Core.call(actor: current_user, role: :founders, step: @step, params: step_params, session: session)

    if service_result.success?
      if service_result.completed?
        if current_user
          payload = service_result.respond_to?(:changed_models) ? service_result.changed_models : {}
          Notifications::OnboardingNotifier.notify_user_on_completion(user: current_user, role: :founders, payload: payload)
          Notifications::OnboardingNotifier.notify_admin_of_submission(user: current_user, role: :founders, payload: payload)
          Jobs::SendWelcomeEmailJob.perform_later(current_user.id, "founder", payload) if defined?(Jobs::SendWelcomeEmailJob)
          if defined?(Analytics::Tracker)
            Analytics::Tracker.track(event: "onboarding_completed", user_id: current_user.id, role: "founder", payload: payload)
          end
          redirect_to founder_root_path, notice: "Welcome! Your founder profile has been created."
        else
          redirect_to founder_onboarding_completed_path
        end
      else
        redirect_to founder_onboarding_path(step: service_result.next_step)
      end
    else
      # render with errors
      @errors = service_result.errors
      @step = @step
      render :show, status: :unprocessable_entity
    end
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
      render :show, status: :unprocessable_entity
    end
  end

  def completed
    render "mentor_onboarding/completed"
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
