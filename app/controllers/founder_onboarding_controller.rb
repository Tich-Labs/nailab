class FounderOnboardingController < ApplicationController
  skip_before_action :authenticate_user!, raise: false

  STEPS = %w[personal startup professional mentorship confirm].freeze

  def new
    reset_session
    redirect_to founder_onboarding_path
  end

  def show
    @step = valid_step(params[:step])
    data = session.fetch(:founder_onboarding, {})
    @user_profile = UserProfile.new(data.fetch("user_profile", {}))
    @startup_profile = StartupProfile.new(data.fetch("startup_profile", {}))
    @other_mentorship_area = data.dig("startup_profile", "other_mentorship_area")
  end

  def update
    @step = valid_step(params[:step])

    session[:founder_onboarding_email] = params[:email] if params[:email].present?

    merged = deep_merge(session.fetch(:founder_onboarding, {}), founder_params.to_h)
    session[:founder_onboarding] = merged

    if params[:save_and_exit].present?
      redirect_to root_path
      return
    end

    if @step == STEPS.last
      if params[:consent].to_s != "1"
        flash[:alert] = "Please confirm you agree before submitting."
        redirect_to founder_onboarding_path(step: @step)
        return
      end

      email = session[:founder_onboarding_email].to_s.strip.downcase
      if email.blank?
        flash[:alert] = "Please provide your email address."
        redirect_to founder_onboarding_path(step: @step)
        return
      end

      user = User.find_by(email: email)
      if user.blank?
        user = User.create!(
          email: email,
          role: "founder",
          password: Devise.friendly_token.first(20)
        )
      end

      submission = OnboardingSubmission.create!(
        role: "founder",
        email: email,
        user: user,
        consented_at: Time.current,
        confirmation_sent_at: Time.current,
        payload: session.fetch(:founder_onboarding, {})
      )

      user.resend_confirmation_instructions unless user.confirmed?

      reset_session
      redirect_to onboarding_check_email_path(email: submission.email)
    else
      redirect_to founder_onboarding_path(step: next_step(@step))
    end
  end

  private

  def valid_step(step)
    step = step.to_s
    return step if STEPS.include?(step)
    STEPS.first
  end

  def next_step(step)
    idx = STEPS.index(step) || 0
    STEPS[[idx + 1, STEPS.length - 1].min]
  end

  def founder_params
    raw = params[:founder_onboarding] || {}
    raw = raw.respond_to?(:permit) ? raw : ActionController::Parameters.new(raw)

    raw.permit(
      user_profile: %i[full_name phone country city],
      startup_profile: [
        :startup_name,
        :description,
        :stage,
        :target_market,
        :value_proposition,
        :funding_stage,
        :funding_raised,
        :sector,
        :other_sector,
        :other_mentorship_area,
        :challenge_details,
        :preferred_mentorship_mode,
        { mentorship_areas: [] }
      ]
    )
  end

  def deep_merge(left, right)
    left.deep_merge(right)
  end
end
