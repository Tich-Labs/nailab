class PartnerOnboardingController < ApplicationController
  before_action :ensure_signed_in
  STEPS = %w[organization type_and_contact focus_and_collab confirm].freeze

  def show
    @step = params[:step] || STEPS.first
    @step_index = STEPS.index(@step) || 0
    @percent_complete = ((@step_index + 1).to_f / STEPS.size * 100).round
    # Signed-in users only: show any persisted partner data if available.
    @partner_onboarding = if current_user.respond_to?(:partner_profile) && current_user.partner_profile
      OpenStruct.new(current_user.partner_profile.attributes)
    else
      OpenStruct.new({})
    end
  end

  def create
    # Here you would handle form submission, e.g., save to DB or send email
    flash[:notice] = "Thank you for your interest in partnering with Nailab! We will be in touch."
    redirect_to partner_onboarding_path
  end

  def update
    @step = params[:step] || STEPS.first
    step_params = partner_onboarding_params

    service_result = Onboarding::Core.call(actor: current_user, role: :partners, step: @step, params: step_params, session: session)

    if service_result.success?
      if service_result.completed?
        # Optionally persisted to Partner or stored in session by the adapter
        redirect_to partner_onboarding_completed_path
      else
        redirect_to partner_onboarding_path(step: service_result.next_step)
      end
    else
      @errors = service_result.errors
      @partner_onboarding = OpenStruct.new(session[:partner_onboarding] || {})
      render :show, status: :unprocessable_entity
    end
  end

  private

  def partner_onboarding_params
    params.fetch(:partner_onboarding, {}).permit(:organization_name, :organization_website, :organization_country, :organization_description, :organization_type, :contact_person, focus_sectors: [], collaboration_areas: [])
  end
  
  def ensure_signed_in
    return if current_user
    flash[:alert] = "Please sign in or create an account to continue onboarding."
    redirect_to new_user_session_path
  end
end
