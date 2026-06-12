# Patrol Test Changelog

> Every PR/commit touching `patrol_test/` **must** update this file.
> Group changes by date and author. Use actions: `Added`, `Modified`, `Removed`, `Refactored`.

---

## [2026-05-20] — Dual-Lane E2E Upgrade

### Added

| File | Test Case | Description |
|------|-----------|-------------|
| `auth_password_reset_test.dart` | Password reset | Covers forgot-password validation and real-backend reset with fixed test code |
| `booking_test.dart` | Booking entry | Opens booking from home quick action and verifies category/service selection routing |
| `fixtures/scenarios/password_reset_seed.json` | — | Adds deterministic reset-account scenario |

### Modified

| File | Test Case | Description |
|------|-----------|-------------|
| `fixtures/test_fixtures.json` | — | Adds `passwordReset` config and scenario mapping |
| `fixtures/scenarios/*_seed.json` | — | Adds employee schedules for real booking/time-slot coverage and completed order seed for review flow |
| `helpers/backend_backdoor_helper.dart` | — | Sends raw JSON payloads so backend seed fields are not dropped by stale generated DTOs |
| `home_test.dart` | Home view all | Adds route checks for all home view-all actions |
| `notifications_test.dart` | Notifications | Adds seeded item, mark-one-read, and mark-all-read coverage |
| `cart_test.dart`, `checkout_test.dart`, `orders_test.dart` | Real backend lane | Replaces mock-only skips with real-scenario assertions where deterministic seeds exist |
| `../lib/core/keys/integration_test_keys.dart` | — | Adds selectors for home, clinic, employee, booking, review, cart, and notification flows |

---

## [2026-03-14] — Initial Setup

### Added

| File | Test Case | Description |
|------|-----------|-------------|
| `fixtures/dev_fixtures.json` | — | DEV environment seed data (mock credentials, orders, conversations, services) |
| `fixtures/test_fixtures.json` | — | TEST environment seeded-backend configuration |
| `README.md` | — | Guide for creating, running, and managing tests |
| `config/test_config.dart` | — | Env-aware fixture loader with typed accessors |
| `common.dart` | — | Patrol-compatible app bootstrap (no binding, no runApp, no error handler) |
| `helpers/auth_helper.dart` | — | Sign-in helper using fixture credentials |
| `helpers/navigation_helper.dart` | — | Bottom-tab navigation utility with label constants |
| `helpers/permission_helper.dart` | — | Native permission dialog handler (grant when in use) |

### Added — Test Files

| File | Test Case | Description |
|------|-----------|-------------|
| `onboarding_test.dart` | Splash → Onboarding | Verifies splash screen appears |
| `onboarding_test.dart` | Onboarding → Sign In | Swipes pages and taps Get Started |
| `onboarding_test.dart` | Sign In (valid) | Fixture credentials → Home |
| `onboarding_test.dart` | Sign In (invalid) | Wrong password → error shown |
| `onboarding_test.dart` | Sign Up flow | Email form → code confirmation |
| `onboarding_test.dart` | Survey (4 steps) | Goals → Lifestyle → Body → Health |
| `home_test.dart` | Home renders | Header, actions, recommendations visible |
| `home_test.dart` | Service details | Tap service → details screen |
| `home_test.dart` | Reviews | Details → reviews screen |
| `home_test.dart` | Category filter | Tap categories, verify results |
| `bot_chat_test.dart` | History list | Conversation history renders |
| `bot_chat_test.dart` | New conversation | Tap new → chat page |
| `bot_chat_test.dart` | Send message | Type → appears in chat |
| `bot_chat_test.dart` | Resume | Tap existing → messages load |
| `orders_test.dart` | Orders list | Fixture orders render |
| `orders_test.dart` | Status filter | Upcoming / Completed / Canceled |
| `orders_test.dart` | Order details | Tap order → details screen |
| `orders_test.dart` | Service manual | Details → manual link |
| `orders_test.dart` | Checkout | Service → checkout screen |
| `profile_test.dart` | Profile renders | User info visible |
| `profile_test.dart` | Edit profile | Modify → save → verify update |
| `notifications_test.dart` | Notifications list | Tab renders list |
| `notifications_test.dart` | Tap notification | Navigates to target |
| `notifications_test.dart` | Permission dialog (native) | Grants via native dialog |
| `notifications_test.dart` | Notification shade (native) | Opens shade, taps notification |

