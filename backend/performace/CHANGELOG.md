# Changelog

All notable changes to Healytics Performance Testing are documented here.  
Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)

---

## [Unreleased]

### Added
- **Updated-module stress tests** for the current backend OpenAPI contract
  - Refreshed `api_docs/openapi.json` from the root `openapi/openapi.json`
  - Regenerated Python DTOs for current modules, including Partner Finance and Partner Employee Analytics
  - `common/discovery.py` — seeded runtime discovery for partner employee, transaction, payout, and refund-case IDs
  - `locustfiles/partner_employee_analytics.py` — read-heavy stress tests for partner employee analytics
  - `locustfiles/partner_finance.py` — read-heavy finance stress tests plus guarded low-rate mutation tasks
  - New tags: `updated`, `partner-finance`, `employee-analytics`, `finance-mutation`, `stress`
  - New Make targets: `perf-test-updated-stress`, `perf-test-partner-finance-stress`, `perf-test-employee-analytics-stress`, `perf-test-updated-mutations`

### Changed
- Removed stale generated DTO coverage for the old `/ai/recommendations` endpoint.

### Planned
- [ ] Implement Auth test scenarios (User / Partner / Admin)
- [ ] Implement Account & Survey test flows
- [ ] Implement Partner Profile tests (GET / PUT public profile)
- [ ] Implement Location drill-down tests (Province → District → Ward)
- [ ] Implement Employee CRUD tests
- [ ] Implement Category CRUD tests
- [ ] Implement Health Service (Product) CRUD tests
- [ ] Implement Service Tag CRUD + attach/detach tests
- [ ] Implement Admin partner review & audit log tests
- [ ] Implement Booking & Appointment flow tests
- [ ] Implement Cart & Payment flow tests
- [ ] Implement Chat / AI Service tests
- [ ] Implement Notification tests
- [ ] Implement Clinic listing & detail tests
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
- WebSocket environment variables: `WS_CONVERSATION_ID`, `WS_RECEIVER_ID`, `WS_EXTRA_CONVERSATION_IDS`, `WS_EXTRA_RECEIVER_IDS`
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
| Auth (User) | ⬜ Not started | — |
| Auth (Partner) | ⬜ Not started | — |
| Auth (Admin) | ⬜ Not started | — |
| Account / Survey | ⬜ Not started | — |
| Partner Profile | ⬜ Not started | — |
| Locations | ⬜ Not started | — |
| Employees | ⬜ Not started | — |
| Partner Employee Analytics | ✅ Complete | 2026-05-01 |
| Categories | ⬜ Not started | — |
| Health Services | ⬜ Not started | — |
| Service Tags | ⬜ Not started | — |
| Admin (Partners) | ⬜ Not started | — |
| Booking | ⬜ Not started | — |
| Appointment | ⬜ Not started | — |
| Cart | ⬜ Not started | — |
| Payment Gateway | ⬜ Not started | — |
| Chat / AI Service | ⬜ Not started | — |
| Notification | ⬜ Not started | — |
| Clinic | ⬜ Not started | — |
| Review | ⬜ Not started | — |
| Dashboard Partner | ⬜ Not started | — |
| Partner Finance | ✅ Complete | 2026-05-01 |
| **WS: Notifications** | ✅ Complete | 2026-04-13 |
| **WS: User Chat** | ✅ Complete | 2026-04-13 |
| **WS: Partner Chat** | ✅ Complete | 2026-04-13 |
| **WS: Chat Notifications** | ✅ Complete | 2026-04-13 |

> **Status:** ⬜ Not started · 🔨 In progress · ✅ Complete · ⏸️ Blocked
