# Patrol Integration Tests Guide

This directory contains end-to-end integration tests using the [Patrol](https://patrol.leancode.co/) framework.

## 🏃 Running Tests

Tests are configured to run against specific environments using `--dart-define=ENV=<env>`.

- `ENV=dev` is the fast mock lane.
- `ENV=test` is the seeded real-backend lane. It adds scenario data through `/backend/test-backdoor/seed` and removes only the returned seed IDs through `/backend/test-backdoor/cleanup`.

`ENV=uat` is not used for Patrol unless a test explicitly opts into it.

### Real Backend Prerequisites

The test backdoor is intentionally guarded. It only works when the backend runs with `NODE_ENV=test` and the active database name contains `test`.

```bash
# From backend/
PGPASSWORD='admin@123' createdb -h localhost -p 5432 -U admin healytics_test_db

NODE_ENV=test \
POSTGRES_HOST=localhost \
POSTGRES_PORT=5432 \
POSTGRES_USER=admin \
POSTGRES_PASSWORD='admin@123' \
POSTGRES_DB=healytics_test_db \
POSTGRES_SSL=false \
npm run migration:run

NODE_ENV=test \
POSTGRES_HOST=localhost \
POSTGRES_PORT=5432 \
POSTGRES_USER=admin \
POSTGRES_PASSWORD='admin@123' \
POSTGRES_DB=healytics_test_db \
POSTGRES_SSL=false \
TEST_PASSWORD_RESET_CODE=123456 \
npm run start:e2e
```

### Run **All** Tests

Use the predefined `Makefile` targets in the root directory:

```bash
# Run all tests in the DEV environment
make patrol-test-dev

# Run all tests against the seeded real backend
make patrol-test-e2e
```

`make patrol-test-e2e` defaults to `PATROL_DEVICE=emulator-5554`, checks `http://localhost:8000/backend/test-backdoor/status`, cleans installed app/test runner packages before each file, and runs Patrol file-by-file with `--no-uninstall` so Android Test Orchestrator can isolate each Dart test without removing the target package mid-run. Override these if needed:

```bash
PATROL_DEVICE=emulator-5556 \
BACKDOOR_BASE_URL=http://10.0.2.2:8000/backend \
BACKDOOR_HEALTH_URL=http://localhost:8000/backend/test-backdoor/status \
make patrol-test-e2e
```

Limit the Make target to selected files while debugging:

```bash
PATROL_E2E_TESTS="patrol_test/auth_password_reset_test.dart patrol_test/checkout_test.dart" \
make patrol-test-e2e
```

### Run a **Single** Test

To run a specific test file, use the `patrol test` command with the `-t` (target) flag and pass the environment variable:

```bash
# Run only the onboarding test in DEV
patrol test -t patrol_test/onboarding_test.dart --dart-define=ENV=dev

# Run only the checkout/orders test in the real backend lane
patrol test -t patrol_test/orders_test.dart --dart-define=ENV=test
```

### Run **Multiple** Specific Tests

Pass multiple `-t` flags when you want a focused subset:

```bash
patrol test --device emulator-5554 --no-uninstall \
  -t patrol_test/home_test.dart \
  -t patrol_test/orders_test.dart \
  --dart-define=ENV=test \
  --dart-define=patrol=true \
  --dart-define=BACKDOOR_BASE_URL=http://10.0.2.2:8000/backend
```

### Interactive Development Mode

If you're writing a new test and want to hot-restart iteratively without rebuilding the app:

```bash
# Example: Run onboarding_test in develop mode
patrol develop -t patrol_test/onboarding_test.dart --dart-define=ENV=dev
```
Or use the Makefile shortcut which targets `onboarding_test.dart` by default: `make patrol-dev`.

---

## ✍️ Writing New Tests

### 1. File Structure
Create your new test file in the `patrol_test/` directory. Typically, test files are grouped by feature (e.g., `profile_test.dart`, `checkout_test.dart`).

*Note: Do not put tests inside `test/` (which is for unit/widget tests) or `integration_test/` (which is the standard flutter integration).*

### 2. Boilerplate Code

Every test must use the custom `pumpApp($)` bootstrap from `common.dart` to initialize Riverpod, localization, and theme without `runApp()` timing issues:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'common.dart';

void main() {
  patrolTest(
    'my new feature test',
    ($) async {
      // 1. Boot up the app
      await pumpApp($);
      
      // 2. Interact
      // ...
    },
  );
}
```

### 3. Finding Widgets using Global Keys (IMPORTANT)
To keep tests robust against text changes or localization, **do not** use string search like `$('Sign In')`.

Instead, use the centralized `keys` object from `lib/core/keys/integration_test_keys.dart`.

```dart
// ❌ BAD: Fragile, breaks if text changes or translates
await $('Log In').tap();

// ✅ GOOD: Robust, independent of content
await $(keys.signInPage.signInButton).tap();
```

If you need to click a widget that doesn't have a key yet:
1. Open `lib/core/keys/integration_test_keys.dart`.
2. Add a new `Key('my_widget_key')` to the relevant screen class.
3. Supply that key to the widget in the presentation layer (`key:` or `widgetKey:`).

### 4. Fixtures and Data
Tests rely on predefined data defined in `patrol_test/fixtures/`.

- `dev_fixtures.json` configures mock-lane expectations.
- `test_fixtures.json` configures the real-backend lane and maps scenario names to JSON payloads under `patrol_test/fixtures/scenarios/`.

Static/master data belongs in backend migrations. Per-test dynamic data belongs in scenario payloads such as `core_seed.json`, `cart_checkout_seed.json`, `orders_seed.json`, `notifications_seed.json`, and `password_reset_seed.json`.

You can access these typed fixtures in your tests using `TestConfig`:

```dart
import 'config/test_config.dart';

final config = TestConfig.instance;
await $(keys.signInPage.emailTextField).enterText(config.testEmail);
```

### 5. Utilities
- **`auth_helper.dart`**: Contains `signIn($)` which automatically logs into the app using the environment's fixture credentials.
- **`navigation_helper.dart`**: Contains `navigateToTab($, TabKeys.home)` to handle bottom navigation bar routing safely.
- **`permission_helper.dart`**: Handlers for native OS permission dialogs (like notifications or location). Use `await handlePermissionIfVisible($)`.
