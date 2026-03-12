# frozen_string_literal: true

# Rate limiting for authentication endpoints
# Uses Rack::Attack which is included in Rails 7.2+

Rack::Attack.define_throttle(:sign_in_limit, limit: 10, period: 60.seconds) do |req|
  req.ip if req.path == '/signin' && req.post?
end

Rack::Attack.define_throttle(:sign_up_limit, limit: 3, period: 60.seconds) do |req|
  req.ip if req.path == '/signup' && req.post?
end

Rack::Attack.define_throttle(:csv_import_limit, limit: 5, period: 60.seconds) do |req|
  req.ip if req.path == '/admin/stands/import_csv' && req.post?
end

# Custom response when rate limited
Rack::Attack.blocked_response = lambda do |_env|
  [
    429,
    { 'Content-Type' => 'application/json', 'Retry-After' => '60' },
    [{ error: 'Too many requests. Please try again later.' }.to_json]
  ]
end
