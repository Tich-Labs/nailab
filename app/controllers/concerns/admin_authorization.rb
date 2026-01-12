module AdminAuthorization
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_admin_user!
  end

  private

  def authenticate_admin_user!
    unless current_user&.admin?
      redirect_to root_path, alert: "You are not authorized to access the admin area."
    end
  end
end
