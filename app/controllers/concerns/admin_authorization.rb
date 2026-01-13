module AdminAuthorization
  extend ActiveSupport::Concern

  ALLOWED_ADMIN_ROLES = %w[founder mentor].freeze

  included do
    before_action :authenticate_admin_user!
  end

  private

  def authenticate_admin_user!
    return redirect_to(root_path, alert: "You must be signed in to access the admin area.") unless current_user

    unless ALLOWED_ADMIN_ROLES.include?(current_user.role.to_s)
      redirect_to root_path, alert: "You are not authorized to access the admin area."
    end
  end
end
