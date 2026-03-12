# Render Deployment Guide - MyStandMap

## Overview
This guide covers deploying MyStandMap to [Render.com](https://render.com), a popular Platform-as-a-Service for Rails applications.

---

## Prerequisites

1. **GitHub Repository** - Code pushed to GitHub
2. **Render Account** - Sign up at render.com
3. **PostgreSQL Database** - Can be provisioned on Render
4. **SMTP Credentials** - For email (optional but recommended)

---

## Step 1: Create PostgreSQL Database

1. Log in to Render Dashboard
2. Click **New** → **PostgreSQL**
3. Configure:
   - **Name**: `mystandmap-prod`
   - **Database Name**: `mystandmap_production`
   - **User**: `mystandmap`
4. Copy the **Internal Database URL** (will use in environment vars)

---

## Step 2: Create Web Service

1. Click **New** → **Web Service**
2. Connect your GitHub repository
3. Configure:

| Setting | Value |
|---------|-------|
| **Name** | `mystandmap` |
| **Environment** | `Ruby` |
| **Build Command** | `bundle install && bundle exec rails db:migrate && bundle exec rails assets:precompile` |
| **Start Command** | `bundle exec puma -C config/puma.rb` |
| **Plan** | `Free` (or paid as needed) |

---

## Step 3: Environment Variables

Add these in Render Dashboard → Your Web Service → **Environment**:

### Required
```
SECRET_KEY_BASE=<generate with: rails secret>
DATABASE_URL=<from PostgreSQL step>
RAILS_ENV=production
APP_HOST=<your-domain>.onrender.com
APP_PROTOCOL=https
```

### Optional - Email
```
SMTP_ADDRESS=<your-smtp-server>
SMTP_PORT=587
SMTP_USERNAME=<username>
SMTP_PASSWORD=<password>
SMTP_DOMAIN=mystandmap.com
DEFAULT_FROM_EMAIL=noreply@<your-domain>
ADMIN_NOTIFICATION_EMAIL=admin@<your-domain>
```

### Optional - Sentry
```
SENTRY_DSN=<from sentry.io>
```

### Optional - AWS S3 (for file uploads)
```
AWS_ACCESS_KEY_ID=<key>
AWS_SECRET_ACCESS_KEY=<secret>
AWS_REGION=us-east-1
AWS_S3_BUCKET=<bucket-name>
```

---

## Step 4: Configure Active Storage for Production

### Option A: Local Storage (Default - works on Render)
No additional configuration needed. Files stored in container.

### Option B: AWS S3 (Recommended)
Update `config/storage.yml`:

```yaml
amazon:
  service: S3
  access_key_id: <%= ENV['AWS_ACCESS_KEY_ID'] %>
  secret_access_key: <%= ENV['AWS_SECRET_ACCESS_KEY'] %>
  region: <%= ENV['AWS_REGION'] %>
  bucket: <%= ENV['AWS_S3_BUCKET'] %>
```

Update `config/environments/production.rb`:
```ruby
config.active_storage.service = :amazon
```

---

## Step 5: Deploy

1. Click **Create Web Service**
2. Watch build logs for errors
3. If successful, app will be live at `https://mystandmap.onrender.com`

---

## Step 6: Initial Setup

### Run Migrations
```bash
# Render automatically runs db:migrate from build command
# Or via Render dashboard: 
# Your Service → Cron Jobs → New Cron Job
```

### Create Admin User
```bash
# Use Rails console in Render
# Your Service → Shell

rails console
User.create!(
  email: 'admin@yourdomain.com',
  password: 'securepassword123',
  role: 'admin',
  name: 'Admin'
)
```

---

## Step 7: Health Check

The app includes a `/up` endpoint for health checks. Configure in Render:
- **Health Check Path**: `/up`

---

## Troubleshooting

### Build Fails
- Check Ruby version compatibility (3.3.x recommended)
- Ensure all gems in Gemfile are compatible

### Database Connection Error
- Verify DATABASE_URL is set correctly
- Check PostgreSQL instance is running

### Static Assets Not Loading
- Ensure `RAILS_SERVE_STATIC_FILES=true`
- Run `rails assets:precompile` locally and commit

### Email Not Working
- Verify SMTP credentials
- Check logs for delivery errors

---

## Custom Domain (Optional)

1. Go to Render Dashboard → Your Web Service → **Settings**
2. Scroll to **Custom Domains**
3. Add your domain (e.g., `mystandmap.com`)
4. Update DNS records as instructed

---

## Costs

| Service | Free Tier | Paid Options |
|---------|-----------|--------------|
| Web Service | 750 hrs/month | $7+/month |
| PostgreSQL | 1 database | $9+/month |
| Object Storage | - | $5+/month (S3) |

---

## Commands Reference

```bash
# Generate secret key
rails secret

# Run migrations
rails db:migrate

# Precompile assets
rails assets:precompile

# Console in production
rails console -e production
```
