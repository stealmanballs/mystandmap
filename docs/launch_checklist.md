# Launch Checklist - MyStandMap

## Pre-Deploy Checks

### Code & Configuration
- [ ] All migrations created and tested locally
- [ ] No pending changes in git
- [ ] Test suite passes (if tests exist)
- [ ] Development server runs without errors

### Environment Variables
- [ ] `SECRET_KEY_BASE` generated and set
- [ ] `DATABASE_URL` configured for production
- [ ] `APP_HOST` set to production domain
- [ ] `SMTP_ADDRESS` configured (for emails)
- [ ] `SENTRY_DSN` configured (for error tracking)

### Dependencies
- [ ] `bundle install` succeeds
- [ ] `rails db:migrate` runs without errors
- [ ] `rails assets:precompile` succeeds

---

## Deploy Steps

1. **Push code to GitHub**
   ```bash
   git push origin main
   ```

2. **Deploy to Render**
   - Connect GitHub repo to Render
   - Set environment variables
   - Deploy web service

3. **Run database migrations**
   - Done automatically via build command OR
   - Run manually via Render shell

4. **Create admin user**
   ```bash
   rails console
   User.create!(email: 'admin@yourdomain.com', password: 'securepassword123', role: 'admin', name: 'Admin')
   ```

5. **Verify health endpoint**
   - Visit `/up` - should return 200 OK

---

## Post-Deploy Smoke Tests

### General
- [ ] Homepage loads
- [ ] No console errors
- [ ] Static assets load correctly
- [ ] Navigation works

### Shopper Flow (Public)
- [ ] Browse stands on map
- [ ] Search stands by name
- [ ] Filter by stand type
- [ ] View stand details
- [ ] Get directions link works
- [ ] View stand photos

### User Flow
- [ ] Sign up new account
- [ ] Receive welcome email (if SMTP configured)
- [ ] Sign in
- [ ] Sign out

### Password Reset Flow
- [ ] Request password reset
- [ ] Receive reset email (if SMTP configured)
- [ ] Reset password successfully

### Farmer Flow
- [ ] Sign in as farmer
- [ ] View farmer dashboard
- [ ] Submit stand claim
- [ ] Receive confirmation email (if SMTP configured)

### Admin Flow
- [ ] Sign in as admin
- [ ] View admin dashboard with metrics
- [ ] View all claims
- [ ] Approve a claim
- [ ] Receive approval email (if SMTP configured)
- [ ] Reject a claim
- [ ] Receive rejection email (if SMTP configured)
- [ ] Import CSV successfully
- [ ] View import results
- [ ] Edit stand details
- [ ] Delete a stand

### File Upload
- [ ] Upload photo to stand (farmer or admin)
- [ ] Photo displays correctly
- [ ] Delete photo

### Geocoding
- [ ] New stand auto-geocodes (if address provided)
- [ ] Manual coordinates preserved

---

## Rollback Notes

If something breaks:

1. **Render Dashboard** → Your Service → **Backups**
2. Restore previous deployment
3. Or rollback via git:
   ```bash
   git revert <bad-commit>
   git push origin main
   ```

---

## Post-Launch Tasks

- [ ] Set up custom domain (optional)
- [ ] Configure CDN for assets (optional)
- [ ] Set up monitoring/alerting
- [ ] Set up regular database backups
- [ ] Configure SSL certificate (auto with Render)
- [ ] Test periodic data exports

---

## Important URLs (Example)

| Purpose | URL |
|---------|-----|
| Production | https://mystandmap.onrender.com |
| Admin | https://mystandmap.onrender.com/admin/dashboard |
| Health Check | https://mystandmap.onrender.com/up |

---

## Support Contacts

- **Technical Issues**: [Your email]
- **Domain Provider**: [Where domain registered]
- **Hosting Support**: Render.com support
