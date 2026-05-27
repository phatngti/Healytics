# Changelog

All notable changes to Healytics Performance Testing are documented here.  
Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)

---

## [Unreleased]

### Changed
- `perf-test`, `perf-test-docker`, and `perf-test-external` now default to
  `PERF_STRESS_PROFILE=important`, which runs the curated important locustfile
  instead of every active testcase.
- `locustfiles/important.py` no longer imports `PerfHeadlessUser`, so the
  default important profile does not call `/auth/refresh`.
- `perf-analyze` now scores throughput and concurrent users by inferred run profile:
  `small` (`>=100` users, `>=40` RPS), `medium` (`>=500` users, `>=200` RPS),
  and `target/large` (`>=1000` users, `>=500` RPS). Latency and error targets
  remain shared across profiles.
- `perf-headless` now uses a session-oriented USER mix: startup login, low-rate
  repeated login, token refresh, `check-email`, and `account/me`. Transient
  gateway responses on USER auth/read calls are retried before the final attempt
  is counted as a Locust failure.

### Added
- **Current/new API performance coverage**
  - Refreshed generated DTOs from the synced OpenAPI contract.
  - `locustfiles/health_api.py` — `/health` liveness checks.
  - `locustfiles/auth_api.py` — `/auth/check-email` and user/partner/admin/employee login coverage.
  - `locustfiles/employee_api.py` — employee profile, revenue, appointment list/detail, and guarded appointment mutations.
  - `locustfiles/current_new_api.py` — safe read-heavy coverage for public catalog/location reads, account/profile/survey reads, booking search, booking and appointment reads, saved-card listing, wishlist/cart listing, clinic/service/user-specialist/user-category/chat/notification reads, admin dashboard/finance/partner/category/audit/notification reads, and partner profile/catalog/dashboard/booking/employee/service-tag reads.
  - New tags: `health`, `auth`, `employee`, `employee-revenue`, `employee-appointments`, `current-new-api`, `new-api`, `safe-read`, `public-read`, `admin-ops`, `target`, `employee-mutation`.
  - English target reports: `reports/target_report.md` and `reports/target_report.csv`.
  - New Make targets: `perf-test-new-apis`, `perf-test-current-new-apis`, `perf-test-health`, `perf-test-employee`, `perf-test-targets`, `perf-test-employee-mutations`.
- **Updated-module stress tests** for the current backend OpenAPI contract
  - Refreshed `api_docs/openapi.json` from the root `openapi/openapi.json`
  - Regenerated Python DTOs for current modules, including Partner Finance and Partner Employee Analytics
  - `common/discovery.py` — seeded runtime discovery for partner employee, transaction, payout, and refund-case IDs
  - `locustfiles/partner_employee_analytics.py` — read-heavy stress tests for partner employee analytics
  - `locustfiles/partner_finance.py` — read-heavy finance stress tests plus guarded low-rate mutation tasks
  - New tags: `updated`, `partner-finance`, `employee-analytics`, `finance-mutation`, `stress`
  - New Make targets: `perf-test-updated-stress`, `perf-test-partner-finance-stress`, `perf-test-employee-analytics-stress`, `perf-test-updated-mutations`
- **Swarm backend resource stress flow**
  - Performance-only Swarm resource config now lives under `performace/docker_swarm/` instead of the shared deployment tree.
  - Local backend resource profile defaults to strict `2 CPU / 4GB` limits for stress testing.
  - New Make targets: `perf-swarm-apply`, `perf-swarm-inspect`, `perf-swarm-config`, `perf-swarm-start`, `perf-swarm-stop`, `perf-docker-swarm-test`, `perf-stress-small`, `perf-stress-medium`, `perf-stress-large`, `perf-stress-flow`.
  - `perf-stress-flow` starts the Swarm backend autoscaler, runs the selected generated USER stress profile, and stops the autoscaler afterward.
  - `perf-docker-swarm-test` can initialize Swarm for the run, optionally deploy/remove the app stack, and tear it down afterward when it created the Swarm.
