.DEFAULT_GOAL := help

.PHONY: help perf-test perf-test-docker perf-test-external perf-ui \
	perf-headless perf-headless-all perf-headless-full perf-test-all-modules \
	perf-headless-important \
	perf-stress-important perf-stress-small perf-stress-medium perf-stress-large perf-stress-all perf-stress-flow \
	perf-stress-swarm-lifecycle perf-docker-swarm-test \
	perf-swarm-apply perf-swarm-inspect perf-swarm-config perf-swarm-start perf-swarm-stop \
	perf-compose-config perf-compose-account-env perf-compose-start perf-compose-build-backend \
	perf-compose-build perf-compose-infra-up perf-compose-migrate \
	perf-compose-seed perf-compose-start-backend perf-compose-up \
	perf-compose-evaluate-report perf-compose-down perf-compose-kill-services \
	perf-compose-reset perf-compose-logs perf-compose-test \
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
HARDWARE_CONFIG_REPORT = $(REPORT_DIR)/hardware_config.json
TARGET_HOST ?= http://localhost:8080
LOCUST_WEB_HOST ?= 0.0.0.0
LOCUST_WEB_PORT ?= 8089
LOCUST_WEB_URL_HOST ?= localhost
LOCUST_WEB_URL = http://$(LOCUST_WEB_URL_HOST):$(LOCUST_WEB_PORT)
PERF_OPEN_BROWSER ?= 1
PERF_TEST_WEB_UI ?= 1
PERF_WEB_UI ?= 0
PERF_WEB_UI_AUTOQUIT ?= 5
PERF_TARGET_USERS ?= 1000
PERF_TARGET_SPAWN_RATE ?= 100
PERF_RUN_TIME ?= 300s
export TARGET_HOST PERF_TARGET_USERS

# Main entrypoint selector:
#   make perf-test                         -> dedicated Docker Compose backend
#   make perf-test PERF_BACKEND=external   -> externally managed backend
PERF_BACKEND ?= docker

# ── Headless quick-run CCU config (override from CLI) ──────────────────────
# Example: make perf-headless PERF_CCU=100 PERF_SPAWN_RATE=20 PERF_RUN_TIME_HEADLESS=120s
PERF_CCU ?= 10
PERF_SPAWN_RATE ?= 2
PERF_RUN_TIME_HEADLESS ?= 60s
export PERF_CCU PERF_SPAWN_RATE PERF_RUN_TIME_HEADLESS

# ── Performance-only Swarm backend stress-flow config ───────────────────────
PERF_SWARM_DIR ?= docker_swarm
PERF_SWARM_ENV ?= $(PERF_SWARM_DIR)/env/swarm.env
PERF_SWARM_ENV_EXAMPLE ?= $(PERF_SWARM_DIR)/env/swarm.env.example
PERF_SWARM_STACK ?= $(PERF_SWARM_DIR)/stack/healytics.performance.yml
PERF_SWARM_BASE_STACK ?= /Volumes/WD850X/Users/workspace/datn/docker_swarm/stack/healytics.apps.yml
BACKEND_AUTOSCALER_SCRIPT ?= $(PERF_SWARM_DIR)/scripts/swarm-backend-autoscale.sh
BACKEND_AUTOSCALER_LOG ?= $(REPORT_DIR)/backend_autoscaler.log
BACKEND_AUTOSCALER_PID_FILE ?= $(REPORT_DIR)/backend_autoscaler.pid
PERF_STRESS_PROFILE ?= important
PERF_APPLY_SWARM_PROFILE ?= 1
PERF_START_AUTOSCALER ?= 1
PERF_VERIFY_SWARM_LIMITS ?= 1
PERF_SWARM_INIT_ARGS ?=
PERF_SWARM_DEPLOY_STACK ?= 0
PERF_FORCE_SWARM_TEARDOWN ?= 0
PERF_KILL_BACKEND_CONTAINERS ?= 1

