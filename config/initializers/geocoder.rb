# frozen_string_literal: true

# Geocoder Configuration
# Uses free OpenStreetMap/Nominatim service by default

Geocoder.configure(
  # Geocoding service - uses free Nominatim by default
  lookup: :nominatim,
  
  # IP address lookup (optional - for location-based features)
  ip_lookup: :ipinfo,
  
  # Set default units to kilometers
  units: :km,
  
  # Cache geocoding results (useful for rate limiting)
  cache: Rails.cache,
  cache_prefix: 'geocoder:',
  
  # Timeout for geocoding requests
  timeout: 5,
  
  # Raise errors on failure (set to false to fail silently)
  raise_error: false,
  
  # API key for commercial services (not needed for Nominatim)
  # api_key: ENV['GEOCODER_API_KEY']
)

# Configure for production if using a paid service
if Rails.env.production? && ENV['GEOCODER_API_KEY'].present?
  Geocoder.configure(
    lookup: :google,
    api_key: ENV['GEOCODER_API_KEY']
  )
end
