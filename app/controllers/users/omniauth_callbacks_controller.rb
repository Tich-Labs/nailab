class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # Handle Google OAuth2 callback
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      session["devise.google_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url
    end
  end

  # Handle LinkedIn OAuth2 callback for mentor applications
  def linkedin
    auth = request.env["omniauth.auth"]
    session["mentor_application_linkedin_data"] = {
      full_name: "#{auth.info.first_name} #{auth.info.last_name}",
      email: auth.info.email,
      short_bio: auth.info.headline,
      linkedin_url: auth.info.urls.public_profile,
      linkedin_profile_data: auth.to_h
    }
    redirect_to new_mentor_application_path, notice: "LinkedIn profile loaded! Please complete your application."
  end

  # Handle failure
  def failure
    redirect_to root_path
  end
end
