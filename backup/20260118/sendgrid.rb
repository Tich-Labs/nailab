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
    address: ENV.fetch('SENDGRID_SMTP_HOST', 'smtp.sendgrid.net'),
    port: ENV.fetch('SENDGRID_SMTP_PORT', '587'),
    domain: ENV.fetch('SENDGRID_DOMAIN'),
    authentication: 'plain',
    user_name: ENV.fetch('SENDGRID_USERNAME'),
    password: ENV.fetch('SENDGRID_PASSWORD'),
    enable_starttls_auto: true,
    openssl_verify_mode: OpenSSL::SSL::VERIFY_PEER
  }

  # SendGrid API Configuration (alternative to SMTP)
  # Uncomment to use API-based sending instead of SMTP
  # config.sendgrid_action_mailer.api_key = ENV.fetch('SENDGRID_API_KEY')

  # Email tracking and analytics
  config.action_mailer.default_options = {
    from: ENV.fetch('SENDGRID_FROM_EMAIL', 'noreply@nailab.com'),
    from_name: ENV.fetch('SENDGRID_FROM_NAME', 'Nailab'),
    reply_to: ENV.fetch('SENDGRID_REPLY_TO', nil),
    return_path: nil,
    custom_args: {
      # Add SendGrid tracking categories
      'sendgrid_unsubscribe_group' => 'Nailab_Users',
      'unique_args' => [ 'eid', 'uid' ]
    }
  }

  # Email categories for organized sending
  config.action_mailer.delivery_method_options = {
    transactional: {
      category: 'Nailab_Transactional'
    },
    promotional: {
      category: 'Nailab_Promotional'
    },
    user_notifications: {
      category: 'Nailab_Notifications'
    }
  }

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
