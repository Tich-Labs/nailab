class MentorOnboardingController < ApplicationController
  skip_before_action :authenticate_user!, raise: false

  STEPS = %w[
    basic_details
    work_experience
    mentorship_focus
    mentorship_style
    availability
    review
  ].freeze

  def new
    reset_session
    redirect_to mentor_onboarding_path
  end

  def show
    @step = valid_step(params[:step])
    @profile = UserProfile.new(session.fetch(:mentor_onboarding, {}))
    @progress = progress_for(@step)
  end

  def update
    @step = valid_step(params[:step])

    merged = session.fetch(:mentor_onboarding, {}).merge(mentor_params_for_step.to_h)
    session[:mentor_onboarding] = merged

    session[:mentor_onboarding_email] = params[:email].to_s.strip.downcase if params[:email].present?

    if @step == STEPS.last
      if params[:consent].to_s != "1"
        flash[:alert] = "Please confirm you agree before submitting."
        redirect_to mentor_onboarding_path(step: @step)
        return
      end

      email = session[:mentor_onboarding_email].to_s
      if email.blank?
        flash[:alert] = "Please provide your email address."
        redirect_to mentor_onboarding_path(step: @step)
        return
      end

      user = User.find_by(email: email)
      if user.blank?
        user = User.create!(
          email: email,
          role: "mentor",
          password: Devise.friendly_token.first(20)
        )
      end

      submission = OnboardingSubmission.create!(
        role: "mentor",
        email: email,
        user: user,
        consented_at: Time.current,
        confirmation_sent_at: Time.current,
        payload: { "user_profile" => session.fetch(:mentor_onboarding, {}) }
      )

      user.resend_confirmation_instructions unless user.confirmed?

      reset_session
      redirect_to onboarding_check_email_path(email: submission.email)
    else
      redirect_to mentor_onboarding_path(step: next_step(@step))
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

  def progress_for(step)
    idx = STEPS.index(step) || 0
    ((idx + 1).to_f / STEPS.length * 100).round
  end

  def mentor_params_for_step
    raw = params[:user_profile] || params[:mentor_onboarding] || params[:profile] || {}
    raw = raw.respond_to?(:permit) ? raw : ActionController::Parameters.new(raw)

    raw.permit(
      :full_name,
      :title,
      :bio,
      :linkedin_url,
      :professional_website,
      :organization,
      :years_experience,
      :advisory_experience,
      :advisory_description,
      :other_sector,
      :other_expertise,
      :mentorship_approach,
      :motivation,
      :availability_hours_month,
      :preferred_mentorship_mode,
      :currency,
      :rate_per_hour,
      :pro_bono,
      { sectors: [] },
      { expertise: [] },
      { stage_preference: [] }
    )
  end

  end