- **Dedicated Docker Compose performance stack**
  - Added `performace/docker_swarm/docker-compose.yml`, `compose.env.example`, and backend `.env`-compatible `backend.env.example` for isolated backend performance services.
  - Dedicated stack includes Postgres/PostGIS, Redis, RabbitMQ, Elasticsearch, backend migration/seed jobs, and backend API with strict resource limits.
  - New Make targets: `perf-compose-config`, `perf-compose-start`, `perf-compose-build-backend`, `perf-compose-build`, `perf-compose-infra-up`, `perf-compose-migrate`, `perf-compose-seed`, `perf-compose-start-backend`, `perf-compose-up`, `perf-compose-evaluate-report`, `perf-compose-down`, `perf-compose-kill-services`, `perf-compose-reset`, `perf-compose-logs`, `perf-compose-test`.
  - `perf-compose-test` now runs the full flow: start Compose services, build backend image, start backend with `backend.env`, run stress test, evaluate report, stop test, and kill services.
- **Reduced Makefile entrypoint surface**
  - Added `make perf-test` as the default full-flow command for the dedicated Docker Compose backend stack.
  - Added `make perf-test-docker` as an explicit alias for the dedicated Docker image/services flow.
  - Added `make perf-test-external` and `PERF_BACKEND=external` for running the same perf account, Locust, cleanup, and report lifecycle against an externally managed backend.
  - Added Makefile `help` output that shows the primary commands first while keeping lower-level Compose, Swarm, account, and analysis helpers available for debugging.
  - Added `locustfiles/important.py` and `PERF_STRESS_PROFILE=important` / `perf-stress-important` as the default focused profile for curated important cases.
  - Added `PERF_STRESS_PROFILE=all` / `perf-stress-all` to run every active Locust module through `locustfiles/all_modules.py` when explicitly requested.
  - The all-module support setup now seeds a perf-only booking race product, definition, employee eligibility, and schedule, then exports `PERF_RACE_*` IDs for `booking_race_condition.py`.

### Changed
- Removed stale generated DTO coverage for the old `/ai/recommendations` endpoint.

### Planned
- [x] Implement Auth test scenarios (User / Partner / Admin / Employee login and check-email)
- [x] Implement Account & Survey read flows
- [x] Implement Partner Profile read tests
- [x] Implement Location drill-down tests (Province → District → Ward)
- [ ] Implement Employee CRUD tests
- [ ] Implement Category CRUD tests
- [ ] Implement Health Service (Product) CRUD tests
- [ ] Implement Service Tag CRUD + attach/detach tests
- [x] Implement Admin partner/audit-log read tests
- [x] Implement Booking & Appointment read flow tests
- [x] Implement Cart read and Payment saved-card listing tests
- [x] Implement Chat read tests
- [x] Implement Notification read tests
- [x] Implement Clinic listing & detail tests
- [ ] Implement Review tests
- [ ] Implement Dashboard Partner analytics tests
- [ ] Configure CI/CD pipeline integration
- [ ] Establish performance baselines & SLA thresholds

---

## [0.2.0] — 2026-04-13

### Added
- **WebSocket (Socket.IO) load testing** — full support for all 4 WS namespaces
  - `common/ws_base.py` — shared `HealyticsSocketIOUser` base class with JWT auth, namespace-aware connection, and metric collection
  - `common/ws_data_generators.py` — payload generators for all client→server WS events (matches `ws-contract.json`)
  - `locustfiles/ws_notification_user.py` — `/notifications` namespace (listener-only: `new_notification`, `unread_count`, `broadcast_sent`)
  - `locustfiles/ws_user_chat.py` — `/user-chat` namespace (5 client events, 6 server events, weighted tasks)
  - `locustfiles/ws_partner_chat.py` — `/partner-chat` namespace (extends user-chat, partner auth)
  - `locustfiles/ws_chat_notification_user.py` — `/chat-notifications` namespace (listener-only: `new_message_notification`)
