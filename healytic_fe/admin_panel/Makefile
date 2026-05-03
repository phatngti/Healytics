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
# Docker targets
# =============================================================================

# Build Docker image for admin panel web
# Usage: make docker-build TAG=abc123 [IMAGE=nonameaaaa/healytics_panel] [ENV=prod] [BASE_HREF=/]
docker-build:
	@if [ -z "$(TAG)" ]; then echo "ERROR: TAG is required. Usage: make docker-build TAG=abc123"; exit 1; fi
	bash scripts/docker-build.sh "$(TAG)" "$(or $(IMAGE),nonameaaaa/healytics_panel)" \
		--env "$(or $(ENV),prod)" \
		--base-href "$(or $(BASE_HREF),/)"

# Push Docker image to Docker Hub
# Usage: make docker-push TAG=abc123 [IMAGE=nonameaaaa/healytics_panel]
docker-push:
	@if [ -z "$(TAG)" ]; then echo "ERROR: TAG is required. Usage: make docker-push TAG=abc123"; exit 1; fi
	bash scripts/docker-push.sh "$(TAG)" "$(or $(IMAGE),nonameaaaa/healytics_panel)"