# ── Performance-only Docker Compose backend stack ───────────────────────────
PERF_COMPOSE_FILE ?= $(PERF_SWARM_DIR)/docker-compose.yml
PERF_COMPOSE_ENV ?= $(PERF_SWARM_DIR)/compose.env
PERF_COMPOSE_ENV_EXAMPLE ?= $(PERF_SWARM_DIR)/compose.env.example
PERF_COMPOSE_ENV_FILE = $(if $(wildcard $(PERF_COMPOSE_ENV)),$(PERF_COMPOSE_ENV),$(PERF_COMPOSE_ENV_EXAMPLE))
PERF_BACKEND_ENV ?= $(PERF_SWARM_DIR)/backend.env
PERF_BACKEND_ENV_EXAMPLE ?= $(PERF_SWARM_DIR)/backend.env.example
PERF_BACKEND_ENV_FILE = $(if $(wildcard $(PERF_BACKEND_ENV)),$(PERF_BACKEND_ENV),$(PERF_BACKEND_ENV_EXAMPLE))
PERF_COMPOSE_ACCOUNT_ENV_FILE ?= $(REPORT_DIR)/perf_compose_account.env
PERF_COMPOSE = docker compose --env-file $(PERF_COMPOSE_ENV_FILE) -f $(PERF_COMPOSE_FILE)
PERF_BACKEND_PORT ?= 8080
PERF_COMPOSE_TARGET_HOST ?= http://localhost:$(PERF_BACKEND_PORT)
PERF_COMPOSE_RUN_MIGRATIONS ?= 1
PERF_COMPOSE_RUN_SEED ?= 1
PERF_COMPOSE_EVALUATE_REPORT ?= 1
PERF_COMPOSE_DOWN_VOLUMES ?= 0
PERF_EXTERNAL_TARGET_HOST ?= $(TARGET_HOST)
PERF_EXTERNAL_ACCOUNT_ENV_FILE ?= $(PERF_ACCOUNT_ENV_FILE)
PERF_EXTERNAL_HEALTHCHECK ?= 1
PERF_EXTERNAL_EVALUATE_REPORT ?= 1

# ── Dedicated performance USER account pool ─────────────────────────────────
PERF_ACCOUNT_COUNT ?= 1200
PERF_ACCOUNT_SCRIPT = scripts/register_perf_accounts.js
PERF_ACCOUNT_ENV_FILE ?=
PERF_ACCOUNT_ENV_ARG = $(if $(strip $(PERF_ACCOUNT_ENV_FILE)),--env-file $(PERF_ACCOUNT_ENV_FILE),)
PERF_IMPORTANT_LOCUSTFILE = locustfiles/important.py
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

help: ## Show the reduced performance-test command surface.
	@echo "Healytics backend performance harness"
	@echo ""
	@echo "Main commands:"
	@echo "  make perf-test                         Run full flow with dedicated Docker backend/services"
	@echo "  make perf-test-docker                  Same as perf-test with PERF_BACKEND=docker"
	@echo "  make perf-test-external TARGET_HOST=... Run against an externally managed backend"
	@echo "  make perf-ui TARGET_HOST=...           Run Locust with live web UI and open/print the URL"
	@echo ""
	@echo "Common options:"
	@echo "  PERF_STRESS_PROFILE=important|small|medium|large|all  Default: $(PERF_STRESS_PROFILE)"
	@echo "  PERF_CCU=<n> PERF_SPAWN_RATE=<n> PERF_RUN_TIME_HEADLESS=<duration>"
	@echo "  PERF_ACCOUNT_COUNT=<n>                  Default: $(PERF_ACCOUNT_COUNT)"
	@echo "  PERF_TEST_WEB_UI=0                      Disable live Locust UI for perf-test-* runs"
	@echo "  PERF_WEB_UI=1                           Enable live UI for lower-level stress/headless targets"
	@echo "  PERF_OPEN_BROWSER=0                     Print the Locust URL without opening a browser"
	@echo "  LOCUST_WEB_PORT=<port>                  Default: $(LOCUST_WEB_PORT)"
	@echo ""
	@echo "External backend options:"
	@echo "  TARGET_HOST=https://host/backend"
	@echo "  PERF_EXTERNAL_ACCOUNT_ENV_FILE=/path/to/db.env"
	@echo "  PERF_EXTERNAL_HEALTHCHECK=0             Skip /health reachability check"
	@echo ""
	@echo "Debug helpers remain available: perf-compose-up, perf-compose-down, perf-compose-logs,"
	@echo "perf-headless, perf-headless-all, perf-analyze, perf-accounts-create, perf-accounts-clean."

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
	$(call run_locust_command,$(1)); \
	exit $$?
endef

