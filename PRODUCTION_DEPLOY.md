# MyStandMap - Production Deployment Guide

## Overview

This document covers production deployment for MyStandMap, a Wisconsin local farm stand discovery platform.

## Prerequisites

- Ruby 3.3.x
- PostgreSQL 14+
- Node.js 20.x
- Rails 7.2.x

## Environment Variables

Copy `.env.example` to `.env` and configure:

```bash
# Required
SECRET_KEY_BASE=$(rails secret)
RAILS_ENV=production
APP_HOST=your-domain.com

# Database
DATABASE_URL=postgresql://user:password@host:5432/mystandmap_production

# Optional - SMTP (for emails)
SMTP_ADDRESS=smtp.example.com
SMTP_PORT=587
SMTP_USERNAME=your-username
SMTP_PASSWORD=your-password

# Optional - S3 Storage
AWS_ACCESS_KEY_ID=xxx
AWS_SECRET_ACCESS_KEY=xxx
AWS_REGION=us-east-1
AWS_S3_BUCKET=mystandmap-uploads
```

## Deployment Options

### Option 1: Render.com (Recommended)

1. Push code to GitHub
2. Create new Web Service on Render
3. Configure:
   - Build Command: `bundle install && bundle exec rails db:migrate && bundle exec rails assets:precompile`
   - Start Command: `bundle exec puma -C config/puma.rb`
   - Add environment variables

### Option 2: Fly.io

1. Install Fly CLI
2. Run `fly launch`
3. Configure secrets:
   ```bash
   fly secrets set SECRET_KEY_BASE=$(rails secret)
   fly secrets set DATABASE_URL=postgresql://...
   ```
4. Deploy: `fly deploy`

### Option 3: Docker

```bash
# Build
docker build -t mystandmap .

# Run
docker run -d -p 3000:3000 \
  -e RAILS_ENV=production \
  -e SECRET_KEY_BASE=xxx \
  -e DATABASE_URL=postgresql://xxx \
  mystandmap
```

### Option 4: VPS with Capistrano

See `config/deploy.rb` (if created).

## Database Setup

```bash
# Run migrations
rails db:migrate RAILS_ENV=production

# Seed production admin
rails db:seed RAILS_ENV=production

# Or use production seeds (requires ADMIN_EMAIL and ADMIN_PASSWORD)
ADMIN_EMAIL=admin@example.com ADMIN_PASSWORD=securepassword rails db:seed:production
```

## Health Check

The app includes a health check at `/up`. Configure your load balancer to use this endpoint.

## Post-Deployment Checklist

- [ ] Verify app loads at production URL
- [ ] Test public map and stand listings
- [ ] Test farmer signup/login
- [ ] Test admin dashboard access
- [ ] Configure custom domain (if applicable)
- [ ] Set up SSL certificate
- [ ] Configure backup strategy for database
- [ ] Set up monitoring/logging

## Security Considerations

1. **Change default admin credentials** - Update admin email/password immediately
2. **Enable SSL** - Force HTTPS in production
3. **Secure session cookies** - Configured in `config/initializers/session_store.rb`
4. **CSRF protection** - Enabled by default
5. **Security headers** - Configured in `config/initializers/security_headers.rb`

## Troubleshooting

### App won't start
- Check `rails log/production.log`
- Verify environment variables are set
- Check database connection

### 500 errors
- Run `rails assets:precompile`
- Check database migrations
- Review application logs

### Can't log in
- Verify admin user exists: `rails console -e production`
- Check session configuration
