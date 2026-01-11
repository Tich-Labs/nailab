class PasswordsController < Devise::PasswordsController
  # Override to avoid responders/polymorphic_url issues when Devise attempts
  # to build a redirect location from a nil resource name.
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    if successfully_sent?(resource)
      set_flash_message!(:notice, :send_instructions) if is_navigational_format?
      redirect_to new_user_session_path
    else
      respond_with(resource)
    end
  end
end
