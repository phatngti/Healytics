.PHONY: get gen translate run run-dev run-uat run-prod \
	run-ios-dev run-ios-uat run-ios-prod \
	run-android-dev run-android-uat run-android-prod \
	build-apk build-apk-dev build-apk-uat build-apk-prod \
	build-ipa build-ipa-dev build-ipa-uat build-ipa-prod \
	architecture-check \
	patrol-test-dev patrol-test-uat patrol-test-e2e patrol-e2e-preflight patrol-dev patrol-dev-e2e

PATROL_DEVICE ?= emulator-5554
# BACKDOOR_BASE_URL ?= http://10.0.2.2:8000/backend
# BACKDOOR_HEALTH_URL ?= http://localhost:8000/backend/test-backdoor/status
BACKDOOR_BASE_URL ?= https://healytics.me/backend
BACKDOOR_HEALTH_URL ?= https://healytics.me/backend/test-backdoor/status
PATROL_E2E_TESTS ?= $(shell find patrol_test -maxdepth 1 -name '*_test.dart' ! -name 'test_bundle.dart' ! -name 'auth_password_reset_test.dart' | sort)

# ─── Dependencies ────────────────────────────────
get:
	flutter pub get

# ─── Code Generation ─────────────────────────────
gen:
	dart run build_runner build \
		--delete-conflicting-outputs --verbose

# ─── Localization ──────────────────────────────────
translate:
	dart run slang

# ─── Run (default = dev) ──────────────────────────
run: run-dev

run-dev:
	flutter run --dart-define=ENV=dev

run-uat:
	flutter run --dart-define=ENV=uat

run-prod:
	flutter run --dart-define=ENV=prod

run-i-dev:
	./tool/run_device.sh ios dev

run-i-uat:
	./tool/run_device.sh ios uat

run-i-prod:
	./tool/run_device.sh ios prod

run-a-dev:
	./tool/run_device.sh android dev

run-a-uat:
	./tool/run_device.sh android uat

run-a-prod:
	./tool/run_device.sh android prod

# ─── Build APK ─────────────────────────────────────
build-apk: build-apk-prod

build-apk-dev:
	flutter build apk --dart-define=ENV=dev

build-apk-uat:
	flutter build apk --dart-define=ENV=uat

build-apk-prod:
	flutter build apk --dart-define=ENV=prod

# ─── Build IPA ─────────────────────────────────────
build-ipa: build-ipa-prod

build-ipa-dev:
	flutter build ipa --dart-define=ENV=dev

build-ipa-uat:
	flutter build ipa --dart-define=ENV=uat

build-ipa-prod:
	flutter build ipa --dart-define=ENV=prod

# ─── Quality ───────────────────────────────────────
architecture-check:
	bash ./tool/check_architecture.sh

# ─── Patrol Integration Tests ──────────────────────
patrol-test-dev:
	patrol test --dart-define=ENV=dev \
		--dart-define=patrol=true

patrol-test-uat:
	patrol test --dart-define=ENV=uat \
		--dart-define=patrol=true

patrol-e2e-preflight:
	@curl -fsS "$(BACKDOOR_HEALTH_URL)" >/dev/null || ( \
		echo "Patrol E2E backdoor is not ready at $(BACKDOOR_HEALTH_URL)."; \
		echo "Start backend with NODE_ENV=test, a test database, and TEST_PASSWORD_RESET_CODE=123456."; \
		exit 1; \
	)

patrol-test-e2e: patrol-e2e-preflight
	@set -e; \
	for test_file in $(PATROL_E2E_TESTS); do \
		echo "Running $$test_file"; \
		adb uninstall com.example.user_app >/dev/null 2>&1 || true; \
		adb uninstall com.example.user_app.test >/dev/null 2>&1 || true; \
		adb uninstall androidx.test.orchestrator >/dev/null 2>&1 || true; \
		adb uninstall androidx.test.services >/dev/null 2>&1 || true; \
		patrol test --device $(PATROL_DEVICE) \
			--no-uninstall \
			--dart-define=ENV=test \
			--dart-define=patrol=true \
			--dart-define=BACKDOOR_BASE_URL=$(BACKDOOR_BASE_URL) \
			-t "$$test_file"; \
	done

patrol-dev:
	patrol develop --dart-define=ENV=dev \
		--dart-define=patrol=true \
		-t patrol_test/onboarding_test.dart

patrol-dev-e2e:
	patrol develop --dart-define=ENV=test \
		--dart-define=patrol=true \
		--dart-define=BACKDOOR_BASE_URL=$(BACKDOOR_BASE_URL) \
		-t patrol_test/home_test.dart