define announce_locust_web_ui
	echo "══════════════════════════════════════════"; \
	echo "  Locust Web UI: $(LOCUST_WEB_URL)"; \
	echo "  Target host:   $(TARGET_HOST)"; \
	echo "══════════════════════════════════════════"; \
	locust_url="$(LOCUST_WEB_URL)"; \
	if [ "$(PERF_OPEN_BROWSER)" = "1" ]; then \
		if command -v open >/dev/null 2>&1; then ( sleep 2; open "$$locust_url" ) >/dev/null 2>&1 & \
		elif command -v xdg-open >/dev/null 2>&1; then ( sleep 2; xdg-open "$$locust_url" ) >/dev/null 2>&1 & \
		else echo "Browser auto-open skipped; open $$locust_url manually."; fi; \
	else \
		echo "Browser auto-open disabled; open $$locust_url manually."; \
	fi
endef

define run_locust_command
	mkdir -p $(REPORT_DIR); \
	$(NODE) scripts/hardware_config.js --out $(HARDWARE_CONFIG_REPORT) --print; \
	if [ "$(PERF_WEB_UI)" = "1" ]; then \
		$(call announce_locust_web_ui); \
		$(VENV_BIN)/locust --loglevel ERROR --host "$(TARGET_HOST)" $(1) \
			--web-host "$(LOCUST_WEB_HOST)" --web-port "$(LOCUST_WEB_PORT)" \
			--autostart --autoquit "$(PERF_WEB_UI_AUTOQUIT)" \
			--html $(REPORT_DIR)/report_$(TIMESTAMP).html; \
	else \
		$(VENV_BIN)/locust --headless --only-summary --loglevel ERROR --host "$(TARGET_HOST)" $(1) \
			--html $(REPORT_DIR)/report_$(TIMESTAMP).html \
			> $(LOCUST_STDOUT_LOG); \
	fi
endef

# Helper: create generated USER accounts → run Locust → delete generated USER accounts.
define run_locust_with_perf_accounts
	@$(MAKE) --no-print-directory _setup
	@echo "══════════════════════════════════════════"
	@echo "  Creating performance USER accounts..."
	@echo "══════════════════════════════════════════"
	@cleanup() { node $(PERF_ACCOUNT_SCRIPT) cleanup $(PERF_ACCOUNT_ENV_ARG) || true; $(MAKE) --no-print-directory _teardown; }; \
	trap cleanup EXIT; \
	set -e; \
	node $(PERF_ACCOUNT_SCRIPT) reset --count $(PERF_ACCOUNT_COUNT) $(PERF_ACCOUNT_ENV_ARG); \
	echo ""; \
	echo "══════════════════════════════════════════"; \
	echo "  Running tests..."; \
	echo "══════════════════════════════════════════"; \
	set -a; . $(REPORT_DIR)/perf_user_pool.env; set +a; \
	$(call run_locust_command,$(1)); \
	exit $$?
endef

# Helper: create generated USER pool + support admin/partner/employee accounts.
# Use this for suites that need every auth role to have valid perf-only
# credentials without depending on stale seed passwords.
define run_locust_with_all_perf_accounts
	@$(MAKE) --no-print-directory _setup
	@echo "══════════════════════════════════════════"
	@echo "  Creating support-role performance accounts..."
	@echo "══════════════════════════════════════════"
	@cleanup() { node $(PERF_ACCOUNT_SCRIPT) cleanup --with-support-accounts $(PERF_ACCOUNT_ENV_ARG) || true; $(MAKE) --no-print-directory _teardown; }; \
	trap cleanup EXIT; \
	set -e; \
	node $(PERF_ACCOUNT_SCRIPT) reset --count $(PERF_ACCOUNT_COUNT) --with-support-accounts $(PERF_ACCOUNT_ENV_ARG); \
	echo ""; \
	echo "══════════════════════════════════════════"; \
	echo "  Running selected test modules..."; \
	echo "══════════════════════════════════════════"; \
	set -a; . $(REPORT_DIR)/perf_user_pool.env; set +a; \
	$(call run_locust_command,$(1)); \
	exit $$?
endef

# ──────────────────────────────────────────────
# Interactive UI mode (full lifecycle, no teardown — long-running)
# ──────────────────────────────────────────────

