.PHONY: get gen translate run run-dev run-uat run-prod \
	run-i-dev run-i-uat run-i-prod \
	run-a-dev run-a-uat run-a-prod \
	build-apk build-apk-dev build-apk-uat build-apk-prod \
	build-ipa build-ipa-dev build-ipa-uat build-ipa-prod \
	architecture-check test

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

test:
	flutter test
