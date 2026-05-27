# Healytics – Locust Performance Tests

Load testing for the Healytics NestJS backend APIs using [Locust](https://locust.io).

## Prerequisites

- **Python >= 3.10** (locust's Socket.IO support requires it; 3.13 recommended)

## Quick Start

Use the Makefile for normal runs:

```bash
# Full managed flow: dedicated Docker image, dependency services, migrations,
# seed data, perf accounts, Locust run, report analysis, and teardown.
make perf-test

# Same flow, explicit name.
# This prints and opens the Locust web UI by default.
make perf-test-docker PERF_STRESS_PROFILE=medium

# Run only the test/account/report lifecycle against an external backend.
# Defaults to the curated important cases, not every testcase.
# This also prints and opens the Locust web UI by default.
make perf-test-external \
  TARGET_HOST=https://dev.healytics.me/backend \
  PERF_EXTERNAL_ACCOUNT_ENV_FILE=/path/to/external-backend-db.env

# Live Locust dashboard for monitoring progress.
# Prints the URL and opens it in the browser when possible.
make perf-ui TARGET_HOST=http://localhost:8080
```

`make perf-test` defaults to `PERF_BACKEND=docker`. To select the external
backend flow through the same command:

```bash
make perf-test PERF_BACKEND=external \
  TARGET_HOST=https://dev.healytics.me/backend \
  PERF_EXTERNAL_ACCOUNT_ENV_FILE=/path/to/external-backend-db.env
```

```bash
# 1. Create virtual environment (use python3.10+ explicitly if needed)
cd performace
python3 -m venv .venv
source .venv/bin/activate

# 2. Install dependencies
pip install -r requirements.txt

# 3. Run with web UI (default: http://localhost:8089)
locust

# 4. Or run headless without stats-table output in the terminal
locust --headless --only-summary --loglevel ERROR -u 10 -r 2 --run-time 60s > reports/locust_stdout.log
```

## Configuration

### Environment Variables

| Variable | Default | Description |
|---|---|---|
| `TARGET_HOST` | `http://localhost:8080` | Backend base URL |
| `TEST_USER_EMAIL` | `user@healytics.vn` | End-user login email |
| `TEST_USER_PASSWORD` | `user@123` | End-user login password |
| `TEST_PARTNER_EMAIL` | `partner@healytics.vn` | Partner login email |
| `TEST_PARTNER_PASSWORD` | `partner@123` | Partner login password |
| `TEST_ADMIN_EMAIL` | `admin@healytics.vn` | Admin login email |
| `TEST_ADMIN_PASSWORD` | `admin@123` | Admin login password |
| `TEST_EMPLOYEE_EMAIL` | `employee.coordinator@healytics.vn` | Employee login email |
| `TEST_EMPLOYEE_PASSWORD` | `employee@123` | Employee login password |
| `PERF_USER_POOL_FILE` | `reports/perf_user_pool.json` | Generated USER-account pool loaded by `common.config.USER_POOL` when present |
| `PERF_STRESS_PROFILE` | `important` | Stress profile for `perf-test*` flows. Use `important` for the focused default, or `all` to run every active testcase. |
| `PERF_CCU` | `10` | Concurrent users for lower-level `perf-headless*` targets; also overrides the selected stress profile CCU when passed to `perf-test*` flows. |
| `PERF_SPAWN_RATE` | `2` | Users spawned per second for lower-level `perf-headless*` targets; also overrides the selected stress profile spawn rate when passed to `perf-test*` flows. |
| `PERF_RUN_TIME_HEADLESS` | `60s` | Run duration for lower-level `perf-headless*` targets; also overrides the selected stress profile runtime when passed to `perf-test*` flows. |
| `MIN_WAIT` | `1` | Min wait between tasks (seconds) |
| `MAX_WAIT` | `3` | Max wait between tasks (seconds) |
| `PERF_HEADLESS_RETRY_MAX_ATTEMPTS` | `3` | Attempts for retryable gateway responses in the USER headless mix |
| `PERF_HEADLESS_RETRY_BASE_SLEEP` | `0.25` | Base backoff in seconds between USER headless gateway retries |
| `PERF_ENABLE_MUTATIONS` | `0` | Enables controlled finance mutation tasks when set to `1` |
| `PERF_ENABLE_EMPLOYEE_MUTATIONS` | `0` | Enables controlled employee appointment mutation tasks when set to `1` |
| `DISCOVERY_PAGE_LIMIT` | `100` | Max rows fetched during seeded runtime discovery |
| `FINANCE_STRESS_PERIODS` | `sevenDays,thirtyDays,ninetyDays` | Comma-separated partner finance periods used by stress tasks |
| `PERF_TEST_WEB_UI` | `1` | Enables the live Locust web UI for `perf-test`, `perf-test-docker`, and `perf-test-external` |
| `PERF_WEB_UI` | `0` | Enables the live Locust web UI for lower-level stress/headless targets when set to `1` |
| `PERF_WEB_UI_AUTOQUIT` | `5` | Seconds to keep the web UI process open after an autostarted run completes |
| `PERF_OPEN_BROWSER` | `1` | Auto-open the Locust web UI when `open`/`xdg-open` is available |
| `LOCUST_WEB_HOST` | `0.0.0.0` | Interface bound by the Locust web UI |
| `LOCUST_WEB_PORT` | `8089` | Port used by the Locust web UI |
| `LOCUST_WEB_URL_HOST` | `localhost` | Hostname printed/opened for the dashboard URL |

#### Target thresholds and external observations

| Variable | Default | Description |
|---|---|---|
| `PERF_API_P95_MS` | `200` | API response-time target, evaluated against aggregate p95 |
| `PERF_TARGET_USERS` | `1000` | Concurrent-user target for target runs |
| `PERF_TARGET_SPAWN_RATE` | `100` | Spawn rate used by `make perf-test-targets` |
| `PERF_RUN_TIME` | `300s` | Run time used by `make perf-test-targets` |
| `PERF_TARGET_TPS` | `500` | Throughput target in transactions/requests per second |
| `PERF_MAX_ERROR_RATE_PERCENT` | `0.01` | Maximum allowed error rate percentage |
| `PERF_APP_LOAD_MS` | `2000` | Application page-load target in milliseconds |
| `PERF_APP_LOAD_RESULT_MS` | _(empty)_ | Optional externally measured page-load result |
| `PERF_MAX_CPU_PERCENT` | `80` | Maximum CPU usage target |
| `PERF_CPU_RESULT_PERCENT` | _(empty)_ | Optional externally measured maximum CPU usage |
| `PERF_MAX_RAM_PERCENT` | `80` | Maximum RAM usage target |
| `PERF_RAM_RESULT_PERCENT` | _(empty)_ | Optional externally measured maximum RAM usage |
| `PERF_MAX_NETWORK_LATENCY_MS` | `100` | Network-latency target in milliseconds |
| `PERF_NETWORK_LATENCY_RESULT_MS` | _(empty)_ | Optional externally measured network-latency result |

#### WebSocket-specific

| Variable | Default | Description |
|---|---|---|
| `PERF_CHAT_CONVERSATION_ID` | _(empty)_ | Conversation UUID generated by `register_perf_accounts.js --with-support-accounts` |
| `PERF_CHAT_USER_ID` | _(empty)_ | Perf USER account ID in the generated chat conversation |
| `PERF_CHAT_PARTNER_ACCOUNT_ID` | _(empty)_ | Perf partner account ID in the generated chat conversation |
| `WS_CONVERSATION_ID` | `PERF_CHAT_CONVERSATION_ID` or random UUID | Primary conversation UUID for chat tests |
| `WS_RECEIVER_ID` | _(random UUID)_ | Primary receiver UUID for chat tests |
| `WS_USER_CHAT_RECEIVER_ID` | `PERF_CHAT_PARTNER_ACCOUNT_ID` or `WS_RECEIVER_ID` | Receiver UUID for `/user-chat` payloads |
| `WS_PARTNER_CHAT_RECEIVER_ID` | `PERF_CHAT_USER_ID` or `WS_RECEIVER_ID` | Receiver UUID for `/partner-chat` payloads |
| `WS_EXTRA_CONVERSATION_IDS` | _(empty)_ | Comma-separated extra conversation UUIDs for variety |
| `WS_EXTRA_RECEIVER_IDS` | _(empty)_ | Comma-separated extra receiver UUIDs for variety |

### Dedicated performance USER accounts

Create a strict pool of USER-role accounts for high-CCU tests. The script mirrors
the backend user registration flow: bcrypt password hash, `account.role = user`,
and a matching `user_profile` row.

```bash
make perf-accounts-create PERF_ACCOUNT_COUNT=1200
make perf-accounts-status
make perf-accounts-clean
```

The generated accounts are scoped to
`perfload-user-NNNNNN@perf.healytics.vn`. A Locust pool file is written to
`reports/perf_user_pool.json`, and `common.config.USER_POOL` uses it
automatically while it exists. `perf-accounts-clean` deletes only USER accounts
in that perf namespace and removes the generated pool files.

`make perf-headless` now creates this USER pool before the run, uses the
USER-only headless entrypoint, and deletes the generated accounts afterward.
The USER-only mix is session-oriented: each virtual user logs in on startup,
then mainly exercises `check-email`, token refresh, and `account/me`. A low-rate
login task remains in the mix, but repeated bcrypt login is not the dominant
medium-profile workload.

To run every Locust module, use:

```bash
make perf-headless-all PERF_CCU=100 PERF_SPAWN_RATE=20 PERF_RUN_TIME_HEADLESS=120s
```

That target creates the USER pool plus perf-only admin, partner, and employee
support accounts, loads those credentials into Locust, imports all modules from
`locustfiles/all_modules.py`, and deletes the generated accounts afterward.
The support-account setup also creates a perf-only booking race product,
definition, employee eligibility, and employee work schedule, then writes
`PERF_RACE_EMPLOYEE_ID` and `PERF_RACE_PRODUCT_ID` to
`reports/perf_user_pool.env` so `locustfiles/booking_race_condition.py` does
not depend on arbitrary seeded catalog data.
`make perf-headless-full` and `make perf-test-all-modules` are aliases for the
all-module target.

### Custom CCU and load shape

The full Makefile flows choose a load shape from `PERF_STRESS_PROFILE`, then let
command-line values override the profile defaults. Use these three variables
when you want custom concurrency:

| Variable | Meaning | Example |
|---|---|---:|
| `PERF_CCU` | Target concurrent users | `250` |
| `PERF_SPAWN_RATE` | Users started per second | `25` |
| `PERF_RUN_TIME_HEADLESS` | Test duration | `240s`, `5m` |

Run the default important external test with custom CCU:

```bash
make perf-test-external \
  TARGET_HOST=https://dev.healytics.me/backend \
  PERF_EXTERNAL_ACCOUNT_ENV_FILE=/Volumes/WD850X/Users/workspace/datn/Healytics/backend/performace/.env \
  PERF_CCU=250 \
  PERF_SPAWN_RATE=25 \
  PERF_RUN_TIME_HEADLESS=240s
```

Run a managed Docker-backed test with the same custom shape:

```bash
make perf-test-docker \
  PERF_STRESS_PROFILE=important \
  PERF_CCU=250 \
  PERF_SPAWN_RATE=25 \
  PERF_RUN_TIME_HEADLESS=240s
```

Run the USER-only headless path directly:

```bash
make perf-headless \
  TARGET_HOST=https://dev.healytics.me/backend \
  PERF_ACCOUNT_ENV_FILE=/Volumes/WD850X/Users/workspace/datn/Healytics/backend/performace/.env \
  PERF_CCU=250 \
  PERF_SPAWN_RATE=25 \
  PERF_RUN_TIME_HEADLESS=240s
```

For stable runs, keep `PERF_SPAWN_RATE` below or equal to `PERF_CCU` and choose
a runtime long enough for all users to finish spawning before the measured
period ends. For example, `PERF_CCU=1000 PERF_SPAWN_RATE=100
PERF_RUN_TIME_HEADLESS=300s` gives roughly 10 seconds to reach peak concurrency
and about 290 seconds at full load.

### Swarm backend resource stress flow

For strict backend resource testing on Docker Swarm, the performance harness
keeps its resource profile under `performace/docker_swarm/` instead of changing
the shared production Swarm deployment tree. Copy
`performace/docker_swarm/env/swarm.env.example` to
`performace/docker_swarm/env/swarm.env` when you need local overrides.

| Variable | Default | Description |
|---|---:|---|
| `BACKEND_LIMIT_CPUS` | `2.0` | Hard CPU limit per backend replica |
| `BACKEND_LIMIT_MEMORY` | `4G` | Hard memory limit per backend replica |
| `BACKEND_AUTOSCALE_MIN_REPLICAS` | `1` | Minimum backend replicas for the autoscaler |
| `BACKEND_AUTOSCALE_MAX_REPLICAS` | `4` | Maximum backend replicas for the autoscaler |
| `BACKEND_AUTOSCALE_CPU_UP_PERCENT` | `80` | Scale up when average sampled backend CPU is at or above this value |
| `BACKEND_AUTOSCALE_CPU_DOWN_PERCENT` | `35` | Scale down when average sampled backend CPU is at or below this value |

Run the one-command stress flow from this performance harness:

```bash
make -C /Volumes/WD850X/Users/workspace/datn/Healytics/backend/performace perf-stress-flow \
  TARGET_HOST=http://localhost:8000/backend
```

The flow inspects the Swarm backend service resources, starts
`performace/docker_swarm/scripts/swarm-backend-autoscale.sh`, applies the local
backend CPU/RAM limit profile with `docker service update`, runs the selected
generated USER stress profile, and stops the autoscaler on exit or Ctrl+C.
Stress profiles are:

| Profile | CCU | Spawn rate | Runtime |
|---|---:|---:|---:|
| `important` | `100` | `20/s` | `180s` |
| `small` | `100` | `20/s` | `180s` |
| `medium` | `500` | `50/s` | `300s` |
| `large` | `1000` | `100/s` | `300s` |
| `all` | `100` | `20/s` | `180s` |

The default `important` profile runs the curated important API mix from
`locustfiles/important.py`. The `all` profile runs the full active Locust
surface from `locustfiles/all_modules.py`. The `small`, `medium`, and `large`
profiles are explicit USER-only stress profiles for auth/session pressure
tests.

Command-line overrides win for load shape:

```bash
make -C /Volumes/WD850X/Users/workspace/datn/Healytics/backend/performace perf-stress-flow \
  PERF_STRESS_PROFILE=large \
  PERF_CCU=750 \
  TARGET_HOST=http://localhost:8000/backend
```

Useful Swarm-only helpers:

```bash
make perf-swarm-apply    # Apply the local performance CPU/RAM limits to healytics_backend
make perf-swarm-inspect  # Print the active backend service resource limits
make perf-swarm-config   # Render the base app stack with the local performance override
```

### Dedicated Docker Compose performance stack

`performace/docker_swarm/docker-compose.yml` provides an isolated Compose stack
for backend performance testing. It is based on the main
`/Volumes/WD850X/Users/workspace/datn/Healytics/dockers/docker-compose.yml`
service contracts, but keeps dedicated container names, ports, network, and
volumes for tests.

The stack includes:

| Service | Purpose | Default host port |
|---|---|---:|
| `postgres` | Postgres/PostGIS database | `55432` |
| `redis` | Redis cache/session/throttling backend | `56379` |
| `rabbitmq` | Single-node RabbitMQ for checkout queue tests | `55672`, `15672` |
| `elasticsearch` | Booking search index backend | `59200` |
| `backend-migrate` | One-shot migration job | _(none)_ |
| `backend-seed` | One-shot seed job | _(none)_ |
| `backend` | Backend API under strict perf limits | `8080` |

Copy `performace/docker_swarm/compose.env.example` to
`performace/docker_swarm/compose.env` to override ports, image tags, credentials,
or backend limits. Copy `performace/docker_swarm/backend.env.example` to
`performace/docker_swarm/backend.env` to override backend runtime values. The
backend env file follows the same key contract as
`/Volumes/WD850X/Users/workspace/datn/Healytics/backend/.env`, with Docker
service names such as `postgres`, `redis`, `rabbitmq`, and `elasticsearch`.

Common commands:

```bash
make perf-test
make perf-test-docker
make perf-compose-config
make perf-compose-build
make perf-compose-start
make perf-compose-build-backend
make perf-compose-start-backend
make perf-compose-evaluate-report
make perf-compose-up
make perf-compose-down
make perf-compose-reset  # down + delete dedicated perf volumes
```

Run Locust against the dedicated Compose stack and stop containers afterward:

```bash
make -C /Volumes/WD850X/Users/workspace/datn/Healytics/backend/performace perf-compose-test \
  PERF_STRESS_PROFILE=medium
```

The `perf-compose-test` lifecycle is:

1. Start dedicated Compose dependency services.
2. Build backend and migration images.
3. Start the backend service using `backend.env`.
4. Generate `reports/perf_compose_account.env` so perf account creation uses
   the dedicated Compose database from the host.
5. Run the selected Locust stress profile.
6. Evaluate the generated reports with `make perf-analyze`.
7. Stop the test and kill dedicated Compose services.

By default, backend startup runs migrations and seed data before starting the
API container. Disable either step with `PERF_COMPOSE_RUN_MIGRATIONS=0` or
`PERF_COMPOSE_RUN_SEED=0`. Disable report evaluation with
`PERF_COMPOSE_EVALUATE_REPORT=0`.

### External backend performance flow

Use `perf-test-external` when the backend is already running outside this
performance harness, such as a deployed dev environment or a manually managed
local backend. This flow does not build images or start services. It checks the
target `/health` endpoint, creates the perf account pool in the backend's
database, runs the selected stress profile, cleans up generated accounts, and
evaluates the report.

By default, `PERF_STRESS_PROFILE=important`. That profile uses
`locustfiles/important.py` and runs only the curated important read-heavy cases:
auth login/check-email, health, employee reads, and safe read-heavy current/new
public, user, employee, admin, and partner API coverage. It does not run
`/auth/refresh` and does not run every testcase. Use
`PERF_STRESS_PROFILE=all` only when you intentionally want the full module
surface.

```bash
make -C /Volumes/WD850X/Users/workspace/datn/Healytics/backend/performace perf-test-external \
  TARGET_HOST=https://dev.healytics.me/backend \
  PERF_EXTERNAL_ACCOUNT_ENV_FILE=/absolute/path/to/external-backend-db.env
```

The external account env file must contain host-accessible database settings for
the target backend:

```dotenv
POSTGRES_HOST=...
POSTGRES_PORT=5432
POSTGRES_USER=...
POSTGRES_PASSWORD=...
POSTGRES_DB=...
PERF_ACCOUNT_PASSWORD=Perf@12345
```

If the external backend does not expose `/health`, use
`PERF_EXTERNAL_HEALTHCHECK=0`.

To let the Makefile manage the local Swarm lifecycle for a performance run:

```bash
make -C /Volumes/WD850X/Users/workspace/datn/Healytics/backend/performace perf-docker-swarm-test \
  TARGET_HOST=http://localhost:8000/backend \
  PERF_STRESS_PROFILE=medium
```

This target starts Swarm if it is not already active, runs `perf-stress-flow`,
kills backend task containers, and leaves Swarm mode when the target created the
Swarm. If Swarm was already active, it leaves the existing Swarm running and
does not kill backend containers unless `PERF_FORCE_SWARM_TEARDOWN=1` is set.

If the backend Swarm service is not already deployed and your test machine has
the required images, env values, and Swarm secrets, let the target deploy and
remove the app stack for the run:

```bash
make -C /Volumes/WD850X/Users/workspace/datn/Healytics/backend/performace perf-docker-swarm-test \
  PERF_SWARM_DEPLOY_STACK=1 \
  TARGET_HOST=http://localhost:8000/backend
```

### Current/new safe-read API coverage

Use the focused current/new API target for recently added read-heavy surfaces:

```bash
make perf-test-current-new-apis
```

This runs the `current-new-api` tag against public catalog/location reads,
account/profile/survey reads, booking search, booking and appointment reads,
saved-card listing, wishlist/cart listing, safe clinic and service detail reads,
user specialist/category/chat/notification reads, employee profile/revenue reads,
admin dashboard/finance/partner/category/audit/notification reads, and partner
profile/catalog/dashboard/booking/employee/service-tag reads. The suite does not
submit follow, wishlist mutation, review, payment, refund, booking status, card
setup, profile update, CRUD, or finance mutation requests.

### Run with custom host

```bash
locust --host https://staging.healytics.com
```

## Viewing Reports

After a test run completes, results are available through **three channels**:

Headless Makefile runs keep Locust's stats-table stdout in
`reports/locust_<timestamp>.stdout.log` and leave stderr visible so ERROR-level
logs still appear in the terminal.

### 1. Web UI Dashboard (Interactive)

When running with `headless = false` (default), the Locust web UI is accessible at:

```
http://localhost:8089
```

The full Makefile test flows print this URL and open it automatically when possible:

```bash
make perf-test-docker PERF_STRESS_PROFILE=medium
make perf-test-external TARGET_HOST=https://dev.healytics.me/backend PERF_EXTERNAL_ACCOUNT_ENV_FILE=/path/to/db.env
make perf-ui TARGET_HOST=http://localhost:8080
```

Disable auto-open, disable the live UI for full test flows, or use a different web UI port:

```bash
make perf-test-docker PERF_OPEN_BROWSER=0
make perf-test-external PERF_TEST_WEB_UI=0 TARGET_HOST=https://dev.healytics.me/backend PERF_EXTERNAL_ACCOUNT_ENV_FILE=/path/to/db.env
make perf-ui LOCUST_WEB_PORT=8090
```

The dashboard shows real-time charts for:
- **Requests per second** (RPS)
- **Response time** (median, 95th percentile, 99th percentile)
- **Number of active users**
- **Failure rate**

You can also download CSV/HTML reports directly from the web UI via the **Download Data** tab.

### 2. HTML Report (Auto-generated)

Every run automatically generates a self-contained HTML report at:

```
reports/report.html
```

Open it in any browser:

```bash
open reports/report.html        # macOS
xdg-open reports/report.html    # Linux
```

The HTML report includes:
- Request statistics table (min/max/avg/median response times, RPS, failure %)
- Response time distribution chart
- Number of users chart
- Response time percentiles

#### Timestamped Reports (Archival)

To keep historical reports without overwriting, use a timestamped filename:

```bash
locust --html reports/report_$(date +%Y-%m-%d_%H-%M-%S).html
```

Or use the helper from `config.py`:

```python
from common.config import get_timestamped_report_path
# Returns: 'reports/report_2026-04-13_23-20-00.html'
```

### 3. CSV Stats (Machine-readable)

CSV files are auto-generated with the prefix `reports/stats`:

| File | Content |
|---|---|
| `reports/stats_stats.csv` | Per-request type statistics |
| `reports/stats_stats_history.csv` | Time-series stats data |
| `reports/stats_failures.csv` | Failed request details |
| `reports/stats_exceptions.csv` | Exception traces |
| `reports/hardware_config.json` | Host hardware/runtime snapshot printed before Locust runs and embedded in the analysis dashboard |
| `reports/target_report.md` | English performance target summary table |
| `reports/target_report.csv` | CSV version of the target summary table |

Import into Excel, Google Sheets, or use pandas for analysis:

```python
import pandas as pd
df = pd.read_csv("reports/stats_stats.csv")
print(df[["Name", "Average Response Time", "Requests/s", "Failure Count"]])
```

### 4. Consolidated Analysis Dashboard

Generate the cross-run dashboard from every Locust HTML report:

```bash
make perf-analyze
```

The analyzer writes `reports/analysis_report.html`. The dashboard includes the
hardware/runtime configuration captured when Locust started, including host OS,
CPU, memory, disk free space, load average, target host, and backend resource
limits when those limits are exported. KPI scoring uses the latest meaningful
run only: at least 10 seconds, at least 10 requests, and at least one peak user.
Short smoke runs and startup failures are still shown in the timeline as
`EXCLUDED`, but they do not replace the real load-test score.

`perf-analyze` is profile-aware for throughput and concurrent-user scoring:

| Profile | Peak users | Min RPS |
|---|---:|---:|
| `small` | `>= 100` | `>= 40` |
| `medium` | `>= 500` | `>= 200` |
| `target/large` | `>= 1000` | `>= 500` |

Latency and error targets stay the same across profiles: average response time
`<= 200ms`, P95 `<= 500ms`, and error rate `<= 0.01%`. Use the large profile
or `make perf-test-targets` when you need the strict 1000-user / 500-RPS target
score.

For backend-side metrics during a Locust run, enable the opt-in perf logger:

```bash
PERF_MODE=true PERF_METRICS_ENABLED=true make perf-headless
```

It logs interval summaries for event-loop delay and per-route p50/p95/p99
latency without per-request response-body logging.

## Project Structure

```
performace/
├── CHANGELOG.md               # Implementation progress tracker
├── README.md                  # This file
├── locustfile.py              # Master entry point (imports all users)
├── locust.conf                # Default Locust settings (report output configured)
├── requirements.txt           # Python dependencies
├── reports/                   # Generated reports (git-ignored except .gitkeep)
│   ├── .gitkeep
│   ├── .gitignore
│   ├── report.html            # Latest HTML report (auto-generated)
│   └── stats_*.csv            # Latest CSV stats (auto-generated)
├── docker_swarm/              # Performance-only Compose/Swarm resource profile
│   ├── backend.env.example
│   ├── compose.env.example
│   ├── docker-compose.yml
│   ├── env/swarm.env.example
│   ├── stack/healytics.performance.yml
│   └── scripts/swarm-backend-autoscale.sh
├── common/
│   ├── config.py              # Environment-based configuration + report paths
│   ├── auth.py                # Login / token helpers
│   ├── data_generators.py     # Faker-based payload generators (HTTP)
│   ├── discovery.py           # Seeded runtime ID discovery for stress tests
│   ├── ws_base.py             # HealyticsSocketIOUser base class
│   └── ws_data_generators.py  # Faker-based payload generators (WebSocket)
├── locustfiles/               # Test cases (added incrementally)
│   ├── __init__.py
│   ├── current_new_api.py           # Safe read-heavy current/new API coverage
│   ├── partner_employee_analytics.py # Partner employee analytics stress tests
│   ├── partner_finance.py            # Partner finance stress + guarded mutations
│   ├── ws_notification_user.py     # /notifications namespace
│   ├── ws_user_chat.py             # /user-chat namespace
│   ├── ws_partner_chat.py          # /partner-chat namespace
│   └── ws_chat_notification_user.py # /chat-notifications namespace
└── api_docs/
    ├── openapi.json           # Source OpenAPI specification
    └── ws-contract.json       # WebSocket contract specification
```

## Running Specific Tests

Use `--tags` to run subsets:

```bash
# HTTP API tests
locust --tags auth             # Only auth flows
locust --tags current-new-api  # Safe read-heavy current/new API coverage
locust --tags public-read      # Public catalog/location/map client-key reads
locust --tags admin-ops        # Admin partner/category/audit/notification reads
locust --tags health           # Only health check
locust --tags employee         # Employee app read-heavy flows
locust --tags new-api          # Current new/updated API coverage
locust -f locustfiles/important.py  # Curated important API mix
locust --tags admin            # Only admin operations
locust --tags products         # Only product CRUD
locust --tags locations        # Only location browsing
locust --tags updated          # Updated-module stress tests
locust --tags stress           # All stress-tagged scenarios
locust --tags partner-finance  # Partner finance read-heavy stress
locust --tags employee-analytics  # Partner employee analytics stress

# Controlled finance mutations (disabled unless explicitly enabled)
PERF_ENABLE_MUTATIONS=1 locust --headless --only-summary --tags finance-mutation -u 2 -r 1 --run-time 60s

# WebSocket tests
locust --tags ws               # All WebSocket tests
locust --tags notifications    # Only notification listener
locust --tags chat             # Chat (user + partner)
locust --tags partner          # Only partner chat
locust --tags chat-notifications  # Only chat notification listener
```

### Updated-module stress tests

The `updated` stress suite targets the backend modules added or changed after
the original performance contract snapshot:

| Module | Endpoints |
|---|---|
| Partner Employee Analytics | `/partner/employees/analytics/overview`, `/partner/employees/analytics/:employeeId` |
| Partner Transactions | `/partner/transactions/finance/summary`, `/partner/transactions/finance/trend`, `/partner/transactions`, `/partner/transactions/:transactionId` |
| Partner Payouts | `/partner/payouts` |
| Partner Refund Cases | `/partner/refund-cases` |

The suite logs in as the configured partner account, discovers seeded employee,
transaction, payout, and refund-case IDs at runtime, then reuses those IDs for
read-heavy stress requests. Mutation endpoints are isolated behind the
`finance-mutation` tag and `PERF_ENABLE_MUTATIONS=1`.

Make helpers:

```bash
make perf-test-updated-stress
make perf-test-partner-finance-stress
make perf-test-employee-analytics-stress
make perf-test-new-apis
make perf-test-health
make perf-test-employee
make perf-test-targets
PERF_ENABLE_MUTATIONS=1 make perf-test-updated-mutations
PERF_ENABLE_EMPLOYEE_MUTATIONS=1 make perf-test-employee-mutations
```

### English target report

Every Locust run writes `reports/target_report.md` and
`reports/target_report.csv` with these rows:

| Criterion | Requirement | Result |
|---|---:|---:|
| API Response Time | `< 200 ms` | Locust aggregate p95 |
| Application Page Load | `< 2,000 ms` | `PERF_APP_LOAD_RESULT_MS` or `Not measured` |
| Concurrent Users | `>= 1,000` | Max observed Locust users |
| Throughput | `>= 500 TPS` | Aggregate Locust requests per second |
| Error Rate | `< 0.01%` | Aggregate Locust failure percentage |
| Maximum CPU Usage | `< 80%` | `PERF_CPU_RESULT_PERCENT` or `Not measured` |
| Maximum RAM Usage | `< 80%` | `PERF_RAM_RESULT_PERCENT` or `Not measured` |
| Network Latency | `< 100 ms` | `PERF_NETWORK_LATENCY_RESULT_MS` or `Not measured` |

## WebSocket Testing

The suite supports Socket.IO-based WebSocket load testing across 4 namespaces:

| Namespace | Tag(s) | Auth Role | Type |
|---|---|---|---|
| `/notifications` | `ws`, `notifications` | `user` | Listener-only |
| `/user-chat` | `ws`, `chat` | `user` | Active (5 events) |
| `/partner-chat` | `ws`, `chat`, `partner` | `health_partner` | Active (5 events) |
| `/chat-notifications` | `ws`, `chat-notifications` | `user` | Listener-only |

### Locust Metrics for WebSocket

| Type | Description |
|---|---|
| `WS` | Socket.IO connection |
| `WSE` | Event emitted (fire-and-forget) |
| `WSC` | Event called (with ack, round-trip measured) |
| `WSR` | Event received from server |

### Example: Run chat load test with real data

```bash
WS_CONVERSATION_ID="conversation-uuid" \
WS_USER_CHAT_RECEIVER_ID="partner-account-uuid" \
WS_PARTNER_CHAT_RECEIVER_ID="user-account-uuid" \
locust --tags ws,chat -u 20 -r 5 --run-time 2m
```

## Progress

See [CHANGELOG.md](./CHANGELOG.md) for detailed implementation progress and module coverage.
