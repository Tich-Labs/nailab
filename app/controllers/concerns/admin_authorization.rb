module AdminAuthorization
  extend ActiveSupport::Concern

  included do
    include Pundit::Authorization
    before_action :authenticate_admin_user!
    after_action :verify_authorized, except: :index
    after_action :verify_policy_scoped, only: :index
  end

  private

  def authenticate_admin_user!
    return redirect_to(root_path, alert: "You must be signed in to access the admin area.") unless current_user

    # Use Pundit to authorize admin access - only true admins allowed
    authorize :admin, :access?
  rescue Pundit::NotAuthorizedError
    redirect_to root_path, alert: "You are not authorized to access the admin area."
  end

  def admin_user
    @admin_user ||= current_user
  end
end