perf-ui:
	@$(MAKE) --no-print-directory _setup
	@echo "══════════════════════════════════════════"
	@echo "  Locust Web UI: $(LOCUST_WEB_URL)"
	@echo "  Target host:   $(TARGET_HOST)"
	@echo "══════════════════════════════════════════"
	@cleanup() { $(MAKE) --no-print-directory _teardown; }; \
	trap cleanup EXIT; \
	mkdir -p $(REPORT_DIR); \
	$(NODE) scripts/hardware_config.js --out $(HARDWARE_CONFIG_REPORT) --print; \
	locust_url="$(LOCUST_WEB_URL)"; \
	if [ "$(PERF_OPEN_BROWSER)" = "1" ]; then \
		if command -v open >/dev/null 2>&1; then ( sleep 2; open "$$locust_url" ) >/dev/null 2>&1 & \
		elif command -v xdg-open >/dev/null 2>&1; then ( sleep 2; xdg-open "$$locust_url" ) >/dev/null 2>&1 & \
		else echo "Browser auto-open skipped; open $$locust_url manually."; fi; \
	else \
		echo "Browser auto-open disabled; open $$locust_url manually."; \
	fi; \
	$(VENV_BIN)/locust --host "$(TARGET_HOST)" --web-host "$(LOCUST_WEB_HOST)" --web-port "$(LOCUST_WEB_PORT)"; \
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

perf-headless-important: ## Run curated important API cases with generated perf-only credentials.
	@echo "  CCU=$(PERF_CCU)  spawn-rate=$(PERF_SPAWN_RATE)  run-time=$(PERF_RUN_TIME_HEADLESS)"
	$(call run_locust_with_all_perf_accounts,-f $(PERF_IMPORTANT_LOCUSTFILE) -u $(PERF_CCU) -r $(PERF_SPAWN_RATE) --run-time $(PERF_RUN_TIME_HEADLESS))

# ──────────────────────────────────────────────
# Reduced top-level flows
# ──────────────────────────────────────────────

perf-test: ## Run the selected full performance flow. PERF_BACKEND=docker|external.
	@case "$(PERF_BACKEND)" in \
		docker|compose) $(MAKE) --no-print-directory perf-test-docker ;; \
		external) $(MAKE) --no-print-directory perf-test-external ;; \
		*) echo "ERROR: PERF_BACKEND must be docker or external."; exit 2 ;; \
	esac

perf-test-docker: perf-compose-test ## Full flow with dedicated Docker Compose backend/services.

perf-test-external: ## Run selected stress profile against an externally managed backend.
	@case "$(PERF_STRESS_PROFILE)" in important|small|medium|large|all) ;; *) echo "ERROR: PERF_STRESS_PROFILE must be one of: important, small, medium, large, all."; exit 2 ;; esac; \
	target="$(PERF_EXTERNAL_TARGET_HOST)"; \
	if [ -z "$$target" ]; then echo "ERROR: TARGET_HOST or PERF_EXTERNAL_TARGET_HOST is required."; exit 2; fi; \
	if [ "$(PERF_EXTERNAL_HEALTHCHECK)" = "1" ]; then \
		health_url="$${target%/}/health"; \
		echo "Checking external backend: $$health_url"; \
		curl -fsS "$$health_url" >/dev/null || { echo "ERROR: external backend health check failed: $$health_url"; exit 2; }; \
	fi; \
	run_rc=0; analyze_rc=0; \
	echo "══════════════════════════════════════════"; \
	echo "  Running external backend stress profile: $(PERF_STRESS_PROFILE)"; \
	echo "  Target: $$target"; \
	echo "══════════════════════════════════════════"; \
	$(MAKE) --no-print-directory perf-stress-$(PERF_STRESS_PROFILE) TARGET_HOST="$$target" PERF_ACCOUNT_ENV_FILE="$(PERF_EXTERNAL_ACCOUNT_ENV_FILE)" PERF_WEB_UI="$(PERF_TEST_WEB_UI)" || run_rc="$$?"; \
	if [ "$$run_rc" = "0" ] && [ "$(PERF_EXTERNAL_EVALUATE_REPORT)" = "1" ]; then \
		echo "══════════════════════════════════════════"; \
		echo "  Evaluating performance report"; \
		echo "══════════════════════════════════════════"; \
		$(MAKE) --no-print-directory perf-analyze || analyze_rc="$$?"; \
	fi; \
	if [ "$$run_rc" != "0" ]; then exit "$$run_rc"; fi; \
	exit "$$analyze_rc"

# ──────────────────────────────────────────────
# Swarm-backed stress flow
# ──────────────────────────────────────────────

stress_args = PERF_CCU=$(if $(filter command line,$(origin PERF_CCU)),$(PERF_CCU),$(1)) PERF_SPAWN_RATE=$(if $(filter command line,$(origin PERF_SPAWN_RATE)),$(PERF_SPAWN_RATE),$(2)) PERF_RUN_TIME_HEADLESS=$(if $(filter command line,$(origin PERF_RUN_TIME_HEADLESS)),$(PERF_RUN_TIME_HEADLESS),$(3))

