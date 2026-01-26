# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def create
    # OmniAuth provides a hash with user information
    auth_hash = request.env["omniauth.auth"]
    # Process the data to find or create a user in your database
    # Example: User.find_or_create_from_omniauth(auth_hash)
    # Then log the user in and redirect

    redirect_to root_path, notice: "Signed in successfully with LinkedIn!"
  rescue StandardError => e
    redirect_to root_path, alert: "Authentication error: #{e.message}"
  end

  def failure
    flash[:alert] = "Authentication failed."
    redirect_to root_path
  end
end