- `python-socketio[client]>=5.10` added to `requirements.txt`
- WebSocket environment variables: `PERF_CHAT_CONVERSATION_ID`, `PERF_CHAT_USER_ID`, `PERF_CHAT_PARTNER_ACCOUNT_ID`, `WS_CONVERSATION_ID`, `WS_RECEIVER_ID`, `WS_USER_CHAT_RECEIVER_ID`, `WS_PARTNER_CHAT_RECEIVER_ID`, `WS_EXTRA_CONVERSATION_IDS`, `WS_EXTRA_RECEIVER_IDS`
- `api_docs/ws-contract.json` — WebSocket contract specification

---

## [0.1.0] — 2026-04-13

### Added
- `CHANGELOG.md` — this file, to track implementation progress

### Removed
- Cleared 11 test-case modules from `locustfiles/` — these were placeholder stubs based on an earlier API contract and need to be rewritten against the current backend
  - `auth_user.py`, `auth_partner.py`, `auth_admin.py`
  - `account_user.py`, `partner_profile.py`
  - `locations.py`, `employees.py`, `categories.py`
  - `products.py`, `service_tags.py`, `admin.py`
- Commented out all imports in `locustfile.py` (will be re-enabled as modules are reimplemented)

### Kept (infrastructure)
- `locustfile.py` — master entry point (imports commented out)
- `locust.conf` — default Locust settings
- `requirements.txt` — Python dependencies (locust, faker)
- `common/` — shared utilities (`config.py`, `auth.py`, `data_generators.py`)
- `api_docs/openapi.json` — OpenAPI specification reference

---

## Module Coverage

| Module | Status | Last Updated |
|---|---|---|
| Auth (User) | ✅ Complete | 2026-05-20 |
| Auth (Partner) | ✅ Complete | 2026-05-20 |
| Auth (Admin) | ✅ Complete | 2026-05-20 |
| Account / Survey | ✅ Read coverage complete | 2026-05-27 |
| Partner Profile | ✅ Read coverage complete | 2026-05-27 |
| Locations | ✅ Complete | 2026-05-27 |
| Employees | ✅ Read coverage complete | 2026-05-27 |
| Partner Employee Analytics | ✅ Complete | 2026-05-01 |
| Categories | ✅ Read coverage complete | 2026-05-27 |
| Health Services | 🔨 In progress | 2026-05-20 |
| Service Tags | ✅ Read coverage complete | 2026-05-27 |
| Admin (Partners) | ✅ Read coverage complete | 2026-05-27 |
| Booking | ✅ Read coverage complete | 2026-05-27 |
| Appointment | ✅ Read coverage complete | 2026-05-27 |
| Cart | ✅ Read coverage complete | 2026-05-27 |
| Payment Gateway | 🔨 In progress | 2026-05-20 |
| Chat / AI Service | ✅ Read coverage complete | 2026-05-27 |
| Notification | ✅ Read coverage complete | 2026-05-27 |
| Clinic | ✅ Read coverage complete | 2026-05-27 |
| Review | ⬜ Not started | — |
| Dashboard Partner | ✅ Complete | 2026-05-27 |
| Partner Finance | ✅ Complete | 2026-05-01 |
| Admin Dashboard | ✅ Complete | 2026-05-20 |
| Admin Finance Read Coverage | ✅ Complete | 2026-05-20 |
| Booking Search | ✅ Complete | 2026-05-20 |
| Profile Summary | ✅ Complete | 2026-05-20 |
| Wishlist List | ✅ Complete | 2026-05-20 |
| Partner Bookings | ✅ Complete | 2026-05-20 |
| Skill Catalog Reads | ✅ Complete | 2026-05-20 |
| **WS: Notifications** | ✅ Complete | 2026-04-13 |
| **WS: User Chat** | ✅ Complete | 2026-04-13 |
| **WS: Partner Chat** | ✅ Complete | 2026-04-13 |
| **WS: Chat Notifications** | ✅ Complete | 2026-04-13 |

> **Status:** ⬜ Not started · 🔨 In progress · ✅ Complete · ⏸️ Blocked
