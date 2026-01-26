class Users::SessionsController < Devise::SessionsController
  # Show a clear message if the submitted email belongs to a previously deleted account
  def create
    email = params.dig(:user, :email).to_s.downcase.strip

    if email.present?
      # If a user with that email exists, let Devise handle authentication as normal
      unless User.exists?(email: email)
        if DeletedAccount.exists?(email: email)
          flash[:alert] = "An account with that email was previously deleted. If you need help, contact support at support@nailab.app."
          redirect_to new_user_session_path and return
        end
      end
    end

    super
  end
end
