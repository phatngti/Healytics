.PHONY: perf-ui perf-headless perf-headless-all perf-headless-full perf-test-all-modules \
	perf-test-auth perf-test-admin perf-test-products \
	perf-test-locations perf-test-ws perf-test-chat \
	perf-test-updated-stress perf-test-partner-finance-stress \
	perf-test-employee-analytics-stress perf-test-updated-mutations \
	perf-test-new-apis perf-test-current-new-apis perf-test-health perf-test-employee \
	perf-test-targets perf-test-employee-mutations \
	perf-test-booking-race perf-test-booking-race-spike \
	perf-accounts-create perf-accounts-clean perf-accounts-status \
	perf-analyze \
	generate-dtos \
	_setup _teardown

VENV       = .venv
VENV_BIN   = $(VENV)/bin
REPORT_DIR = reports
TIMESTAMP  = $(shell date +%Y-%m-%d_%H-%M-%S)
LOCUST_STDOUT_LOG = $(REPORT_DIR)/locust_$(TIMESTAMP).stdout.log
TARGET_HOST ?= http://localhost:8080
PERF_TARGET_USERS ?= 1000
PERF_TARGET_SPAWN_RATE ?= 100
PERF_RUN_TIME ?= 300s
export TARGET_HOST PERF_TARGET_USERS

# ── Headless quick-run CCU config (override from CLI) ──────────────────────
# Example: make perf-headless PERF_CCU=100 PERF_SPAWN_RATE=20 PERF_RUN_TIME_HEADLESS=120s
PERF_CCU ?= 10
PERF_SPAWN_RATE ?= 2
PERF_RUN_TIME_HEADLESS ?= 60s
export PERF_CCU PERF_SPAWN_RATE PERF_RUN_TIME_HEADLESS

# ── Dedicated performance USER account pool ─────────────────────────────────
PERF_ACCOUNT_COUNT ?= 1200
PERF_ACCOUNT_SCRIPT = scripts/register_perf_accounts.js
PERF_ALL_MODULES_LOCUSTFILE = locustfiles/all_modules.py

# locust >=2.39 requires Python >=3.10; find a suitable interpreter.
PYTHON     = $(shell command -v python3.13 2>/dev/null \
               || command -v python3.12 2>/dev/null \
               || command -v python3.11 2>/dev/null \
               || command -v python3.10 2>/dev/null \
               || echo python3)

# ──────────────────────────────────────────────
# Internal lifecycle targets (not called directly)
# ──────────────────────────────────────────────

_setup:
	@echo "══════════════════════════════════════════"
	@echo "  Setting up test environment..."
	@echo "══════════════════════════════════════════"
	@echo "  Using Python: $(PYTHON)"
	@$(PYTHON) -c "import sys; v=sys.version_info; exit(0 if v>=(3,10) else 1)" \
		|| { echo "ERROR: Python >=3.10 is required (found $$($(PYTHON) --version))."; exit 1; }
	@$(PYTHON) -m venv $(VENV)
	@$(VENV_BIN)/pip install --quiet -r requirements.txt
	@mkdir -p $(REPORT_DIR)
	@echo "  Environment ready."
	@echo ""

_teardown:
	@echo ""
	@echo "══════════════════════════════════════════"
	@echo "  Tearing down test environment..."
	@echo "══════════════════════════════════════════"
	@rm -rf $(VENV)
	@echo "  Virtual environment removed."
	@echo "  Reports saved in $(REPORT_DIR)/"
	@echo "══════════════════════════════════════════"

# Helper: runs setup → locust with given args → teardown
# Traps SIGINT/SIGTERM/SIGHUP/EXIT so _teardown always runs,
# even on Ctrl+C, kill, or terminal close.
# Usage: $(call run_locust,<extra-args>)
define run_locust
	@$(MAKE) --no-print-directory _setup
	@echo "══════════════════════════════════════════"
	@echo "  Running tests..."
	@echo "══════════════════════════════════════════"
	@cleanup() { $(MAKE) --no-print-directory _teardown; }; \
	trap cleanup EXIT; \
	$(VENV_BIN)/locust --headless --only-summary --loglevel ERROR --host $(TARGET_HOST) $(1) \
		--html $(REPORT_DIR)/report_$(TIMESTAMP).html \
		> $(LOCUST_STDOUT_LOG); \
	exit $$?
endef

