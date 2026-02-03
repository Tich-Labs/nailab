# frozen_string_literal: true

# SendGrid Email Service Configuration
# Uses SMTP for reliable email delivery through SendGrid
# Only configure in production - development uses letter_opener

if Rails.env.production?
  Rails.application.configure do
    if ENV["SMTP_PASSWORD"].present?
      # Use standard SMTP delivery method (works with SendGrid)
      config.action_mailer.delivery_method = :smtp
      config.action_mailer.perform_deliveries = true
      config.action_mailer.raise_delivery_errors = true

      # SendGrid SMTP Configuration
      # Environment variables (set on Render):
      # - SMTP_USERNAME: "apikey" (literal string for SendGrid)
      # - SMTP_PASSWORD: Your SendGrid API key
      # - SMTP_DOMAIN: Your verified sender domain (e.g., nailab.app)
      config.action_mailer.smtp_settings = {
        address: ENV.fetch("SMTP_ADDRESS", "smtp.sendgrid.net"),
        port: ENV.fetch("SMTP_PORT", 587).to_i,
        domain: ENV.fetch("SMTP_DOMAIN", "nailab.app"),
        authentication: :plain,
        user_name: ENV.fetch("SMTP_USERNAME", "apikey"),
        password: ENV["SMTP_PASSWORD"],
        enable_starttls_auto: true
      }

      # Default URL options for mailer links
      config.action_mailer.default_url_options = {
        host: ENV.fetch("APP_HOST", "nailab.app"),
        protocol: "https"
      }
    else
      # SendGrid not configured - disable email delivery to avoid crashes
      config.action_mailer.perform_deliveries = false
      config.action_mailer.raise_delivery_errors = false
      $stderr.puts("[nailab] SendGrid not configured (missing SMTP_PASSWORD); email delivery disabled.")
    end
  end
elsif Rails.env.development?
  Rails.application.configure do
    # Use letter_opener in development for email preview
    config.action_mailer.delivery_method = :letter_opener_web
    config.action_mailer.perform_deliveries = true
    config.action_mailer.default_url_options = { host: "localhost", port: 3000 }
  end
end
