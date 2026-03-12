# Be sure to restart your server when you modify this file.

# Configure your session store for production
Rails.application.config.session_store :cookie_store, key: '_mystandmap_session'

# Use the database for sessions if you want, or use secure cookies
# Rails.application.config.session_store :active_record_store, key: '_mystandmap_session'

# With SSL cookies, set secure: true in production
Rails.application.config.cookie_secure = Rails.env.production?
Rails.application.config.cookie_httponly = true
Rails.application.config.cookie_samesite = :lax

# Set session expiry to 7 days
Rails.application.config.session_options[:expire_after] = 7.days
