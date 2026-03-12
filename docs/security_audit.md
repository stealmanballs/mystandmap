# Security Audit - MyStandMap

## Date
2026-03-12

## Issues Checked

### 1. Authentication & Authorization ✅
- **Custom session-based auth** - Using `has_secure_password` with bcrypt
- **Role-based access** - Admin, Farmer, User roles enforced
- **Password reset** - Token-based with 2-hour expiration
- **Session management** - Uses Rails session storage

**Fixes Applied:**
- IDOR protection in farmer stands controller (only approved stands accessible)
- Password reset tokens are cryptographically secure (48-char URL-safe base64)
- Password reset tokens expire after 2 hours

### 2. Input Validation ✅
- **Strong parameters** - All controllers use `permit` for mass assignment
- **Photo validation** - Content type and file size limits (5MB max)
- **CSV import validation** - Content type, extension, and header checks

### 3. SQL Injection ✅
- **Parameterized queries** - Using ActiveRecord with proper escaping
- **Ransackable attributes** - Whitelist allowed search fields
- **No raw SQL** - All queries use ActiveRecord

### 4. XSS Protection ✅
- **Rails CSRF protection** - Enabled by default
- **Content sanitization** - Uses Rails built-in escaping
- **User input** - Displayed with proper escaping in views

### 5. File Upload Security ✅
- **Allowed content types** - JPEG, PNG, WebP, GIF only
- **File size limit** - 5MB max per image
- **Max files** - 5 photos per stand
- **Active Storage** - Uses Rails secure blob storage

### 6. Rate Limiting ✅
- **Rack-attack configured** for:
  - Sign in: 10 requests/minute
  - Sign up: 3 requests/minute
  - CSV import: 5 requests/minute

### 7. Environment Security ✅
- **Environment validation** - Boot-time check for required vars in production
- **Secrets management** - Uses Rails credentials/master.key
- **.env.example** - Documents required variables without exposing values

### 8. SSL/TLS ✅
- **Force SSL** enabled in production
- **Secure cookies** configured

### 9. Error Handling ✅
- **Sentry integration** - For error tracking
- **Custom error pages** - Friendly 404/500 pages

## Fixes Made

1. **IDOR Vulnerability** - Farmers can only access stands with approved claims
2. **CSV Import** - Added file type/extension validation, duplicate checking
3. **Password Reset** - Implemented secure token-based flow with expiration
4. **Admin Dashboard** - Fixed N+1 queries with proper eager loading
5. **Rate Limiting** - Added rack-attack for auth endpoints

## Known Remaining Risks

1. **No captcha on signup** - Could be added for spam prevention
2. **Email enumeration** - Password reset shows same message for valid/invalid emails (intentional security measure)
3. **No 2FA** - Consider adding for admin accounts in future
4. **No IP rate limiting on API** - Could be added for heavy usage
5. **SMTP not configured** - Email features won't work until SMTP credentials added

## Recommendations for Production

1. **Set up SMTP** - Configure mailer with real credentials
2. **Add Sentry DSN** - Enable error tracking in production
3. **Configure AWS S3** - For persistent file storage (optional)
4. **Set up monitoring** - Consider adding health checks beyond /up
5. **Review admin users** - Ensure only necessary users have admin role

## Test Credentials

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@mystandmap.com | password123 |
| Farmer | farmer@example.com | password123 |
| User | user@example.com | password123 |
