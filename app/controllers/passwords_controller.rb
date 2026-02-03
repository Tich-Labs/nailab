class PasswordsController < Devise::PasswordsController
  # Override to avoid responders/polymorphic_url issues when Devise attempts
  # to build a redirect location from a nil resource name.
  def create
    begin
      self.resource = resource_class.send_reset_password_instructions(resource_params)
    rescue StandardError => e
      Rails.logger.error("Passwords#create: failed to send reset instructions: #{e.class}: #{e.message}")
      # Build a resource with the submitted params so the form can re-render
      self.resource = resource_class.new(resource_params)
      flash.now[:alert] = "We're experiencing technical difficulties with email delivery. Please try again in a few minutes, or contact support if the issue persists."
      render :new, status: :unprocessable_entity and return
    end

    if successfully_sent?(resource)
      set_flash_message!(:notice, :send_instructions) if is_navigational_format?
      redirect_to new_user_session_path
    else
      respond_with(resource)
    end
  end

  # Enhanced password reset with SendGrid integration
  def send_reset_instructions_with_sendgrid
    token, encoded = Devise.token_generator.generate(resource, :reset_password_token)

    # Send password reset email using SendGrid integration
    resource.send_password_reset_instructions_with_sendgrid(token, encoded)

    Rails.logger.info "Password reset sent via SendGrid to #{resource.email}"
  rescue => e
    Rails.logger.error "SendGrid password reset failed: #{e.message}"
    flash.now[:error] = "Failed to send password reset email. Please try again."
  end
end
