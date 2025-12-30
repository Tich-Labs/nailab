class RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      # Founder onboarding
      if session[:founder_onboarding_user_profile]
        user_profile = user.build_user_profile(session[:founder_onboarding_user_profile])
        user_profile.save
      end
      if session[:founder_onboarding_startup_profile]
        startup_profile = user.build_startup_profile(session[:founder_onboarding_startup_profile])
        startup_profile.save
      end
      # Mentor onboarding
      if session[:mentor_onboarding_profile]
        user_profile = user.build_user_profile(session[:mentor_onboarding_profile].merge(role: 'mentor'))
        user_profile.save
      end
      # Send confirmation email (Devise confirmable handles this)
      # Clear onboarding session data
      session[:founder_onboarding_user_profile] = nil
      session[:founder_onboarding_startup_profile] = nil
      session[:mentor_onboarding_profile] = nil
    end
  end

  protected

  def after_sign_up_path_for(resource)
    if resource.user_profile&.role == 'mentor'
      mentor_root_path
    else
      founder_root_path
    end
  end
end