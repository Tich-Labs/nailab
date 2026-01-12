class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def linkedin
    # LinkedIn OAuth is currently disabled.
    redirect_to new_user_session_path, alert: "LinkedIn sign-in is currently unavailable. Please sign in with email."
  end

  def failure
    redirect_to root_path
  end
end