# Helper: create generated USER accounts → run Locust → delete generated USER accounts.
define run_locust_with_perf_accounts
	@$(MAKE) --no-print-directory _setup
	@echo "══════════════════════════════════════════"
	@echo "  Creating performance USER accounts..."
	@echo "══════════════════════════════════════════"
	@cleanup() { node $(PERF_ACCOUNT_SCRIPT) cleanup || true; $(MAKE) --no-print-directory _teardown; }; \
	trap cleanup EXIT; \
	node $(PERF_ACCOUNT_SCRIPT) reset --count $(PERF_ACCOUNT_COUNT); \
	echo ""; \
	echo "══════════════════════════════════════════"; \
	echo "  Running tests..."; \
	echo "══════════════════════════════════════════"; \
	set -a; . $(REPORT_DIR)/perf_user_pool.env; set +a; \
	$(VENV_BIN)/locust --headless --only-summary --loglevel ERROR --host $(TARGET_HOST) $(1) \
		--html $(REPORT_DIR)/report_$(TIMESTAMP).html \
		> $(LOCUST_STDOUT_LOG); \
	exit $$?
endef

# Helper: create generated USER pool + support admin/partner/employee accounts.
# Use this for the all-modules suite so every auth role has valid perf-only
# credentials without depending on stale seed passwords.
define run_locust_with_all_perf_accounts
	@$(MAKE) --no-print-directory _setup
	@echo "══════════════════════════════════════════"
	@echo "  Creating all-module performance accounts..."
	@echo "══════════════════════════════════════════"
	@cleanup() { node $(PERF_ACCOUNT_SCRIPT) cleanup --with-support-accounts || true; $(MAKE) --no-print-directory _teardown; }; \
	trap cleanup EXIT; \
	node $(PERF_ACCOUNT_SCRIPT) reset --count $(PERF_ACCOUNT_COUNT) --with-support-accounts; \
	echo ""; \
	echo "══════════════════════════════════════════"; \
	echo "  Running all test modules..."; \
	echo "══════════════════════════════════════════"; \
	set -a; . $(REPORT_DIR)/perf_user_pool.env; set +a; \
	$(VENV_BIN)/locust --headless --only-summary --loglevel ERROR --host $(TARGET_HOST) $(1) \
		--html $(REPORT_DIR)/report_$(TIMESTAMP).html \
		> $(LOCUST_STDOUT_LOG); \
	exit $$?
endef

# ──────────────────────────────────────────────
# Interactive UI mode (full lifecycle, no teardown — long-running)
# ──────────────────────────────────────────────

perf-ui:
	@$(MAKE) --no-print-directory _setup
	@echo "══════════════════════════════════════════"
	@echo "  Locust Web UI → http://localhost:8089"
	@echo "══════════════════════════════════════════"
	@cleanup() { $(MAKE) --no-print-directory _teardown; }; \
	trap cleanup EXIT; \
	$(VENV_BIN)/locust; \
	exit $$?

# ──────────────────────────────────────────────
# Headless generated-USER suite
# ──────────────────────────────────────────────

perf-headless: ## Run generated USER-account headless suite. Override: PERF_CCU=<n> PERF_SPAWN_RATE=<n> PERF_RUN_TIME_HEADLESS=<duration>
	@echo "  CCU=$(PERF_CCU)  spawn-rate=$(PERF_SPAWN_RATE)  run-time=$(PERF_RUN_TIME_HEADLESS)"
	$(call run_locust_with_perf_accounts,-f locustfiles/perf_headless_user.py -u $(PERF_CCU) -r $(PERF_SPAWN_RATE) --run-time $(PERF_RUN_TIME_HEADLESS))

perf-headless-all: ## Run every locustfiles module with generated perf-only credentials.
	@echo "  CCU=$(PERF_CCU)  spawn-rate=$(PERF_SPAWN_RATE)  run-time=$(PERF_RUN_TIME_HEADLESS)"
	$(call run_locust_with_all_perf_accounts,-f $(PERF_ALL_MODULES_LOCUSTFILE) -u $(PERF_CCU) -r $(PERF_SPAWN_RATE) --run-time $(PERF_RUN_TIME_HEADLESS))

perf-headless-full: perf-headless-all

perf-test-all-modules: perf-headless-all

# ──────────────────────────────────────────────
# HTTP API test runners
# ──────────────────────────────────────────────

perf-test-auth:
	$(call run_locust,--tags auth -u 10 -r 2 --run-time 60s)

perf-test-admin:
	$(call run_locust,--tags admin -u 10 -r 2 --run-time 60s)

perf-test-products:
	$(call run_locust,--tags products -u 10 -r 2 --run-time 60s)

