class Partners::ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_partner

  def show
    @partner_application = current_user.partner_application || PartnerApplication.new
  end

  def edit
    @partner_application = current_user.partner_application || current_user.build_partner_application
  end

  def update
    @partner_application = current_user.partner_application || current_user.build_partner_application

    if @partner_application.update(partner_application_params)
      redirect_to partner_profile_path, notice: "Profile updated successfully"
    else
      render :edit
    end
  end

  private

  def ensure_partner
    unless current_user.partner?
      redirect_to root_path, alert: "Access denied"
    end
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
end