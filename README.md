# MyStandMap

A local food discovery platform connecting Wisconsin growers with local consumers.

## Features

- **Public Map**: Browse farm stands, u-pick farms, and farmers markets without login
- **Search & Filter**: Search by city, name, or product
- **Stand Details**: View hours, products, contact info, and get directions
- **Farmer Dashboard**: Claim your stand and update information
- **Admin Panel**: Import stands from CSV, manage claims, view metrics

## Tech Stack

- **Backend**: Rails 7.2
- **Frontend**: HTML + Tailwind CSS (via CDN)
- **Database**: PostgreSQL
- **Auth**: Custom session-based auth with has_secure_password

## Setup

### Prerequisites

- Ruby 3.3+
- PostgreSQL 15+
- Node.js (for optional asset pipeline)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   bundle install
   ```

3. Set up the database:
   ```bash
   cp config/database.yml.example config/database.yml
   # Edit database.yml with your credentials
   bin/rails db:create db:migrate
   ```

4. Seed demo data:
   ```bash
   bin/rails db:seed
   ```

5. Start the server:
   ```bash
   bin/rails server
   ```

The app will be available at http://localhost:3000

## Test Accounts

After running `db:seed`:

| Role     | Email                 | Password    |
|----------|-----------------------|-------------|
| Admin    | admin@mystandmap.com | password123 |
| Farmer   | farmer@example.com   | password123 |
| User     | user@example.com     | password123 |

## Importing Stands

### CSV Format

Create a CSV file with these columns:

```csv
stand_name,address,city,state,zip,latitude,longitude,stand_type,products_available,open_hours,contact_phone,contact_email,website_or_facebook
```

**Supported stand types:**
- `farm_stand` - Traditional farm stand
- `u_pick` - U-pick farm
- `roadside_stand` - Roadside stand
- `farmers_market` - Farmers market

### Import Steps

1. Sign in as admin
2. Go to `/admin/dashboard`
3. Click "Import CSV"
4. Select your CSV file
5. Click "Import"

A template is available at `lib/templates/stands_import_template.csv`

## Environment Variables

Create a `.env` file:

```bash
DATABASE_HOST=localhost
DATABASE_USER=postgres
DATABASE_PASSWORD=postgres
```

## Project Structure

```
app/
├── controllers/     # Rails controllers
├── models/         # ActiveRecord models
├── views/          # ERB templates
config/
├── routes.rb       # Route definitions
└── database.yml    # Database config
db/
├── migrate/        # Database migrations
└── seeds.rb        # Seed data
```

## Routes

| Path | Description |
|------|-------------|
| `/` | Homepage with featured stands |
| `/map` | Map view |
| `/stands` | List of all stands |
| `/stands/:id` | Stand detail page |
| `/signin` | Login page |
| `/signup` | Registration page |
| `/farmer/dashboard` | Farmer dashboard |
| `/admin/dashboard` | Admin dashboard |
| `/admin/stands/import` | CSV import |

## License

MIT
