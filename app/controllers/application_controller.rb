class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [])
    devise_parameter_sanitizer.permit(:account_update, keys: [])
  end

  def after_sign_up_path_for(resource)
    if resource.is_a?(AdminUser)
      admin_root_path
    else
      mentorship_select_type_path
    end
  end

  def after_sign_in_path_for(resource)
    # 🔴 IMPORTANT: AdminUser must be handled FIRST
    if resource.is_a?(AdminUser)
      admin_root_path

    # Normal users
    elsif resource.is_a?(User)
      if resource.mentorship_requests.pending.any?
        dashboard_path
      else
        mentorship_select_type_path
      end
    else
      root_path
    end
  end
end
