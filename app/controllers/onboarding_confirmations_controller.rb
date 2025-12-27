class OnboardingConfirmationsController < ApplicationController
  skip_before_action :authenticate_user!, raise: false

  def check_email
    @email = params[:email].to_s
    @user = User.find_by(email: @email) if @email.present?
    @confirmation_token = @user&.confirmation_token if @user && !@user.confirmed?
  end

  def resend
    email = params[:email].to_s.strip.downcase
    if email.present?
      user = User.find_by(email: email)
      user&.resend_confirmation_instructions if user.present? && !user.confirmed?
    end

    redirect_to onboarding_check_email_path(email: email)
  end
end
