# frozen_string_literal: true

# SendGrid Email Service Configuration
# Provides enterprise-grade email delivery with analytics, tracking, and templates

Rails.application.configure do
  # Set SendGrid as the default delivery method
  config.action_mailer.delivery_method = :sendgrid_action_mailer

  # Raise delivery errors so we can handle them appropriately
  config.action_mailer.raise_delivery_errors = true

  # SendGrid SMTP Configuration
  # Use environment variables for security - never hardcode credentials
  config.action_mailer.smtp_settings = {
    address: ENV.fetch("SMTP_ADDRESS", "smtp.sendgrid.net"),
    port: ENV.fetch("SMTP_PORT", "587"),
    domain: ENV.fetch("SMTP_DOMAIN", "nailab.app"),
    authentication: ENV.fetch("SMTP_AUTHENTICATION", "plain"),
    user_name: ENV.fetch("SMTP_USERNAME"),
    password: ENV.fetch("SMTP_PASSWORD"),
    enable_starttls_auto: true,
    openssl_verify_mode: OpenSSL::SSL::VERIFY_PEER
  }

  # SendGrid API Configuration (alternative to SMTP)
  # Uncomment to use API-based sending instead of SMTP
  # config.sendgrid_action_mailer.api_key = ENV.fetch('SENDGRID_API_KEY')

  # Email tracking and analytics
  config.action_mailer.default_options = {
    from: ENV.fetch("DEVISE_MAILER_SENDER", "noreply@nailab.app"),
    from_name: ENV.fetch("SENDGRID_FROM_NAME", "Nailab"),
    reply_to: ENV.fetch("SENDGRID_REPLY_TO", nil),
    return_path: nil,
    custom_args: {
      # Add SendGrid tracking categories
      "sendgrid_unsubscribe_group" => "Nailab_Users",
      "sendgrid_unique_args" => ->(mail) {
        # Track individual email opens/clicks
        { unique_args: [ "eid", "uid" ] }
      }
    }
  }

  # Email categories - can be set per email as needed
  # Example: mail(to: user.email, subject: "Welcome!", category: "Nailab_Transactional")

  # Error handling and logging
  config.action_mailer.perform_deliveries = true
  config.action_mailer.logger = Rails.logger

  # Development-specific configuration
  if Rails.env.development?
    # In development, deliver emails immediately (no background jobs)
    config.action_mailer.perform_deliveries = true

    # Use letter_opener in development for email preview
    config.action_mailer.delivery_method = :letter_opener_web
  end
end
