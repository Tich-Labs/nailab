class Users::PasswordsController < Devise::PasswordsController
  puts "Custom passwords controller loaded"

  protected

  def after_sending_reset_password_instructions_path_for(resource)
    puts "Using custom method"
    new_user_session_path
  end
end