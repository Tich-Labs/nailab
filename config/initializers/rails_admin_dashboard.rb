require "rails_admin"

Rails.application.config.to_prepare do
  concern_path = Rails.root.join("app", "controllers", "concerns", "admin_layout_data.rb").to_s
  require_dependency concern_path unless defined?(AdminLayoutData)

  [ RailsAdmin::MainController, ApplicationController ].each do |base|
    next unless base
    base.include(AdminLayoutData) unless base.included_modules.include?(AdminLayoutData)
  end
end
