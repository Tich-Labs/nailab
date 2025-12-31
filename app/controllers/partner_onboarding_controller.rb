class PartnerOnboardingController < ApplicationController
  STEPS = %w[organization type_and_contact focus_and_collab confirm].freeze

  def show
    @step = params[:step] || STEPS.first
    @step_index = STEPS.index(@step) || 0
    @percent_complete = ((@step_index + 1).to_f / STEPS.size * 100).round
    @partner_onboarding = OpenStruct.new(session[:partner_onboarding] || {})
  end

  def create
    # Here you would handle form submission, e.g., save to DB or send email
    flash[:notice] = "Thank you for your interest in partnering with Nailab! We will be in touch."
    redirect_to partner_onboarding_path
  end

  def update
    @step = params[:step] || STEPS.first
    @step_index = STEPS.index(@step) || 0
    @partner_onboarding = OpenStruct.new(session[:partner_onboarding] || {})
    @partner_onboarding.assign_attributes(partner_onboarding_params)
    session[:partner_onboarding] = @partner_onboarding.to_h
    if params[:save_and_exit]
      session[:partner_onboarding] = @partner_onboarding.to_h
      flash[:notice] = "Your progress has been saved. Please create an account to continue later."
      redirect_to new_user_registration_path and return
    end
    if @step_index < STEPS.size - 1
      redirect_to partner_onboarding_path(step: STEPS[@step_index + 1])
    else
      # Final step: clear session and redirect to sign up
      session.delete(:partner_onboarding)
      flash[:notice] = "Thank you for your interest in partnering with Nailab! Please create an account to continue."
      redirect_to new_user_registration_path
    end
  end

  private

  def partner_onboarding_params
    params.fetch(:partner_onboarding, {}).permit(:organization_name, :organization_website, :organization_country, :organization_description, :organization_type, :contact_person, focus_sectors: [], collaboration_areas: [])
  end
end
