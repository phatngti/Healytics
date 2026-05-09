.PHONY: perf-ui perf-headless \
	perf-test-auth perf-test-admin perf-test-products \
	perf-test-locations perf-test-ws perf-test-chat \
	perf-test-updated-stress perf-test-partner-finance-stress \
	perf-test-employee-analytics-stress perf-test-updated-mutations \
	perf-test-new-apis perf-test-health perf-test-employee \
	perf-test-targets perf-test-employee-mutations \
	perf-test-booking-race perf-test-booking-race-spike \
	generate-dtos \
	_setup _teardown

VENV       = .venv
VENV_BIN   = $(VENV)/bin
REPORT_DIR = reports
TIMESTAMP  = $(shell date +%Y-%m-%d_%H-%M-%S)
LOCUST_STDOUT_LOG = $(REPORT_DIR)/locust_$(TIMESTAMP).stdout.log
PERF_TARGET_USERS ?= 1000
PERF_TARGET_SPAWN_RATE ?= 100
PERF_RUN_TIME ?= 300s
export PERF_TARGET_USERS

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
	$(VENV_BIN)/locust --headless --only-summary --loglevel ERROR $(1) \
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
# Headless full suite
# ──────────────────────────────────────────────

perf-headless:
	$(call run_locust,-u 10 -r 2 --run-time 60s)

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
# WebSocket test runners
# ──────────────────────────────────────────────

perf-test-ws:
	$(call run_locust,--tags ws -u 10 -r 2 --run-time 60s)

perf-test-chat:
	$(call run_locust,--tags chat -u 10 -r 2 --run-time 60s)

# ──────────────────────────────────────────────
# DTO generation
# ──────────────────────────────────────────────

generate-dtos:
	@echo "══════════════════════════════════════════"
	@echo "  Generating OpenAPI DTOs..."
	@echo "══════════════════════════════════════════"
	@$(PYTHON) scripts/generate_dtos.py --input api_docs/openapi.json --output models
