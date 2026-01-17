
class MentorOnboardingController < ApplicationController
  before_action :ensure_signed_in
  before_action :ensure_mentor_role
  before_action :load_profile

  STEPS = %w[basic_details work_experience mentorship_focus mentorship_style availability review]

  def show
    prepare_show_state(params[:step])
  end

  def update
    @step = params[:step]
    unless STEPS.include?(@step)
      redirect_to mentor_onboarding_path(step: STEPS.first)
      return
    end
    service_result = Onboarding::Core.call(actor: current_user, role: :mentors, step: @step, params: mentor_params_for_step(@step), session: session)

    if service_result.success?
      if service_result.completed?
        payload = service_result.respond_to?(:changed_models) ? service_result.changed_models : {}
        Notifications::OnboardingNotifier.notify_user_on_completion(user: current_user, role: :mentors, payload: payload)
        Notifications::OnboardingNotifier.notify_admin_of_submission(user: current_user, role: :mentors, payload: payload)
        if defined?(Analytics::Tracker)
          Analytics::Tracker.track(event: "onboarding_completed", user_id: current_user.id, role: "mentor", payload: payload)
        else
          Rails.logger.info("[MentorOnboarding] onboarding_completed user=#{current_user.id} role=mentor")
        end

        redirect_to mentor_root_path, notice: "Welcome to Nailab! Your mentor profile has been created successfully."
      else
        redirect_to mentor_onboarding_path(step: service_result.next_step)
      end
    else
      prepare_show_state(@step)
      @errors = service_result.errors
      render :show, status: :unprocessable_entity
    end
  end

  def save_and_exit
    @step = params[:step]
    # Delegate persistence to orchestrator; keep controller thin
    service_result = Onboarding::Core.call(actor: current_user, role: :mentors, step: @step, params: mentor_params_for_step(@step), session: session)

    if service_result.success?
      # If this call completed the onboarding, run the same completion side-effects
      if service_result.respond_to?(:completed?) && service_result.completed?
        if current_user
          payload = service_result.respond_to?(:changed_models) ? service_result.changed_models : {}
          Notifications::OnboardingNotifier.notify_user_on_completion(user: current_user, role: :mentors, payload: payload)
          Notifications::OnboardingNotifier.notify_admin_of_submission(user: current_user, role: :mentors, payload: payload)
          if defined?(Analytics::Tracker)
            Analytics::Tracker.track(event: "onboarding_completed", user_id: current_user.id, role: "mentor", payload: payload)
          else
            Rails.logger.info("[MentorOnboarding] onboarding_completed user=#{current_user.id} role=mentor")
          end
        end
      end

      redirect_to mentor_root_path, notice: "Your progress has been saved. You can continue onboarding later."
    else
      prepare_show_state(@step)
      @errors = service_result.errors
      render :show, status: :unprocessable_entity
    end
  end

  # Prepare instance state expected by the `show` view so update/save_and_exit
  # can render the same template when validations fail. Keeps rendering logic
  # in one place and keeps controller actions thin.
  def prepare_show_state(requested_step)
    @step = requested_step || session[:mentor_onboarding_step] || STEPS.first
    unless STEPS.include?(@step)
      redirect_to mentor_onboarding_path(step: STEPS.first)
      return
    end

    @profile = current_user.user_profile || current_user.build_user_profile
    @profile.update(onboarding_step: @step) unless @profile.onboarding_step == @step

    @progress = (STEPS.index(@step) + 1).to_f / STEPS.length * 100
  end

  private

  def ensure_mentor_role
    unless current_user.mentor?
      redirect_to root_path, alert: "Access denied"
    end
  end

  def load_profile
    @profile = current_user.user_profile || current_user.build_user_profile
  end

  def mentor_params_for_step(step)
    case step
    when "basic_details"
      params.require(:user_profile).permit(:full_name, :bio, :title)
    when "work_experience"
      params.require(:user_profile).permit(:organization, :years_experience, :advisory_experience, :advisory_description)
    when "mentorship_focus"
      params.require(:user_profile).permit(sectors: [], expertise: [], stage_preference: [])
    when "mentorship_style"
      params.require(:user_profile).permit(:mentorship_approach, :motivation)
    when "availability"
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
    redirect_to mentor_root_path, notice: "Welcome to Nailab! Your mentor profile has been created successfully."
  end

  def ensure_signed_in
    return if current_user
    flash[:alert] = "Please sign in or create an account to continue onboarding."
    redirect_to new_user_session_path
  end
end
