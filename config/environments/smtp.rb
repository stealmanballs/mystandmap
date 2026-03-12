# frozen_string_literal: true

# Action Mailer Configuration
# Configure SMTP settings for production email delivery

Rails.application.configure do
  # Don't bail if SMTP is not configured - allow email to be disabled
  if ENV['SMTP_ADDRESS'].present?
    config.action_mailer.perform_caching = true
    
    config.action_mailer.delivery_method = :smtp
    
    config.action_mailer.smtp_settings = {
      address: ENV.fetch('SMTP_ADDRESS', 'localhost'),
      port: ENV.fetch('SMTP_PORT', 587).to_i,
      domain: ENV.fetch('SMTP_DOMAIN', nil),
      user_name: ENV.fetch('SMTP_USERNAME', nil).presence,
      password: ENV.fetch('SMTP_PASSWORD', nil).presence,
      authentication: ENV.fetch('SMTP_AUTHENTICATION', 'plain').to_sym,
      enable_starttls_auto: ENV.fetch('SMTP_ENABLE_STARTTLS_AUTO', 'true') == 'true',
      open_timeout: 5,
      read_timeout: 5
    }
    
    default_options = { from: ENV.fetch('DEFAULT_FROM_EMAIL', 'noreply@mystandmap.com') }
    
    # Set default from based on environment
    config.action_mailer.default_options = default_options
  else
    # Log warning that email is not configured
    config.after_initialize do
      Rails.logger.warn "WARNING: SMTP not configured. Emails will not be sent. Set SMTP_ADDRESS to enable."
    end
  end
  
  # Configure default URL options for production
  config.action_mailer.default_url_options = {
    host: ENV.fetch('APP_HOST', 'localhost'),
    protocol: ENV.fetch('APP_PROTOCOL', 'https')
  }
  
  # Raise error if email is attempted but not configured (only in production)
  if Rails.env.production? && ENV['SMTP_ADDRESS'].blank?
    config.action_mailer.raise_delivery_errors = false
  end
end
