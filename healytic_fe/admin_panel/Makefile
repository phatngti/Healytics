get:	
	flutter pub get

gen:
	dart run build_runner build --delete-conflicting-outputs --verbose

translate:
	dart run slang


run-dev:
	flutter run -d chrome --dart-define=ENV=dev

run-uat:
	flutter run -d chrome --dart-define=ENV=uat

run-prod:
	flutter run -d chrome --dart-define=ENV=prod --release

run:
	flutter run -d chrome --dart-define=ENV=dev --wasm --release

# Start chromedriver on port 4444 for integration tests
start-chromedriver:
	@if command -v chromedriver > /dev/null 2>&1; then \
		chromedriver --port=4444; \
	else \
		./chromedriver/mac_arm-137/chromedriver-mac-arm64/chromedriver --port=4444; \
	fi

# Run integration tests on Chrome (web)
# Uses flutter drive with chromedriver
i-test:
	@echo "Starting chromedriver on port 4444..."
	@./chromedriver/mac_arm-137.0.7151.119/chromedriver-mac-arm64/chromedriver --port=4444 & \
	CHROMEDRIVER_PID=$$!; \
	echo "Chromedriver started with PID $$CHROMEDRIVER_PID"; \
	sleep 5; \
	flutter drive \
		--driver=integration_test/test_driver/integration_test.dart \
		--target=integration_test/sign_up_form_integration_test.dart \
		-d chrome; \
	TEST_EXIT_CODE=$$?; \
	echo "Stopping chromedriver (PID $$CHROMEDRIVER_PID)..."; \
	kill $$CHROMEDRIVER_PID 2>/dev/null || true; \
	exit $$TEST_EXIT_CODE

# Run unit/widget tests (not integration tests)
test:
	flutter test

# =============================================================================
# Patrol E2E Tests (web / Chrome)
# =============================================================================

# Run all patrol tests in DEV (mock data)
patrol-test-dev:
	patrol test --device chrome --dart-define=ENV=dev

# Run all patrol tests in UAT (real backend)
patrol-test-uat:
	patrol test --device chrome --dart-define=ENV=uat

# Run all patrol tests headless (CI)
patrol-test-ci:
	patrol test --device chrome --dart-define=ENV=dev --web-headless true

# Interactive patrol develop mode (hot-restart)
patrol-dev:
	patrol develop --device chrome -t patrol_test/login_test.dart --dart-define=ENV=dev

# =============================================================================
# Docker targets
# =============================================================================

# Build Docker image for admin panel web (local only - use docker-release for cross-arch)
# Usage: make docker-build TAG=abc123 [IMAGE=nonameaaaa/healytics_panel] [ENV=prod] [BASE_HREF=/]
docker-build:
	@if [ -z "$(TAG)" ]; then echo "ERROR: TAG is required. Usage: make docker-build TAG=abc123"; exit 1; fi
	bash scripts/docker-build.sh "$(TAG)" "$(or $(IMAGE),nonameaaaa/healytics_panel)" \
		--env "$(or $(ENV),prod)" \
		--base-href "$(or $(BASE_HREF),/)"

# Build AND push Docker image in one step (REQUIRED for cross-arch builds on Apple Silicon)
# This ensures correct platform metadata is preserved when building for AMD64 on ARM64.
# Usage: make docker-release TAG=abc123 [IMAGE=nonameaaaa/healytics_panel] [ENV=prod] [BASE_HREF=/]
docker-release:
	@if [ -z "$(TAG)" ]; then echo "ERROR: TAG is required. Usage: make docker-release TAG=abc123"; exit 1; fi
	bash scripts/docker-build.sh "$(TAG)" "$(or $(IMAGE),nonameaaaa/healytics_panel)" \
		--env "$(or $(ENV),prod)" \
		--base-href "$(or $(BASE_HREF),/)" \
		--push

# Push Docker image to Docker Hub (only use if image was built on matching architecture)
# For cross-arch builds, use docker-release instead.
# Usage: make docker-push TAG=abc123 [IMAGE=nonameaaaa/healytics_panel]
docker-push:
	@if [ -z "$(TAG)" ]; then echo "ERROR: TAG is required. Usage: make docker-push TAG=abc123"; exit 1; fi
	bash scripts/docker-push.sh "$(TAG)" "$(or $(IMAGE),nonameaaaa/healytics_panel)"