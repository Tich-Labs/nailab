# Minimal RailsAdmin initializer to avoid runtime LoadError when the file is missing
# and provide safe defaults for authentication/authorization when common gems are present.

RailsAdmin.config do |config|
  config.asset_source = :importmap
  # If Devise is used, require authentication for the admin area
  # Admin login is separate from regular user - only admin role users can access
  if defined?(Devise)
    config.authenticate_with do
      warden.authenticate! scope: :user
      # Ensure only admin users can access the admin panel
      unless current_user&.admin?
        flash[:alert] = "You are not authorized to access the admin area."
        redirect_to main_app.root_path
      end
    end
    config.current_user_method(&:current_user)
  end

  # If Pundit is available, delegate authorization to it
  if defined?(Pundit)
    config.authorize_with :pundit
  end

  # Load an optional local policy/overrides file if it exists (do not raise if absent)
  local_policy = Rails.root.join("config", "initializers", "rails_admin_policy.rb")
  load local_policy if File.exist?(local_policy)
end