perf-stress-important: ## Run the default important API cases, not the full module suite.
	@$(MAKE) --no-print-directory perf-headless-important $(call stress_args,100,20,180s) PERF_ACCOUNT_ENV_FILE="$(PERF_ACCOUNT_ENV_FILE)"

perf-stress-small: ## Run generated USER stress suite for the small profile.
	@$(MAKE) --no-print-directory perf-headless $(call stress_args,100,20,180s) PERF_ACCOUNT_ENV_FILE="$(PERF_ACCOUNT_ENV_FILE)"

perf-stress-medium: ## Run generated USER stress suite for the medium profile.
	@$(MAKE) --no-print-directory perf-headless $(call stress_args,500,50,300s) PERF_ACCOUNT_ENV_FILE="$(PERF_ACCOUNT_ENV_FILE)"

perf-stress-large: ## Run generated USER stress suite for the large profile.
	@$(MAKE) --no-print-directory perf-headless $(call stress_args,1000,100,300s) PERF_ACCOUNT_ENV_FILE="$(PERF_ACCOUNT_ENV_FILE)"

perf-stress-all: ## Run every active Locust module with generated perf-only credentials.
	@$(MAKE) --no-print-directory perf-headless-all $(call stress_args,100,20,180s) PERF_ACCOUNT_ENV_FILE="$(PERF_ACCOUNT_ENV_FILE)"

perf-swarm-apply: ## Apply performance-only backend CPU/RAM limits to the existing Swarm service.
	@if [ -f "$(PERF_SWARM_ENV)" ]; then set -a; . "$(PERF_SWARM_ENV)"; set +a; \
	elif [ -f "$(PERF_SWARM_ENV_EXAMPLE)" ]; then set -a; . "$(PERF_SWARM_ENV_EXAMPLE)"; set +a; fi; \
	service="$${STACK_NAME:-healytics}_backend"; \
	cpus="$${BACKEND_LIMIT_CPUS:-2.0}"; \
	memory="$${BACKEND_LIMIT_MEMORY:-4G}"; \
	echo "══════════════════════════════════════════"; \
	echo "  Applying performance backend limits"; \
	echo "  Service: $$service"; \
	echo "  CPU:     $$cpus"; \
	echo "  Memory:  $$memory"; \
	echo "══════════════════════════════════════════"; \
	docker service update --limit-cpu "$$cpus" --limit-memory "$$memory" "$$service"

perf-swarm-inspect: ## Inspect active backend Swarm resource limits.
	@if [ -f "$(PERF_SWARM_ENV)" ]; then set -a; . "$(PERF_SWARM_ENV)"; set +a; \
	elif [ -f "$(PERF_SWARM_ENV_EXAMPLE)" ]; then set -a; . "$(PERF_SWARM_ENV_EXAMPLE)"; set +a; fi; \
	service="$${STACK_NAME:-healytics}_backend"; \
	echo "══════════════════════════════════════════"; \
	echo "  Inspecting Swarm backend resources: $$service"; \
	echo "══════════════════════════════════════════"; \
	docker service inspect "$$service" --format '{{json .Spec.TaskTemplate.Resources}}'

perf-swarm-config: ## Render the base Swarm app stack with the local performance resource override.
	@if [ -f "$(PERF_SWARM_ENV)" ]; then set -a; . "$(PERF_SWARM_ENV)"; set +a; \
	elif [ -f "$(PERF_SWARM_ENV_EXAMPLE)" ]; then set -a; . "$(PERF_SWARM_ENV_EXAMPLE)"; set +a; fi; \
	docker stack config -c "$${PERF_SWARM_BASE_STACK:-$(PERF_SWARM_BASE_STACK)}" -c "$(PERF_SWARM_STACK)"

perf-swarm-start: ## Ensure Docker Swarm mode is active for performance testing.
	@state="$$(docker info --format '{{.Swarm.LocalNodeState}}' 2>/dev/null || true)"; \
	control="$$(docker info --format '{{.Swarm.ControlAvailable}}' 2>/dev/null || true)"; \
	if [ "$$state" = "active" ] && [ "$$control" = "true" ]; then \
		echo "Docker Swarm is already active on this manager."; \
	else \
		echo "Starting Docker Swarm for performance testing..."; \
		docker swarm init $(PERF_SWARM_INIT_ARGS); \
	fi

