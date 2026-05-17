# Patrol Test Changelog

> Every PR or commit touching `patrol_test/` must update this file.
> Group changes by date and author. Use actions: `Added`, `Modified`,
> `Removed`, `Refactored`.

---

## [2026-05-14] - Admin Panel Structure Alignment

### Added

| File | Test Case | Description |
|------|-----------|-------------|
| `helpers/permission_helper.dart` | - | Native permission dialog helper kept in the same suite structure as user_app |
| `CHANGELOG.md` | - | Patrol-suite change log matching the user_app convention |

### Modified

| File | Test Case | Description |
|------|-----------|-------------|
| `common.dart` | All | Resets persisted login state before each app pump so tests start from the sign-in route |
| `config/test_config.dart` | All | Added typed dashboard, mock-mode, and Patrol-mode accessors |
| `helpers/auth_helper.dart` | Sign-in | Normalizes role names and selects the Partner role before entering partner credentials |
| `fixtures/dev_fixtures.json` | Sign-in | Updated DEV passwords to match the app mock accounts |
| `fixtures/dev_fixtures.json` | Dashboard | Updated dashboard title fixture to match the admin dashboard UI |
| `fixtures/uat_fixtures.json` | Dashboard | Updated dashboard title fixture to match the admin dashboard UI |
| `login_test.dart` | Sign-in | Switched repeated raw keys to centralized `keys.*` finders and made invalid-credential coverage real-backend only |
| `dashboard_test.dart` | Dashboard | Imported Flutter material types for web resize and asserted the admin dashboard screen directly |
