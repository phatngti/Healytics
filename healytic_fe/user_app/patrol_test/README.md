# Patrol Integration Tests Guide

This directory contains end-to-end integration tests using the [Patrol](https://patrol.leancode.co/) framework.

## 🏃 Running Tests

Tests are configured to run against specific environments using `--dart-define=ENV=<env>`. Supported environments are `dev` (which uses mock data) and `uat` (which uses the real backend).

### Run **All** Tests

Use the predefined `Makefile` targets in the root directory:

```bash
# Run all tests in the DEV environment
make patrol-test-dev

# Run all tests in the UAT environment
make patrol-test-uat
```

### Run a **Single** Test

To run a specific test file, use the `patrol test` command with the `-t` (target) flag and pass the environment variable:

```bash
# Run only the onboarding test in DEV
patrol test -t patrol_test/onboarding_test.dart --dart-define=ENV=dev

# Run only the checkout/orders test in UAT
patrol test -t patrol_test/orders_test.dart --dart-define=ENV=uat
```

### Run **Multiple** Specific Tests

You can pass multiple `-t` flags to run multiple test files in sequence:

```bash
patrol test \
  -t patrol_test/onboarding_test.dart \
  -t patrol_test/home_test.dart \
  --dart-define=ENV=dev
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
- `dev_fixtures.json`
- `uat_fixtures.json`

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