perf-swarm-stop: ## Force this Docker engine to leave Swarm mode.
	@echo "Stopping Docker Swarm on this engine..."
	@docker swarm leave --force

perf-stress-flow: ## Start backend autoscaler, run selected stress profile, then stop autoscaler.
	@mkdir -p $(REPORT_DIR)
	@case "$(PERF_STRESS_PROFILE)" in important|small|medium|large|all) ;; *) echo "ERROR: PERF_STRESS_PROFILE must be one of: important, small, medium, large, all."; exit 2 ;; esac
	@if [ "$(PERF_APPLY_SWARM_PROFILE)" = "1" ]; then make --no-print-directory perf-swarm-apply; fi
	@if [ "$(PERF_VERIFY_SWARM_LIMITS)" = "1" ]; then make --no-print-directory perf-swarm-inspect; fi
	@autoscaler_pid=""; \
	if [ "$(PERF_START_AUTOSCALER)" = "1" ]; then \
		test -x "$(BACKEND_AUTOSCALER_SCRIPT)" || { echo "ERROR: backend autoscaler script is not executable: $(BACKEND_AUTOSCALER_SCRIPT)"; exit 2; }; \
		echo "══════════════════════════════════════════"; \
		echo "  Starting backend autoscaler"; \
		echo "  Log: $(BACKEND_AUTOSCALER_LOG)"; \
		echo "══════════════════════════════════════════"; \
		PERF_SWARM_ENV="$(PERF_SWARM_ENV)" "$(BACKEND_AUTOSCALER_SCRIPT)" > "$(BACKEND_AUTOSCALER_LOG)" 2>&1 & \
		autoscaler_pid="$$!"; \
		echo "$$autoscaler_pid" > "$(BACKEND_AUTOSCALER_PID_FILE)"; \
	fi; \
	cleanup() { \
		if [ -n "$$autoscaler_pid" ] && kill -0 "$$autoscaler_pid" 2>/dev/null; then \
			echo "Stopping backend autoscaler ($$autoscaler_pid)..."; \
			kill "$$autoscaler_pid" 2>/dev/null || true; \
			wait "$$autoscaler_pid" 2>/dev/null || true; \
		fi; \
		rm -f "$(BACKEND_AUTOSCALER_PID_FILE)"; \
	}; \
	trap cleanup EXIT INT TERM HUP; \
	make --no-print-directory perf-stress-$(PERF_STRESS_PROFILE); \
	rc="$$?"; \
	cleanup; \
	exit "$$rc"

