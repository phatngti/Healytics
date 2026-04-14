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

#### WebSocket-specific

| Variable | Default | Description |
|---|---|---|
| `WS_CONVERSATION_ID` | _(random UUID)_ | Primary conversation UUID for chat tests |
| `WS_RECEIVER_ID` | _(random UUID)_ | Primary receiver UUID for chat tests |
| `WS_EXTRA_CONVERSATION_IDS` | _(empty)_ | Comma-separated extra conversation UUIDs for variety |
| `WS_EXTRA_RECEIVER_IDS` | _(empty)_ | Comma-separated extra receiver UUIDs for variety |

### Run with custom host

```bash
locust --host https://staging.healytics.com
```

## Viewing Reports

After a test run completes, results are available through **three channels**:

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

Import into Excel, Google Sheets, or use pandas for analysis:

```python
import pandas as pd
df = pd.read_csv("reports/stats_stats.csv")
print(df[["Name", "Average Response Time", "Requests/s", "Failure Count"]])
```

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
│   ├── ws_base.py             # HealyticsSocketIOUser base class
│   └── ws_data_generators.py  # Faker-based payload generators (WebSocket)
├── locustfiles/               # Test cases (added incrementally)
│   ├── __init__.py
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
locust --tags admin            # Only admin operations
locust --tags products         # Only product CRUD
locust --tags locations        # Only location browsing

# WebSocket tests
locust --tags ws               # All WebSocket tests
locust --tags notifications    # Only notification listener
locust --tags chat             # Chat (user + partner)
locust --tags chat,partner     # Only partner chat
locust --tags chat-notifications  # Only chat notification listener
```

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

