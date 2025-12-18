class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    if resource.user_profile&.role == 'mentor'
      mentor_root_path
    else
      founder_root_path
    end
  end
end