perf-stress-swarm-lifecycle: ## Start Swarm, run stress flow, kill backend task containers, and stop Swarm if this target started it.
	@mkdir -p $(REPORT_DIR)
	@swarm_was_active=0; stack_deployed_by_target=0; cleanup_done=0; \
	state="$$(docker info --format '{{.Swarm.LocalNodeState}}' 2>/dev/null || true)"; \
	control="$$(docker info --format '{{.Swarm.ControlAvailable}}' 2>/dev/null || true)"; \
	if [ "$$state" = "active" ] && [ "$$control" = "true" ]; then \
		swarm_was_active=1; \
		echo "Docker Swarm already active; this target will not leave Swarm unless PERF_FORCE_SWARM_TEARDOWN=1."; \
	else \
		echo "Starting Docker Swarm for performance testing..."; \
		docker swarm init $(PERF_SWARM_INIT_ARGS); \
	fi; \
	if [ "$(PERF_SWARM_DEPLOY_STACK)" = "1" ]; then \
		if [ -f "$(PERF_SWARM_ENV)" ]; then set -a; . "$(PERF_SWARM_ENV)"; set +a; \
		elif [ -f "$(PERF_SWARM_ENV_EXAMPLE)" ]; then set -a; . "$(PERF_SWARM_ENV_EXAMPLE)"; set +a; fi; \
		stack="$${STACK_NAME:-healytics}"; \
		base_stack="$${PERF_SWARM_BASE_STACK:-$(PERF_SWARM_BASE_STACK)}"; \
		echo "Deploying performance Swarm stack $$stack..."; \
		docker stack deploy -c "$$base_stack" -c "$(PERF_SWARM_STACK)" "$$stack"; \
		stack_deployed_by_target=1; \
	fi; \
	cleanup() { \
		if [ "$$cleanup_done" = "1" ]; then return 0; fi; \
		cleanup_done=1; \
		if [ -f "$(PERF_SWARM_ENV)" ]; then set -a; . "$(PERF_SWARM_ENV)"; set +a; \
		elif [ -f "$(PERF_SWARM_ENV_EXAMPLE)" ]; then set -a; . "$(PERF_SWARM_ENV_EXAMPLE)"; set +a; fi; \
		service="$${STACK_NAME:-healytics}_backend"; \
		if [ "$(PERF_KILL_BACKEND_CONTAINERS)" = "1" ] && { [ "$$swarm_was_active" = "0" ] || [ "$(PERF_FORCE_SWARM_TEARDOWN)" = "1" ]; }; then \
			echo "Killing running backend task containers for $$service..."; \
			containers="$$(docker ps --filter "label=com.docker.swarm.service.name=$$service" --filter "status=running" --format '{{.ID}}' 2>/dev/null || true)"; \
			if [ -n "$$containers" ]; then docker kill $$containers >/dev/null 2>&1 || true; else echo "No running backend task containers found."; fi; \
		elif [ "$(PERF_KILL_BACKEND_CONTAINERS)" = "1" ]; then \
			echo "Skipping backend container kill because Swarm was already active. Set PERF_FORCE_SWARM_TEARDOWN=1 to force cleanup."; \
		fi; \
		if [ "$$stack_deployed_by_target" = "1" ] && { [ "$$swarm_was_active" = "0" ] || [ "$(PERF_FORCE_SWARM_TEARDOWN)" = "1" ]; }; then \
			echo "Removing performance Swarm stack $${STACK_NAME:-healytics}..."; \
			docker stack rm "$${STACK_NAME:-healytics}" >/dev/null 2>&1 || true; \
			sleep 5; \
		fi; \
		if [ "$$swarm_was_active" = "0" ] || [ "$(PERF_FORCE_SWARM_TEARDOWN)" = "1" ]; then \
			echo "Stopping Docker Swarm on this engine..."; \
			docker swarm leave --force >/dev/null 2>&1 || true; \
		else \
			echo "Leaving existing Docker Swarm active."; \
		fi; \
	}; \
	trap cleanup EXIT INT TERM HUP; \
	make --no-print-directory perf-stress-flow; \
	rc="$$?"; \
	cleanup; \
	exit "$$rc"

perf-docker-swarm-test: perf-stress-swarm-lifecycle

# ──────────────────────────────────────────────
# Dedicated Docker Compose performance stack
# ──────────────────────────────────────────────

perf-compose-config: ## Render the dedicated performance Docker Compose stack.
	$(PERF_COMPOSE) config

perf-compose-account-env: ## Generate host-side Postgres env for the perf account script.
	@mkdir -p $(REPORT_DIR)
	@if [ -f "$(PERF_COMPOSE_ENV_FILE)" ]; then set -a; . "$(PERF_COMPOSE_ENV_FILE)"; set +a; fi; \
	if [ -f "$(PERF_BACKEND_ENV_FILE)" ]; then set -a; . "$(PERF_BACKEND_ENV_FILE)"; set +a; fi; \
	{ \
		echo "POSTGRES_HOST=127.0.0.1"; \
		echo "POSTGRES_PORT=$${PERF_POSTGRES_PORT:-55432}"; \
		echo "POSTGRES_USER=$${POSTGRES_USER:-admin}"; \
		echo "POSTGRES_PASSWORD=$${POSTGRES_PASSWORD:-admin@123}"; \
		echo "POSTGRES_DB=$${POSTGRES_DB:-healytics_perf}"; \
		echo "PERF_ACCOUNT_PASSWORD=$${PERF_ACCOUNT_PASSWORD:-Perf@12345}"; \
	} > "$(PERF_COMPOSE_ACCOUNT_ENV_FILE)"
	@chmod 600 "$(PERF_COMPOSE_ACCOUNT_ENV_FILE)"
	@echo "Generated $(PERF_COMPOSE_ACCOUNT_ENV_FILE)"

perf-compose-start: ## Start dedicated Compose dependency services for performance testing.
	$(PERF_COMPOSE) up -d postgres redis rabbitmq elasticsearch

perf-compose-build-backend: ## Build backend and migration images for the performance Compose stack.
	$(PERF_COMPOSE) build backend backend-migrate

perf-compose-build: perf-compose-build-backend

perf-compose-infra-up: ## Start dedicated Postgres, Redis, RabbitMQ, and Elasticsearch for performance testing.
	$(PERF_COMPOSE) up -d postgres redis rabbitmq elasticsearch

