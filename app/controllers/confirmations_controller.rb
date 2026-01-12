class ConfirmationsController < Devise::ConfirmationsController
  # Resend confirmation instructions.
  # In production, SMTP misconfiguration should not crash the request with a 500.
  def create
    begin
      self.resource = resource_class.send_confirmation_instructions(resource_params)
    rescue StandardError => e
      Rails.logger.error("Confirmations#create: failed to send confirmation instructions: #{e.class}: #{e.message}")
      redirect_to new_user_confirmation_path, alert: "We couldn't send confirmation instructions right now. Please try again later."
      return
    end

    if successfully_sent?(resource)
      # Devise will set a notice, but ensure it's always present
      set_flash_message!(:notice, :send_instructions) if is_navigational_format? && flash[:notice].blank?
      redirect_to new_user_session_path
    else
      # If Devise didn't set a message, show a generic error
      flash.now[:alert] ||= "We couldn't send confirmation instructions. Please check your email address and try again."
      respond_with(resource)
    end
  end
end
