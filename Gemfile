source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.1"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.6"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"
gem "devise" # Authentication
gem "devise-jwt" # Token-based authentication for React
gem "omniauth" # OAuth authentication framework
gem "omniauth-linkedin-oauth2" # LinkedIn OAuth2 provider
gem "omniauth-google-oauth2" # Google OAuth2 provider
gem "omniauth-rails_csrf_protection" # CSRF protection for OmniAuth
gem "sendgrid-ruby" # SendGrid email delivery service
gem "pundit" # Authorization policies
gem "active_storage_validations" # Validations for ActiveStorage uploads
gem "rails_admin" # CMS/Admin interface
gem "rack-attack" # Rate limiting and security
gem "hotwire-rails" # Turbo/Stimulus for interactivity
gem "cssbundling-rails" # TailwindCSS integration
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "google-apis-calendar_v3"   # or 'googleapis_calendar_v3' depending on exact name
# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

gem "rack-cors"

group :development, :test do
  gem "dotenv-rails"
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "bundler-audit", require: false

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  # System testing with Capybara
  gem "capybara"
  gem "selenium-webdriver"
end

group :development, :test do
  # Opens emails in-browser at /letter_opener (great for Devise confirmations)
  gem "letter_opener_web"
  gem "factory_bot_rails"
  gem "rspec-rails"
end
gem "sassc-rails"

gem "tailwindcss-rails", "~> 4.4"

gem "rails_best_practices", "~> 1.23", group: :development

gem "importmap-rails", "~> 2.2"

# Optional client-side WYSIWYG helpers (small convenience). Removed because incompatible with Rails 8+.
# gem 'wysiwyg-rails' (removed)
