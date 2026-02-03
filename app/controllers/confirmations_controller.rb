class ConfirmationsController < Devise::ConfirmationsController
  # Handle the confirmation link click
  def show
    super
  end

  # Resend confirmation instructions.
  # In production, SMTP misconfiguration should not crash the request with a 500.
  def create
    begin
      self.resource = resource_class.send_confirmation_instructions(resource_params)
    rescue StandardError => e
      Rails.logger.error("Confirmations#create: failed to send confirmation instructions: #{e.class}: #{e.message}")
      # Build a resource with just the email so the form can re-render
      self.resource = resource_class.new(email: params.dig(:user, :email))
      flash.now[:alert] = "We're experiencing technical difficulties with email delivery. Please try again in a few minutes, or contact support if the issue persists."
      render :new, status: :unprocessable_entity and return
    end

    if successfully_sent?(resource)
      # Devise will set a notice, but ensure it's always present
      set_flash_message!(:notice, :send_instructions) if is_navigational_format? && flash[:notice].blank?
      flash[:notice] = "Confirmation instructions have been sent to your email address. Please check your inbox (and spam folder) for the confirmation link."
      redirect_to new_user_session_path
    else
      # If Devise didn't set a message, show a generic error
      flash.now[:alert] ||= "We couldn't send confirmation instructions. Please check your email address and try again."
      render :new, status: :unprocessable_entity
    end
  end
end
