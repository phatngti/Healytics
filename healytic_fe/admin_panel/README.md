# Healytics Admin Panel

The **Admin Panel** is a Flutter web application for the [Healytics](https://github.com/your-org/healytics) health-and-wellness platform.  
It serves two user roles:

| Role | Purpose |
|------|---------|
| **Admin** | Platform oversight — manage categories, review & verify partner applications, view dashboards |
| **Health Partner** | Business operations — manage services/products, view transactions, chat with customers, complete & edit public profiles |

> Part of the `healytic_fe` monorepo alongside `user_app` (end-user mobile/web) and `common` (shared package).

---

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the App](#running-the-app)
- [Environments](#environments)
- [Code Generation](#code-generation)
- [Testing](#testing)
- [Linting & Formatting](#linting--formatting)
- [Project Structure](#project-structure)
- [Performance Guide](#performance-guide)
- [Contributing](#contributing)

---

## Features

### Admin Features

| Feature | Description |
|---------|-------------|
| **Dashboard** | Platform-wide analytics and KPI overview |
| **Partner Manager** | Review partner applications, approve/reject registrations, manage verification status |
| **Category Management** | CRUD operations for health service categories |

### Partner Features

| Feature | Description |
|---------|-------------|
| **Partner Dashboard** | Business analytics — revenue, appointments, performance charts (powered by `fl_chart`) |
| **Service & Product Management** | Create, edit, and publish health services and products with rich-text descriptions (`flutter_quill`) |
| **Transaction History** | View and filter booking/payment transactions |
| **Customer Chat** | Real-time messaging with customers via WebSocket (`socket_io_client`) |
| **Profile Completion** | Multi-step onboarding wizard — branding, certifications, gallery uploads |
| **Profile Edit** | Post-approval storefront editing — logo, cover image, description, gallery |
| **Service Tags** | Manage specialization tags for search discoverability |
| **Employee Management** | Manage staff members associated with the partner account |
| **Verification Status** | Track and respond to admin verification feedback |

### Cross-Cutting Concerns

| Capability | Implementation |
|------------|----------------|
| **Authentication** | JWT-based auth with secure token storage and auto-refresh |
| **Role-Based Routing** | Separate admin and partner route trees with guard redirects |
| **Theming** | Dark/Light mode with `FlexColorScheme`, theme-aware color tokens |
| **Responsive Layout** | Adaptive scaffold with sidebar navigation for desktop/tablet |
| **Localization** | Vietnamese locale support (`intl`, `slang`) |
| **Image Uploads** | S3-presigned URL upload flow with progress tracking |
| **Offline Database** | Local caching with Drift (SQLite) |

---

## Architecture

The project follows **Clean Architecture** with **Riverpod 3.0** for state management.

```
Presentation  →  Domain  →  Data
(UI, Notifiers)   (Entities, Repos)   (API, DataSources)
```

Each feature module is self-contained with three layers:

```
features/<feature>/
├── domain/          # Entities (Freezed), repository interfaces
├── data/            # Remote data sources (real + mock), repository implementations
│   └── datasource/
└── presentation/    # Screens, widgets, Riverpod providers/notifiers
```

**Key architectural decisions:**

- **Domain layer is pure Dart** — no Flutter imports, no framework dependencies
- **Data sources follow a 3-part pattern** — abstract interface → real implementation → mock implementation
- **Entities use `@freezed`** for immutability and pattern matching
- **OpenAPI-generated client** (`admin_openapi`) for type-safe API calls
- **Shared components** live in `package:common` to avoid duplication with `user_app`

---

## Tech Stack

| Category | Technology |
|----------|-----------|
| Framework | Flutter 3.9+ (Web-primary) |
| Language | Dart 3.9+ |
| State Management | Riverpod 3.0 + code generation |
| Routing | GoRouter + `go_router_builder` (type-safe) |
| UI Components | ShadCN UI (`shadcn_ui`) |
| Theming | FlexColorScheme |
| Forms | Flutter Form Builder |
| Rich Text | Flutter Quill |
| Charts | FL Chart |
| Maps | Flutter Map + LatLong2 |
| Local DB | Drift (SQLite) |
| Networking | HTTP + Socket.IO |
| Code Generation | Freezed, JSON Serializable, Riverpod Generator, Build Runner |
| API Client | OpenAPI Generator (package `admin_openapi`) |
| Linting | flutter_lints, custom_lint, riverpod_lint |

---

## Prerequisites

- **Flutter SDK** `>=3.9.2` — [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK** `>=3.9.2` (bundled with Flutter)
- **Chrome** (for web development)
- **Make** (optional, for Makefile shortcuts)

Verify your setup:

```bash
flutter doctor -v
```

---

## Installation

1. **Clone the monorepo** and navigate to the admin panel:

```bash
git clone https://github.com/your-org/healytics.git
cd healytics/healytic_fe/admin_panel
```

2. **Install dependencies** (workspace-aware):

```bash
flutter pub get
# or
make get
```

3. **Generate code** (Freezed, Riverpod, GoRouter, JSON serialization):

```bash
dart run build_runner build --delete-conflicting-outputs
# or
make gen
```

4. **Generate translations** (if modifying locale files):

```bash
dart run slang
# or
make translate
```

---

## Running the App

### Development (default)

```bash
flutter run -d chrome --dart-define=ENV=dev
# or
make run-dev
```

### UAT (User Acceptance Testing)

```bash
flutter run -d chrome --dart-define=ENV=uat
# or
make run-uat
```

### Production

```bash
flutter run -d chrome --dart-define=ENV=prod --release
# or
make run-prod
```

### Production with WASM

```bash
flutter run -d chrome --dart-define=ENV=dev --wasm --release
# or
make run
```

---

## Environments

The app supports three build environments, each loading a separate JSON configuration:

| Environment | Config File | API Target | Mock Data |
|-------------|-------------|------------|-----------|
| `dev` | `assets/store.dev.json` | Local / Dev server | Enabled via flag |
| `uat` | `assets/store.uat.json` | Staging server | Disabled |
| `prod` | `assets/store.prod.json` | Production server | Disabled |

Switch environments at build time with:

```bash
flutter run --dart-define=ENV=<dev|uat|prod>
```

Each data source provider exposes a `useMock` flag to toggle between real API calls and mock data during development.

---

## Code Generation

The project relies heavily on code generation. After modifying any of the following annotations, re-run the generator:

| Annotation | Purpose |
|------------|---------|
| `@riverpod` | Riverpod providers and notifiers |
| `@freezed` | Immutable entities and state classes |
| `@JsonSerializable` | JSON serialization/deserialization |
| `@TypedGoRoute` | Type-safe route definitions |

### One-time build

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Watch mode (auto-rebuild on save)

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### OpenAPI Client Regeneration

When the backend OpenAPI spec changes:

```bash
cd openapi
# Follow the openapi generator instructions in the openapi/ directory
```

---

## Testing

### Unit & Widget Tests

```bash
flutter test
# or
make test
```

Run a specific test file:

```bash
flutter test test/features/authenticate/login_test.dart
```

### Integration Tests (Web / Chrome)

Integration tests use `flutter drive` with ChromeDriver:

1. **Start ChromeDriver** (in a separate terminal):

```bash
make start-chromedriver
```

2. **Run integration tests**:

```bash
make i-test
```

Or run both steps combined:

```bash
make i-test   # Automatically starts/stops chromedriver
```

### Test Organization

```
test/
├── features/          # Feature-specific unit & widget tests
│   ├── authenticate/  # Auth flow tests
│   ├── common/        # Shared widget tests
│   └── partner/       # Partner feature tests
├── fixtures/          # Shared test data & fixtures
└── widget_test.dart   # Default widget test

integration_test/
├── sign_up_form_integration_test.dart   # E2E sign-up flow
└── test_driver/
    └── integration_test.dart            # Test driver entry point
```

### Testing Strategy

| Layer | What to Test | How |
|-------|-------------|-----|
| **Domain** | Entity logic, validation rules | Pure Dart unit tests |
| **Data** | DTO mapping, repository implementations | Unit tests with built-in mock data sources |
| **Presentation** | Widget rendering, user interactions | `flutter_test` widget tests |
| **E2E** | Full user flows (sign-up, login) | `flutter drive` integration tests |

> **Tip:** Each remote data source includes a built-in mock class — no need for external mocking libraries like Mockito.

---

## Linting & Formatting

### Static Analysis

```bash
dart analyze
```

### Auto-format

```bash
dart format lib test
```

### Auto-fix

```bash
dart fix --apply
```

### Lint Configuration

- Base: `package:flutter_lints/flutter.yaml`
- Plugins: `custom_lint`, `riverpod_lint`
- Config: [`analysis_options.yaml`](analysis_options.yaml)

### Quality Checklist

- [ ] No `print()` — use `dart:developer` `log()`
- [ ] No hardcoded colors — use `Theme.of(context).colorScheme.*`
- [ ] No inline text styles — use `Theme.of(context).textTheme.*`
- [ ] No Flutter imports in `domain/` layer
- [ ] File naming conventions: `.screen.dart`, `.widget.dart`, `.provider.dart`, `.entity.dart`
- [ ] Functions under 20 lines, lines under 80 characters
- [ ] Shared widgets from `package:common` (not re-implemented)

---

## Project Structure

```
admin_panel/
├── lib/
│   ├── main.dart                         # App entry point
│   ├── constants/                        # App-wide constants
│   ├── core/
│   │   ├── config/                       # Environment configuration
│   │   ├── database/                     # Drift DB setup
│   │   ├── entities/                     # Shared domain entities
│   │   ├── extension/                    # Dart/Flutter extensions
│   │   ├── models/                       # Shared data models
│   │   ├── network/                      # Network configuration
│   │   ├── providers/                    # Core Riverpod providers (auth, API)
│   │   ├── repositories/                # Core repository interfaces
│   │   ├── services/
│   │   │   ├── api.service.dart          # HTTP API client
│   │   │   ├── s3.service.dart           # S3 file upload
│   │   │   ├── image_upload.service.dart # Image upload orchestration
│   │   │   ├── log.service.dart          # Logging service
│   │   │   ├── storage.service.dart      # Secure storage
│   │   │   ├── store.service.dart        # App config store
│   │   │   ├── ws.service.dart           # WebSocket service
│   │   │   └── ws/                       # WebSocket helpers
│   │   └── utils/                        # Helpers, formatters
│   ├── features/
│   │   ├── admin/
│   │   │   ├── category/                 # Category CRUD
│   │   │   ├── dashboard/                # Admin dashboard
│   │   │   └── partner_manager/          # Partner review & verification
│   │   ├── authenticate/                 # Login, registration, JWT auth
│   │   ├── common/
│   │   │   ├── providers/                # Shared feature providers
│   │   │   └── widgets/                  # Shared layout widgets
│   │   │       ├── adaptive_root_scaffold/ # Responsive shell
│   │   │       └── responsive/             # Responsive utilities
│   │   ├── partner/
│   │   │   ├── chat/                     # Real-time customer chat
│   │   │   ├── dashboard/                # Partner analytics dashboard
│   │   │   ├── employee/                 # Employee management
│   │   │   ├── products/                 # Service & product management
│   │   │   ├── profile_completion/       # Onboarding wizard
│   │   │   ├── profile_edit/             # Storefront editing
│   │   │   ├── service_tags/             # Specialization tags
│   │   │   ├── transactions/             # Transaction history
│   │   │   └── verification_status/      # Verification tracking
│   │   └── app/                          # Root App widget
│   ├── gen/                              # Generated code (assets, etc.)
│   ├── hooks/                            # Flutter hooks (bootstrap)
│   ├── localization/                     # i18n setup
│   ├── preferences/                      # User preferences
│   ├── router/                           # GoRouter config (admin + partner routes)
│   ├── theme/                            # Theme definitions (light/dark)
│   └── utils/                            # Global utility functions
├── test/                                 # Unit & widget tests
├── integration_test/                     # E2E browser tests
├── openapi/                              # Generated OpenAPI client (admin_openapi)
├── assets/
│   ├── store.dev.json                    # Dev environment config
│   ├── store.uat.json                    # UAT environment config
│   ├── store.prod.json                   # Production environment config
│   ├── icons/                            # SVG/PNG icons
│   ├── images/                           # Static images
│   ├── translations/                     # Locale files
│   └── animations/                       # Lottie animations
├── Makefile                              # Developer shortcuts
├── pubspec.yaml                          # Dependencies & assets
├── analysis_options.yaml                 # Lint rules
└── build.yaml                            # Build runner config
```

---

## Performance Guide

### Widget Optimization

- **Use `const` constructors** for stateless widgets to enable tree-shaking and avoid unnecessary rebuilds.
- **Prefer `ListView.builder`** over `ListView(children: [...])` for large or dynamic lists — items are built lazily.
- **Break large `build()` methods** into separate widget classes (not helper methods) to localize rebuilds.
- **Use `compute()`** for expensive operations to offload work to isolates.

### State Management

- **Scope providers narrowly** — avoid watching providers higher than needed in the widget tree.
- **Use `select()`** to watch only the specific field you need from a provider, reducing unnecessary rebuilds:

```dart
final name = ref.watch(
  userProvider.select((user) => user.name),
);
```

- **Dispose resources** — `@riverpod` providers with `keepAlive: false` are auto-disposed when no longer listened to.
- **Use `AsyncValue`** patterns to handle loading, data, and error states efficiently.

### Network & Caching

- **Cache images** with `cached_network_image` — avoids redundant downloads.
- **Drift (SQLite)** for local caching — reduce API calls for frequently accessed data.
- **Debounce search inputs** to avoid excessive API requests.

### Build & Deployment

- **Use `--release` mode** for performance testing — debug mode includes overhead from assertions and dev tools.
- **Enable WASM** (`--wasm`) for production web builds for near-native performance.
- **Tree-shake icons** — only import icon packages you actually use.
- **Analyze bundle size:**

```bash
flutter build web --release --source-maps
```

### Web-Specific Tips

- **Prefer CanvasKit renderer** (default) for consistent cross-browser rendering.
- **Lazy-load routes** — GoRouter's shell routes ensure only active features are in memory.
- **Minimize main bundle** — keep `main.dart` lean; heavy initialization belongs in `Bootstrap`.

---

## Contributing

1. Create a feature branch from `main`
2. Follow the [architecture rules](#architecture) and [quality checklist](#linting--formatting)
3. Run code generation after modifying annotated classes: `make gen`
4. Ensure all tests pass: `make test`
5. Run static analysis: `dart analyze`
6. Submit a pull request for review

---

## Related Documentation

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Freezed Documentation](https://pub.dev/packages/freezed)
- [ShadCN UI for Flutter](https://pub.dev/packages/shadcn_ui)
- [FL Chart Documentation](https://pub.dev/packages/fl_chart)

---

## License

This project is proprietary. All rights reserved.
