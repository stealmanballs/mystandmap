# frozen_string_literal: true

# Environment Variable Validation
# Validates required environment variables at boot time

class EnvironmentValidator
  REQUIRED_VARS = {
    'production' => %w[SECRET_KEY_BASE DATABASE_URL],
    'development' => %w[SECRET_KEY_BASE],
    'test' => %w[SECRET_KEY_BASE]
  }.freeze

  def self.validate!
    return if Rails.env.test?

    env_vars = REQUIRED_VARS[Rails.env] || []
    missing = env_vars.select { |var| ENV[var].blank? }

    return if missing.empty?

    error_message = "Missing required environment variables:\n"
    error_message += missing.map { |var| "  - #{var}" }.join("\n")
    error_message += "\n\nPlease set these variables in your .env file or environment."

    raise ArgumentError, error_message
  end
end

# Validate at Rails boot
Rails.application.config.after_initialize do
  EnvironmentValidator.validate!
end
