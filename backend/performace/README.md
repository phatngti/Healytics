# Healytics – Locust Performance Tests

Load testing for the Healytics NestJS backend APIs using [Locust](https://locust.io).

## Prerequisites

- **Python >= 3.10** (locust's Socket.IO support requires it; 3.13 recommended)

## Quick Start

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
| `MIN_WAIT` | `1` | Min wait between tasks (seconds) |
| `MAX_WAIT` | `3` | Max wait between tasks (seconds) |
| `PERF_ENABLE_MUTATIONS` | `0` | Enables controlled finance mutation tasks when set to `1` |
| `PERF_ENABLE_EMPLOYEE_MUTATIONS` | `0` | Enables controlled employee appointment mutation tasks when set to `1` |
| `DISCOVERY_PAGE_LIMIT` | `100` | Max rows fetched during seeded runtime discovery |
| `FINANCE_STRESS_PERIODS` | `sevenDays,thirtyDays,ninetyDays` | Comma-separated partner finance periods used by stress tasks |

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
| `WS_CONVERSATION_ID` | _(random UUID)_ | Primary conversation UUID for chat tests |
| `WS_RECEIVER_ID` | _(random UUID)_ | Primary receiver UUID for chat tests |
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

To run every Locust module, use:

```bash
make perf-headless-all PERF_CCU=100 PERF_SPAWN_RATE=20 PERF_RUN_TIME_HEADLESS=120s
```

That target creates the USER pool plus perf-only admin, partner, and employee
support accounts, loads those credentials into Locust, imports all modules from
`locustfiles/all_modules.py`, and deletes the generated accounts afterward.
`make perf-headless-full` and `make perf-test-all-modules` are aliases for the
all-module target.

### Current/new safe-read API coverage

Use the focused current/new API target for recently added read-heavy surfaces:

```bash
make perf-test-current-new-apis
```

This runs the `current-new-api` tag against account/profile reads, booking
search, appointment reads, saved-card listing, wishlist listing, safe clinic and
service detail reads, admin dashboard reads, admin finance reads, partner
booking reads, and partner skill catalog/assigned-service reads. The suite does
not submit follow, wishlist mutation, review, payment, refund, booking status,
card setup, or finance mutation requests.

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

The analyzer writes `reports/analysis_report.html`. KPI scoring uses the latest
meaningful run only: at least 10 seconds, at least 10 requests, and at least one
peak user. Short smoke runs and startup failures are still shown in the timeline
as `EXCLUDED`, but they do not replace the real load-test score.

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
locust --tags health           # Only health check
locust --tags employee         # Employee app read-heavy flows
locust --tags new-api          # Current new/updated API coverage
locust --tags target           # Target-measured API mix
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
WS_CONVERSATION_ID="abc-123-..." \
WS_RECEIVER_ID="def-456-..." \
locust --tags ws,chat -u 20 -r 5 --run-time 2m
```

## Progress

See [CHANGELOG.md](./CHANGELOG.md) for detailed implementation progress and module coverage.
