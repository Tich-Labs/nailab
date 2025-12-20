class RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.persisted?
        resource.create_user_profile(role: params[:role] || 'founder')
      end
    end
  end

  protected

  def after_sign_up_path_for(resource)
    case resource.user_profile&.role
    when 'mentor'
      "/mentor_onboarding/new"
    when 'partner'
      "/partner_onboarding/new"
    else
      founder_root_path
    end
  end
end