perf-test-locations:
	$(call run_locust,--tags locations -u 10 -r 2 --run-time 60s)

# ──────────────────────────────────────────────
# Updated-module stress test runners
# ──────────────────────────────────────────────

perf-test-updated-stress:
	$(call run_locust,--tags updated -u 50 -r 10 --run-time 300s)

perf-test-partner-finance-stress:
	$(call run_locust,--tags partner-finance -u 50 -r 10 --run-time 300s)

perf-test-employee-analytics-stress:
	$(call run_locust,--tags employee-analytics -u 30 -r 6 --run-time 300s)

perf-test-updated-mutations:
	@test "$(PERF_ENABLE_MUTATIONS)" = "1" || { echo "ERROR: Set PERF_ENABLE_MUTATIONS=1 to run finance mutation tests."; exit 1; }
	$(call run_locust,--tags finance-mutation -u 2 -r 1 --run-time 60s)

# ──────────────────────────────────────────────
# Current/new API test runners
# ──────────────────────────────────────────────

perf-test-new-apis:
	$(call run_locust,--tags new-api -u 20 -r 4 --run-time 120s)

perf-test-current-new-apis:
	$(call run_locust,--tags current-new-api -u 20 -r 4 --run-time 120s)

perf-test-health:
	$(call run_locust,--tags health -u 10 -r 2 --run-time 60s)

perf-test-employee:
	$(call run_locust,--tags employee -u 20 -r 4 --run-time 120s)

perf-test-targets:
	$(call run_locust,--tags target -u $(PERF_TARGET_USERS) -r $(PERF_TARGET_SPAWN_RATE) --run-time $(PERF_RUN_TIME))

perf-test-employee-mutations:
	@test "$(PERF_ENABLE_EMPLOYEE_MUTATIONS)" = "1" || { echo "ERROR: Set PERF_ENABLE_EMPLOYEE_MUTATIONS=1 to run employee mutation tests."; exit 1; }
	$(call run_locust,--tags employee-mutation -u 2 -r 1 --run-time 60s)

# ──────────────────────────────────────────────
# Booking race condition test runners
# ──────────────────────────────────────────────

perf-test-booking-race:
	$(call run_locust,-f locustfiles/booking_race_condition.py -u 50 -r 10 --run-time 180s)

perf-test-booking-race-spike:
	$(call run_locust,-f locustfiles/booking_race_condition.py -u 200 -r 30 --run-time 180s)

# ──────────────────────────────────────────────
# Dedicated performance test accounts
# ──────────────────────────────────────────────

perf-accounts-create:
	node $(PERF_ACCOUNT_SCRIPT) create --count $(PERF_ACCOUNT_COUNT)

perf-accounts-clean:
	node $(PERF_ACCOUNT_SCRIPT) cleanup

perf-accounts-status:
	node $(PERF_ACCOUNT_SCRIPT) status

# ──────────────────────────────────────────────
# WebSocket test runners
# ──────────────────────────────────────────────

perf-test-ws:
	$(call run_locust,--tags ws -u 10 -r 2 --run-time 60s)

perf-test-chat:
	$(call run_locust,--tags chat -u 10 -r 2 --run-time 60s)

# ──────────────────────────────────────────────
# Report analysis
# ──────────────────────────────────────────────

NODE = $(shell for p in /opt/homebrew/bin/node /usr/local/bin/node \
        /Applications/Cursor.app/Contents/Resources/app/resources/helpers/node \
        /Applications/Codex.app/Contents/Resources/node; do \
        test -x "$$p" && echo "$$p" && break; done)

perf-analyze: ## Analyze all HTML reports and generate a consolidated trend report
	@echo "══════════════════════════════════════════"
	@echo "  Analyzing performance reports..."
	@echo "══════════════════════════════════════════"
	@$(NODE) scripts/analyze_reports.js --out $(REPORT_DIR)/analysis_report.html; \
	rc=$$?; \
	echo ""; \
	if [ $$rc -eq 0 ]; then echo "  ✅ All performance targets met!"; \
	else echo "  ⚠️  Some performance targets not met (see report)."; fi; \
	echo "  Report: $(REPORT_DIR)/analysis_report.html"; \
	echo "══════════════════════════════════════════"

# ──────────────────────────────────────────────
# DTO generation
# ──────────────────────────────────────────────

generate-dtos:
	@echo "══════════════════════════════════════════"
	@echo "  Generating OpenAPI DTOs..."
	@echo "══════════════════════════════════════════"
	@$(PYTHON) scripts/generate_dtos.py --input api_docs/openapi.json --output models
