class PartnerOnboardingController < ApplicationController
  skip_before_action :authenticate_user!, raise: false
  before_action :set_partner_application, only: [:show, :update]

  STEPS = %w[organization organization_type contact key_sectors collaboration review].freeze

  # Step-by-step wizard: show current step
  def show
    @step = params[:step] || STEPS.first
  end

  # Update the application for the current step
  def update
    @step = params[:step] || STEPS.first
    if @partner_application.update(partner_application_params)
      if @step == STEPS.last
        if params[:consent].to_s != "1"
          flash[:alert] = "Please confirm you agree before submitting."
          redirect_to partner_onboarding_path(@partner_application, step: @step)
          return
        end

        email = @partner_application.contact_email.to_s.strip.downcase
        if email.blank?
          flash[:alert] = "Please provide an email address."
          redirect_to partner_onboarding_path(@partner_application, step: @step)
          return
        end

        user = User.find_by(email: email)
        if user.blank?
          user = User.create!(
            email: email,
            role: "partner",
            password: Devise.friendly_token.first(20)
          )
        end

        submission = OnboardingSubmission.create!(
          role: "partner",
          email: email,
          user: user,
          consented_at: Time.current,
          confirmation_sent_at: Time.current,
          payload: { "partner_application" => @partner_application.attributes.slice(*@partner_application.attribute_names).merge("id" => @partner_application.id) }
        )

        user.resend_confirmation_instructions unless user.confirmed?

        redirect_to onboarding_check_email_path(email: submission.email)
      else
        next_step = next_onboarding_step(@step)
        redirect_to partner_onboarding_path(@partner_application, step: next_step)
      end
    else
      render :show
    end
  end

  # Final step: thank you or summary
  def complete
    @partner_application = PartnerApplication.find(params[:id])
  end

  # Start a new application
  def new
    @partner_application = PartnerApplication.create
    redirect_to partner_onboarding_path(@partner_application, step: STEPS.first)
  end

  def create
    # Not used; handled by new/show/update in multi-step wizard
    head :not_found
  end

  private

  def set_partner_application
    @partner_application = PartnerApplication.find(params[:id])
  end

  def partner_application_params
    params.require(:partner_application).permit(
      :organization_name,
      :website,
      :country,
      :description,
      :organization_type,
      :other_organization_type,
      :contact_name,
      :contact_email,
      :other_key_sectors,
      :other_collaboration_areas,
      { key_sectors: [] },
      { collaboration_areas: [] }
    )
  end

  def next_onboarding_step(current_step)
    current_index = STEPS.index(current_step)
    STEPS[current_index + 1] if current_index && current_index < STEPS.length - 1
  end
end
