class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def linkedin
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      # Create identity record
      @user.identities.find_or_create_by(
        provider: request.env["omniauth.auth"].provider,
        uid: request.env["omniauth.auth"].uid
      )

      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "LinkedIn") if is_navigational_format?
    else
      session["devise.linkedin_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