### Added — CI/Makefile

| File | Test Case | Description |
|------|-----------|-------------|
| `../Makefile` | — | Added `patrol-test-dev`, `patrol-test-uat`, `patrol-dev` targets |

---

## [2026-03-14] — Global Keys Integration

### Added

| File | Test Case | Description |
|------|-----------|-------------|
| `../lib/core/keys/integration_test_keys.dart` | — | Centralized test keys (10 page key classes + global `keys` accessor) |

### Modified

| File | Test Case | Description |
|------|-----------|-------------|
| `../lib/features/authenticate/presentation/widgets/form.dart` | — | Added `keys.signInPage.*` to email, password fields and buttons |
| `../lib/features/authenticate/presentation/screens/signin.screen.dart` | — | Added `keys.signInPage.*` to Google/Facebook buttons |
| `../lib/features/onboarding/presentation/screens/onboard.screen.dart` | — | Added `keys.onboardPage.*` to Sign In/Create Account buttons |
| `../lib/features/onboarding/sign_up/presentation/screens/email_form.dart` | — | Added `keys.emailFormPage.*` to email field and Continue button |
| `../lib/features/onboarding/sign_up/presentation/screens/email_code_confirmation.dart` | — | Added `keys.codeConfirmationPage.*` to Pinput and Submit button |
| `../common/lib/widgets/input/form_field_builders.dart` | — | Added `widgetKey` parameter to `buildTextField` |

### Refactored

| File | Test Case | Description |
|------|-----------|-------------|
| `helpers/auth_helper.dart` | — | Switched from TextFormField index to `keys.signInPage.*` finders |
| `helpers/navigation_helper.dart` | — | Switched from string labels to `keys.bottomNav.*` Key finders |
| `onboarding_test.dart` | All | Rewrote all tests to use `keys.*` finders |
| `home_test.dart` | All | Updated to use `TabKeys` for navigation |
| `bot_chat_test.dart` | All | Updated to use `keys.chatPage.*` finders |
| `orders_test.dart` | All | Updated to use `TabKeys` for navigation |
| `profile_test.dart` | All | Updated to use `keys.profilePage.*` finders |
| `notifications_test.dart` | All | Updated to use `TabKeys` + `keys.notificationsPage.*` finders |

---

## [2026-04-10] — Cart And Checkout Coverage

### Added

| File | Test Case | Description |
|------|-----------|-------------|
| `cart_test.dart` | Cart renders | Opens cart from home header and verifies seeded mock items |
| `cart_test.dart` | Cart search | Filters cart list by service name |
| `cart_test.dart` | Voucher flow | Selects a cart item, opens voucher picker, applies coupon, verifies discount summary |
| `checkout_test.dart` | Checkout summary | Navigates from cart to checkout and verifies selected booking details |
| `checkout_test.dart` | Checkout confirm | Switches payment method to pay later and verifies successful submission dialog |

### Modified

| File | Test Case | Description |
|------|-----------|-------------|
| `../lib/core/keys/integration_test_keys.dart` | — | Added stable keys for home cart entry, cart interactions, voucher picker, and checkout payment method selectors |
| `../lib/features/home/presentation/widgets/home_header.widget.dart` | — | Added cart button integration test key |
| `../lib/features/cart/presentation/widgets/cart_app_bar.widget.dart` | — | Added cart search field integration test key |
| `../lib/features/cart/presentation/widgets/cart_item_card.widget.dart` | — | Added per-item selection key and passed item ID into voucher selector |
| `../lib/features/cart/presentation/widgets/voucher_selector_row.widget.dart` | — | Added per-item voucher selector integration test key |
| `../lib/features/cart/presentation/widgets/voucher_picker_sheet.widget.dart` | — | Added voucher tile and apply button integration test keys |
| `../lib/features/cart/presentation/widgets/cart_summary_footer.widget.dart` | — | Added checkout CTA integration test key |
| `../lib/features/checkout/presentation/widgets/payment_method_section.widget.dart` | — | Added payment method tile integration test keys |
| `../lib/features/checkout/presentation/widgets/checkout_bottom_bar.widget.dart` | — | Wired `keys.checkoutPage.confirmButton` into the confirm CTA |
| `test_bundle.dart` | — | Registered `cart_test.dart` and `checkout_test.dart` in the Patrol bundle entrypoint |
