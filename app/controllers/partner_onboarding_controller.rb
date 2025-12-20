class PartnerOnboardingController < ApplicationController
  before_action :set_partner_application, only: [ :show, :update ]

  # Step-by-step wizard: show current step
  def show
    @step = params[:step] || "organization"
  end

  # Update the application for the current step
  def update
    @step = params[:step] || "organization"
    if @partner_application.update(partner_application_params)
      next_step = next_onboarding_step(@step)
      if next_step
        redirect_to partner_onboarding_path(@partner_application, step: next_step)
      else
        redirect_to complete_partner_onboarding_path(@partner_application)
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
    # Redirect to multi-step wizard start
    partner_application = PartnerApplication.create
    redirect_to partner_onboarding_path(partner_application, step: "organization")
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
      :organization_name, :website, :country, :description, :organization_type, :contact_name, :contact_email,
      :other_organization_type, :other_key_sectors, :other_collaboration_areas,
      key_sectors: [], collaboration_areas: []
    )
  end

  def next_onboarding_step(current_step)
    steps = %w[organization organization_type contact key_sectors collaboration review]
    idx = steps.index(current_step)
    idx && idx < steps.length - 1 ? steps[idx + 1] : nil
  end
end
