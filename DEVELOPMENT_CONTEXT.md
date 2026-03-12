# MyStandMap - Development Context for AI Assistant

## Project Overview

**MyStandMap** is a local food discovery platform connecting Wisconsin growers with local consumers. Built with Rails 7.2, PostgreSQL, and Tailwind CSS.

### Features
- Public map browsing (farm stands, u-pick farms, farmers markets)
- Search & filter by city, name, or product
- Stand details with hours, products, contact info, directions
- Farmer dashboard to claim and manage stands
- Admin panel for CSV imports and claim management
- Photo uploads for stands (up to 5 photos, 5MB each)

### Test Accounts (after db:seed)
| Role | Email | Password |
|------|-------|----------|
| Admin | admin@mystandmap.com | password123 |
| Farmer | farmer@example.com | password123 |
| User | user@example.com | password123 |

---

## Completed Fixes & Improvements

### Bug Fixes
1. **User model stands association** - Fixed to only return stands with approved claims
2. **farmer? method** - Fixed to return true only for farmer role (not admins)
3. **Redundant Stand.find** - Removed duplicate in StandsController#show
4. **Ransackable associations** - Added to Stand model

### Security
1. **CSV import validation** - Added content_type and extension checks
2. **Rate limiting** - Added rack-attack for signin (10/min), signup (3/min), CSV import (5/min)
3. **IDOR protection** - Farmers can only edit stands with approved claims
4. **Env var validation** - Boot-time validation for required variables

### Performance
1. **N+1 queries** - Fixed in admin dashboard with includes(:user, :stand)
2. **Database index** - Added on products_text for search

### New Features
1. **File uploads** - Active Storage for stand photos with validation
2. **Error tracking** - Sentry configuration ready (set SENTRY_DSN env var)
3. **Environment config** - Created .env.example with all required variables

---

## What's NOT Yet Implemented

### High Priority
1. **SMTP Configuration** - No mailer configured yet
   - Need SMTP server details from user
   - Would enable: welcome emails, password reset, claim notifications

2. **Email Views** - No mailer views exist for:
   - Welcome emails
   - Password reset
   - Claim approval/rejection notifications

### Medium Priority
1. **Caching** - Not implemented
2. **CSV Import Logging** - Basic, needs improvement
3. **CSV Import Deduplication** - Basic by name + city
4. **Geocoding** - Not implemented (needs API key)

### Lower Priority
1. **PWA features** - Service worker and manifest exist but need testing
2. **Advanced Search** - Could add more filters
3. **Analytics/Metrics Dashboard** - Could enhance admin dashboard

---

## Tech Stack

- **Ruby**: 3.3.x
- **Rails**: 7.2.3
- **Database**: PostgreSQL
- **Authentication**: Custom session-based (has_secure_password)
- **Frontend**: Tailwind CSS (via CDN)
- **File Storage**: Active Storage (local or S3)
- **Error Tracking**: Sentry (configured, needs DSN)
- **Rate Limiting**: rack-attack

---

## Deployment

The app is Docker-ready. See PRODUCTION_DEPLOY.md for:
- Render.com deployment (recommended)
- Fly.io deployment
- Docker deployment
- VPS with Capistrano

### Required Environment Variables
```
SECRET_KEY_BASE=  # Required
DATABASE_URL=      # Required in production
SENTRY_DSN=        # Optional - for error tracking
AWS_ACCESS_KEY_ID= # Optional - for S3 uploads
AWS_SECRET_ACCESS_KEY=
AWS_REGION=
AWS_S3_BUCKET=
```

---

## File Structure

```
app/
├── controllers/
│   ├── admin/
│   │   ├── claims_controller.rb
│   │   ├── dashboard_controller.rb
│   │   └── stands_controller.rb
│   ├── farmer/
│   │   ├── dashboard_controller.rb
│   │   └── stands_controller.rb
│   ├── application_controller.rb
│   ├── claims_controller.rb
│   ├── registrations_controller.rb
│   ├── sessions_controller.rb
│   └── stands_controller.rb
├── models/
│   ├── claim.rb
│   ├── stand.rb
│   └── user.rb
└── views/
config/
├── initializers/
│   ├── rate_limiting.rb
│   ├── sentry.rb
│   └── environment_validation.rb
├── routes.rb
└── storage.yml
db/
└── migrate/
```

---

## Prompt for AI Assistant

Use the following to continue development:

### Task Examples

1. **Configure SMTP** - Create mailer configuration and views for:
   - Welcome email when user registers
   - Password reset email
   - Claim submitted notification (to admin)
   - Claim approved/rejected notification (to farmer)

2. **Add caching** - Implement fragment caching for:
   - Stand listings
   - Dashboard stats
   - Use Redis or Memcached

3. **Improve CSV import** - Add:
   - Better error reporting with row numbers
   - Deduplication by unique identifier
   - Batch import logging
   - Progress indicator

4. **Add geocoding** - Integrate geocoder gem to:
   - Auto-fill lat/lng from address
   - Reverse geocoding for stand locations

5. **Enhance admin dashboard** - Add:
   - Charts/graphs for stand growth
   - Export to CSV functionality
   - Bulk actions on stands

6. **Security audit** - Review:
   - All authorization checks
   - Input sanitization
   - SQL injection prevention
   - XSS prevention

---

## Commands to Run After Code Changes

```bash
# Install dependencies
bundle install

# Run migrations
bin/rails db:migrate

# Start server
bin/rails server

# Run in production
RAILS_ENV=production SECRET_KEY_BASE=xxx DATABASE_URL=xxx bin/rails server
```

---

## Current Git Status

All changes committed to main branch. Run `git log --oneline` to see history.
