# Be sure to restart your server when you modify this file.

# Security Headers Configuration
# These headers help protect against common web vulnerabilities

Rails.application.config do
  # Prevent clickjacking
  config.action_dispatch.default_headers = {
    'X-Frame-Options' => 'SAMEORIGIN',
    'X-XSS-Protection' => '0', # Let browser XSS filter be controlled by Content-Security-Policy
    'X-Content-Type-Options' => 'nosniff',
    'X-Permitted-Cross-Domain-Policies' => 'none',
    'Referrer-Policy' => 'strict-origin-when-cross-origin'
  }
end

# Content Security Policy
# Uncomment and customize for your needs in production
# Rails.application.config.content_security_policy do |policy|
#   policy.default_src :self, :https
#   policy.font_src :self, :https, :data
#   policy.img_src :self, :https, :data
#   policy.object_src :none
#   policy.script_src :self, :https
#   policy.style_src :self, :https, 'unsafe-inline'
# end

# Report CSP violations (optional - send to a reporting endpoint)
# Rails.application.config.content_security_policy_report_only = true
