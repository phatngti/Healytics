.PHONY: perf-ui perf-headless \
	perf-test-auth perf-test-admin perf-test-products \
	perf-test-locations perf-test-ws perf-test-chat \
	_setup _teardown

VENV       = .venv
VENV_BIN   = $(VENV)/bin
REPORT_DIR = reports
TIMESTAMP  = $(shell date +%Y-%m-%d_%H-%M-%S)

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
# Usage: $(call run_locust,<extra-args>)
define run_locust
	@$(MAKE) --no-print-directory _setup
	@echo "══════════════════════════════════════════"
	@echo "  Running tests..."
	@echo "══════════════════════════════════════════"
	$(VENV_BIN)/locust --headless $(1) \
		--html $(REPORT_DIR)/report_$(TIMESTAMP).html; \
	status=$$?; \
	$(MAKE) --no-print-directory _teardown; \
	exit $$status
endef

# ──────────────────────────────────────────────
# Interactive UI mode (full lifecycle, no teardown — long-running)
# ──────────────────────────────────────────────

perf-ui:
	@$(MAKE) --no-print-directory _setup
	@echo "══════════════════════════════════════════"
	@echo "  Locust Web UI → http://localhost:8089"
	@echo "══════════════════════════════════════════"
	$(VENV_BIN)/locust; \
	status=$$?; \
	$(MAKE) --no-print-directory _teardown; \
	exit $$status

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
# WebSocket test runners
# ──────────────────────────────────────────────

perf-test-ws:
	$(call run_locust,--tags ws -u 10 -r 2 --run-time 60s)

perf-test-chat:
	$(call run_locust,--tags chat -u 10 -r 2 --run-time 60s)
