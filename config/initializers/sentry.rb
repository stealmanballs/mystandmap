# frozen_string_literal: true

# Sentry Error Tracking Configuration
# Set SENTRY_DSN environment variable to enable error tracking

Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  
  # Set traces_sample_rate to capture a percentage of transactions for performance monitoring
  config.traces_sample_rate = ENV.fetch('SENTRY_TRACES_SAMPLE_RATE', 0.1).to_f
  
  # Filter out expected Rails errors in production
  config.excluded_exceptions += ['ActionController::RoutingError', 'ActionController::UnknownFormat']
  
  # Attach user context in development for debugging
  config.send_default_pii = ENV.fetch('SENTRY_SEND_DEFAULT_PII', 'false') == 'true'
  
  # Environment
  config.environment = ENV.fetch('RAILS_ENV', 'development')
  
  # Release tracking
  config.release = ENV.fetch('HEROKU_RELEASE_VERSION', nil)
end
