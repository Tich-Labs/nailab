class CustomDeviseFailure < Devise::FailureApp
  def redirect_url
    if warden_message == :unauthenticated
      # Set custom flash messages based on the attempted path
      if request.path.include?("/founder")
        flash[:alert] = "Please sign in to access founder features."
      elsif request.path.include?("/mentor")
        flash[:alert] = "Please sign in to access mentor features."
      else
        flash[:alert] = "Please sign in or create an account to continue."
      end
    end

    super
  end

  def respond
    if http_auth?
      http_auth
    elsif warden_message == :timeout
      redirect
    else
      redirect
    end
  end
end
