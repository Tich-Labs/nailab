module AdminAuthorization
  extend ActiveSupport::Concern

  included do
    before_action :require_admin
  end

  private

  def require_admin
    unless current_user&.admin?
      respond_to do |format|
        format.html { redirect_to root_path, alert: "You are not authorized to access this section." }
        format.json { render json: { error: "Not authorized" }, status: :forbidden }
      end
    end
  end
end
