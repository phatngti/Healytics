# Healytics – Locust Performance Tests

Load testing for the Healytics NestJS backend APIs using [Locust](https://locust.io).

## Quick Start

```bash
# 1. Create virtual environment
cd performace
python3 -m venv .venv
source .venv/bin/activate

# 2. Install dependencies
pip install -r requirements.txt

# 3. Run with web UI (default: http://localhost:8089)
locust

# 4. Or run headless
locust --headless -u 10 -r 2 --run-time 60s
```

## Configuration

### Environment Variables

| Variable | Default | Description |
|---|---|---|
| `TARGET_HOST` | `http://localhost:3000` | Backend base URL |
| `TEST_USER_EMAIL` | `testuser@example.com` | End-user login email |
| `TEST_USER_PASSWORD` | `s3cureP@ssw0rd` | End-user login password |
| `TEST_PARTNER_EMAIL` | `partner@clinic.com` | Partner login email |
| `TEST_PARTNER_PASSWORD` | `StrongP@ssw0rd!` | Partner login password |
| `TEST_ADMIN_EMAIL` | `admin@healytics.com` | Admin login email |
| `TEST_ADMIN_PASSWORD` | `s3cureP@ssw0rd` | Admin login password |
| `MIN_WAIT` | `1` | Min wait between tasks (seconds) |
| `MAX_WAIT` | `3` | Max wait between tasks (seconds) |

### Run with custom host

```bash
locust --host https://staging.healytics.com
```

## Project Structure

```
performace/
├── locustfile.py              # Master entry point (imports all users)
├── locust.conf                # Default Locust settings
├── requirements.txt           # Python dependencies
├── common/
│   ├── config.py              # Environment-based configuration
│   ├── auth.py                # Login / token helpers
│   └── data_generators.py     # Faker-based payload generators
├── locustfiles/
│   ├── auth_user.py           # End-user auth (register/login/refresh/logout)
│   ├── auth_partner.py        # Partner auth
│   ├── auth_admin.py          # Admin auth
│   ├── account_user.py        # User survey (GET/POST)
│   ├── partner_profile.py     # Partner profile (GET/PUT)
│   ├── locations.py           # Province → district → ward drill-down
│   ├── employees.py           # Doctor/therapist CRUD
│   ├── categories.py          # Category CRUD
│   ├── products.py            # Product CRUD
│   ├── service_tags.py        # Service tag CRUD + attach/detach
│   └── admin.py               # Admin partners + audit logs
└── api_docs/
    └── openapi.json           # Source OpenAPI specification
```

## Running Specific Tests

Use `--tags` to run subsets:

```bash
locust --tags auth             # Only auth flows
locust --tags admin            # Only admin operations
locust --tags products         # Only product CRUD
locust --tags locations        # Only location browsing
```

## API Coverage

| Module | Endpoints | Tags |
|---|---|---|
| Auth (User) | 4 | `auth`, `register`, `login`, `refresh`, `logout` |
| Auth (Partner) | 4 | `auth`, `partner` |
| Auth (Admin) | 3 | `auth`, `admin` |
| Account | 2 | `account`, `survey` |
| Partners | 3 | `partners`, `profile`, `public` |
| Locations | 3 | `locations` |
| Employees | 6 | `employees`, `create`, `read`, `update`, `delete` |
| Categories | 6 | `categories`, `create`, `read`, `update`, `delete` |
| Products | 6 | `products`, `create`, `read`, `update`, `delete` |
| Service Tags | 9 | `service-tags`, `create`, `read`, `update`, `delete`, `attach`, `detach` |
| Admin | 5 | `admin`, `partners`, `review`, `audit` |
| **Total** | **51** | |
