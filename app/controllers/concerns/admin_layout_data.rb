module AdminLayoutData
  extend ActiveSupport::Concern

  included do
    helper_method :admin_sidebar_groups, :admin_breadcrumbs
  end

  # Populate minimal admin layout data to avoid boot-time errors when the
  # full admin helpers/concerns were removed. This provides safe defaults
  # so the RailsAdmin layout can render until a richer implementation is restored.
  def set_admin_layout_data
    @admin_pending_startup_approvals = 0
    @admin_pending_requests = 0
    @admin_activity_feed = build_admin_activity_feed
  end

  def build_admin_activity_feed(limit = 10)
    []
  end

  def display_user_name(user)
    return unless user
    user.name.presence || user.email
  end

  def admin_sidebar_groups
    [
      { title: "Content", path: "/admin", sections: [] },
      { title: "Users", path: "/admin/users", sections: [] }
    ]
  end

  def admin_breadcrumbs
    [ { label: "Dashboard", path: rails_admin.dashboard_path } ]
  end
end
