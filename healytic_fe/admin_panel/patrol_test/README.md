# Patrol Integration Tests Guide — Admin Panel

This directory contains end-to-end integration tests using the [Patrol](https://patrol.leancode.co/) framework, targeting the **web (Chrome)** platform via Playwright.

## 🏗️ Architecture

Patrol on web works by:
1. Starting a Flutter web server to serve the app
2. Launching Chromium via Playwright
3. Bridging `$.platform.web.*` calls to Playwright actions
4. Collecting and reporting test results

## 🏃 Running Tests

Tests are configured to run against specific environments using `--dart-define=ENV=<env>`.

### Run **All** Tests

```bash
# Run all tests in DEV environment
make patrol-test-dev

# Run all tests in UAT environment
make patrol-test-uat
```

### Run a **Single** Test

```bash
# Run only the login test in DEV
patrol test --device chrome \
  -t patrol_test/login_test.dart \
  --dart-define=ENV=dev \
  --dart-define=patrol=true

# Run only the dashboard test in UAT
patrol test --device chrome \
  -t patrol_test/dashboard_test.dart \
  --dart-define=ENV=uat \
  --dart-define=patrol=true
```

### Run **Headless** (CI)

```bash
patrol test --device chrome \
  -t patrol_test/login_test.dart \
  --dart-define=ENV=dev \
  --dart-define=patrol=true \
  --web-headless true
```

### Interactive Development Mode

```bash
patrol develop --device chrome \
  -t patrol_test/login_test.dart \
  --dart-define=ENV=dev \
  --dart-define=patrol=true
```

---

## ✍️ Writing New Tests

### 1. File Structure
Create your test file in `patrol_test/`. Group by feature (e.g., `employee_test.dart`, `products_test.dart`).

### 2. Boilerplate Code

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:admin_panel/core/keys/integration_test_keys.dart';
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

Use the centralized `keys` object from `lib/core/keys/integration_test_keys.dart`:

```dart
// ❌ BAD: Fragile, breaks on text changes
await $('Login').tap();

// ✅ GOOD: Robust, independent of content
await $(keys.signInPage.loginButton).tap();
```

### 4. Web-Specific Actions

Patrol provides web-native actions via `$.platform.web.*`:

```dart
// Resize browser window
await $.platform.web.resizeWindow(
  size: Size(1920, 1080),
);

// Dark mode
await $.platform.web.enableDarkMode();

// Keyboard shortcuts
await $.platform.web.pressKeyCombo(
  keys: ['Control', 'a'],
);

// Clipboard
await $.platform.web.setClipboard(text: 'data');

// File upload
await $.platform.web.uploadFile(files: [file]);
```

### 5. Fixtures and Data

Edit `patrol_test/fixtures/<env>_fixtures.json` for test data:

```dart
import 'config/test_config.dart';

final config = TestConfig.instance;
await $(keys.signInPage.emailTextField)
    .enterText(config.adminEmail);
```

DEV fixtures should match the app mock data sources. UAT fixtures are templates
for real backend accounts and must be filled before running UAT sign-in tests.

### 6. Dual-Role Testing

The admin panel supports Admin and Partner roles:

```dart
// Sign in as admin
await signIn($, role: 'admin');

// Sign in as partner
await signIn($, role: 'health_partner');
```

---

## 📁 Directory Structure

```
patrol_test/
├── README.md               # This file
├── CHANGELOG.md            # Required change log for Patrol edits
├── common.dart             # Patrol-safe bootstrap
├── config/
│   └── test_config.dart    # Env-aware fixture loader
├── fixtures/
│   ├── dev_fixtures.json   # DEV seed data
│   └── uat_fixtures.json   # UAT template
├── helpers/
│   ├── auth_helper.dart    # Sign-in helper
│   ├── navigation_helper.dart  # Side menu nav utility
│   └── permission_helper.dart  # Native permission helper
├── login_test.dart         # Sign-in scenarios
└── dashboard_test.dart     # Dashboard & menu tests
```
