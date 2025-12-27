class Partners::SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_partner

  def show
  end

  def update
    if current_user.update(user_params)
      redirect_to partner_settings_path, notice: "Settings updated successfully"
    else
      render :show
    end
  end

  private

  def ensure_partner
    unless current_user.partner?
      redirect_to root_path, alert: "Access denied"
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end