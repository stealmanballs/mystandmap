# frozen_string_literal: true

# Production seed file - Only creates admin users
# Demo/test data should NOT be included in production

puts "Setting up production database..."

# Skip in production if explicit admin exists
if ENV['SKIP_PRODUCTION_SEEDS'] == 'true'
  puts "Skipping production seed (SKIP_PRODUCTION_SEEDS=true)"
  exit(0)
end

# Create production admin if not exists
# NOTE: Change the email and password in production!
admin_email = ENV.fetch('ADMIN_EMAIL', 'admin@mystandmap.com')
admin_password = ENV.fetch('ADMIN_PASSWORD', nil)

if admin_password.nil? || admin_password.length < 8
  puts "WARNING: ADMIN_PASSWORD not set or too short. Skipping admin creation."
  puts "Set ADMIN_EMAIL and ADMIN_PASSWORD environment variables to create admin user."
else
  admin = User.find_or_create_by!(email: admin_email) do |user|
    user.name = 'Admin'
    user.password = admin_password
    user.password_confirmation = admin_password
    user.role = 'admin'
  end
  puts "Admin user ready: #{admin.email}"
end

puts "Production setup complete!"
