class DevConfirmationsController < ApplicationController
  before_action :ensure_dev_environment

  # GET /dev/confirm_email/:token
  # Confirms a user by Devise confirmation token (dev/test only).
  def confirm
    token = params[:token]
    if token.blank?
      redirect_to root_path, alert: "Missing confirmation token"
      return
    end

    user = User.confirm_by_token(token)

    if user && user.errors.empty?
      # In development, confirm the account but send tester to the login page
      # so they can sign in normally (matches prod behavior where confirmation
      # typically leads to sign-in). Do not auto-sign-in here.
      redirect_to new_user_session_path, notice: "Email confirmed. Please log in."
    else
      msg = user&.errors&.full_messages&.join(", ") || "Invalid or expired token"
      redirect_to root_path, alert: "Confirmation failed: #{msg}"
    end
  end

  private

  def ensure_dev_environment
    unless Rails.env.development? || Rails.env.test?
      head :not_found
    end
  end
end
