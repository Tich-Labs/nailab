class Partners::SupportController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_partner

  def show
  end

  def create
    # Create support ticket logic here
    # For now, just redirect back with a success message
    redirect_to partners_support_path, notice: "Your support request has been submitted. We'll get back to you soon!"
  end

  private

  def ensure_partner
    unless current_user.partner?
      redirect_to root_path, alert: "Access denied"
    end
  end
end