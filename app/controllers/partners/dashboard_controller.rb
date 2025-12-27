class Partners::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_partner

  def show
    @partner_application = current_user.partner_application || PartnerApplication.new
  end

  private

  def ensure_partner
    unless current_user.partner?
      redirect_to root_path, alert: "Access denied"
    end
  end
end