perf-compose-migrate: ## Run backend migrations against the dedicated performance database.
	$(PERF_COMPOSE) --profile jobs run --rm backend-migrate

perf-compose-seed: ## Seed the dedicated performance database.
	$(PERF_COMPOSE) --profile jobs run --rm backend-seed

perf-compose-start-backend: ## Start backend service using the performance backend.env file.
	@if [ "$(PERF_COMPOSE_RUN_MIGRATIONS)" = "1" ]; then make --no-print-directory perf-compose-migrate; fi
	@if [ "$(PERF_COMPOSE_RUN_SEED)" = "1" ]; then make --no-print-directory perf-compose-seed; fi
	$(PERF_COMPOSE) up -d backend
	$(PERF_COMPOSE) ps

perf-compose-up: ## Start dedicated performance infrastructure and backend.
	@make --no-print-directory perf-compose-start
	@make --no-print-directory perf-compose-build-backend
	@make --no-print-directory perf-compose-start-backend

perf-compose-evaluate-report: ## Evaluate Locust reports after a Compose-backed stress run.
	make --no-print-directory perf-analyze

perf-compose-down: ## Stop dedicated performance containers.
	@if [ "$(PERF_COMPOSE_DOWN_VOLUMES)" = "1" ]; then \
		$(PERF_COMPOSE) down --remove-orphans --volumes; \
	else \
		$(PERF_COMPOSE) down --remove-orphans; \
	fi

perf-compose-kill-services: perf-compose-down

perf-compose-reset: ## Stop dedicated performance containers and delete their volumes.
	make --no-print-directory perf-compose-down PERF_COMPOSE_DOWN_VOLUMES=1

perf-compose-logs: ## Follow dedicated backend performance stack logs.
	$(PERF_COMPOSE) logs -f --tail=200 backend postgres redis rabbitmq elasticsearch

perf-compose-test: ## Start dedicated Compose stack, run Locust, then stop containers.
	@case "$(PERF_STRESS_PROFILE)" in important|small|medium|large|all) ;; *) echo "ERROR: PERF_STRESS_PROFILE must be one of: important, small, medium, large, all."; exit 2 ;; esac; \
	set -e; \
	run_rc=0; analyze_rc=0; cleanup_done=0; \
	cleanup() { \
		if [ "$$cleanup_done" = "1" ]; then return 0; fi; \
		cleanup_done=1; \
		$(MAKE) --no-print-directory perf-compose-kill-services; \
	}; \
	trap cleanup EXIT INT TERM HUP; \
	echo "══════════════════════════════════════════"; \
	echo "  Starting dedicated Compose services"; \
	echo "══════════════════════════════════════════"; \
	make --no-print-directory perf-compose-start || exit "$$?"; \
	echo "══════════════════════════════════════════"; \
	echo "  Building backend images"; \
	echo "══════════════════════════════════════════"; \
	make --no-print-directory perf-compose-build-backend || exit "$$?"; \
	echo "══════════════════════════════════════════"; \
	echo "  Starting backend service with backend.env"; \
	echo "══════════════════════════════════════════"; \
	make --no-print-directory perf-compose-start-backend || exit "$$?"; \
	make --no-print-directory perf-compose-account-env || exit "$$?"; \
	echo "══════════════════════════════════════════"; \
	echo "  Running Locust stress profile: $(PERF_STRESS_PROFILE)"; \
	echo "══════════════════════════════════════════"; \
	make --no-print-directory perf-stress-$(PERF_STRESS_PROFILE) TARGET_HOST="$(PERF_COMPOSE_TARGET_HOST)" PERF_ACCOUNT_ENV_FILE="$(PERF_COMPOSE_ACCOUNT_ENV_FILE)" PERF_WEB_UI="$(PERF_TEST_WEB_UI)" || run_rc="$$?"; \
	if [ "$$run_rc" = "0" ] && [ "$(PERF_COMPOSE_EVALUATE_REPORT)" = "1" ]; then \
		echo "══════════════════════════════════════════"; \
		echo "  Evaluating performance report"; \
		echo "══════════════════════════════════════════"; \
		make --no-print-directory perf-compose-evaluate-report || analyze_rc="$$?"; \
	fi; \
	echo "══════════════════════════════════════════"; \
	echo "  Stopping test and killing dedicated services"; \
	echo "══════════════════════════════════════════"; \
	cleanup; \
	if [ "$$run_rc" != "0" ]; then exit "$$run_rc"; fi; \
	exit "$$analyze_rc"

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
