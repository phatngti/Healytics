# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the user-facing mobile/web app for Healytics, a health and wellness platform. The app is built with Flutter and follows Clean Architecture principles with Riverpod for state management.

## Commands

### Development
```bash
# Install dependencies (uses workspace resolution)
flutter pub get

# Run the app
flutter run

# Run with specific device
flutter run -d chrome
flutter run -d macos

# Code generation (after modifying @riverpod, @freezed, or routes)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for code generation
dart run build_runner watch --delete-conflicting-outputs
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/authenticate/presentation/signin_test.dart

# Run tests with coverage
flutter test --coverage
```

### Code Quality
```bash
# Lint analysis
dart analyze

# Format code
dart format lib test

# Apply auto-fixes
dart fix --apply
```

## Architecture

### Workspace Structure

This project is part of a monorepo workspace:
- `user_app/` - This user-facing app
- `admin_panel/` - Separate admin application
- `common/` - Shared widgets and utilities package at `../common`
- `backend/openapi/` - OpenAPI specification

The workspace uses `resolution: workspace` in pubspec.yaml for dependency management.

### Shared Common Package

Reusable widgets and utilities are in `package:common` (located at `../common`). Always import from this package rather than duplicating code:

```dart
import 'package:common/widgets/button/button.dart';
import 'package:common/widgets/input/simple_fields.dart'; // AppTextField, AppDatePickField
import 'package:common/widgets/toast.dart';
import 'package:common/widgets/linear_indicator.dart';
import 'package:common/widgets/adaptive_root_scaffold/adaptive_root_scraffold.dart';
import 'package:common/utils/demensions.dart';
```

### Feature-Based Clean Architecture

Each feature follows this structure:
```
lib/features/<feature_name>/
├── data/              # Repositories and data sources
│   ├── datasouces/
│   │   └── remote/
│   │       └── *_remote_datasource.dart  # Interface + Impl + Mock
│   ├── *_impl.repository.dart
│   └── provider/
│       └── *.provider.dart
├── domain/            # Pure Dart business logic
│   ├── entities/
│   │   └── *.entity.dart
│   └── repositories/
│       └── *.repository.dart  # Abstract interfaces only
└── presentation/      # UI and view models
    ├── provider/
    │   └── *.provider.dart
    ├── screens/
    │   └── *.screen.dart
    └── widgets/
        └── *.widget.dart
```

Current features: `authenticate`, `home`, `onboarding`, `orders`, `profile`, `notifications`, `bot_chat`, `app`.

### Data Source Pattern

Every remote data source file (`*_remote_datasource.dart`) contains three parts:
1. **Abstract interface** - Defines the contract
2. **Implementation** - Real API integration (e.g., `ProductRemoteDataSourceImpl`)
3. **Mock class** - For testing with `Future.delayed` and fake data (e.g., `ProductRemoteDataSourceMock`)

Use a config flag in providers to switch between real and mock implementations.

### OpenAPI Integration

The app uses a generated OpenAPI client located at `./openapi` (local package `user_openapi`):

```dart
import 'package:user_openapi/model/partner_request_dto.dart';
```

When the backend OpenAPI spec changes at `../../backend/openapi/openapi.json`, regenerate the client.

## Routing

Uses `go_router` with type-safe routing via `go_router_builder`. Routes are defined in `lib/router/routes.dart`:

- Main shell route: `MobileWrapperRoutes` with bottom navigation (home, orders, chat, notifications, profile)
- Auth/onboarding routes: Splash, onboarding, sign-in, sign-up flow with survey steps
- All routes use `TypedGoRoute` with custom slide transitions via `_buildSlideTransitionPage`

After modifying routes, run code generation to update `routes.g.dart`.

## State Management

Uses Riverpod with code generation (`@riverpod` annotation). Key patterns:

```dart
// Provider with code generation
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => AuthState.initial();

  Future<void> signIn(String email, String password) async {
    final repo = ref.read(authRepositoryProvider);
    // ...
  }
}

// Consuming in widgets
final authState = ref.watch(authNotifierProvider);
```

## Code Generation Dependencies

The following require running `build_runner`:
- **Riverpod providers** - `@riverpod` annotations
- **Freezed models** - `@freezed` annotations for immutable data classes
- **JSON serialization** - `@JsonSerializable` with `fieldRename: FieldRename.snake`
- **Routes** - `TypedGoRoute` definitions (generates `routes.g.dart`)

## Key Conventions

### Naming
- Screens: `*.screen.dart` (e.g., `signin.screen.dart`)
- Widgets: `*.widget.dart` (e.g., `product_card.widget.dart`)
- Providers: `*.provider.dart`
- Entities: `*.entity.dart`
- Data sources: `*_remote_datasource.dart` or `*_local_datasource.dart`
- Repository implementations: `*_impl.repository.dart`

### Theming
- Always use `Theme.of(context).colorScheme.*` for colors
- Use `Theme.of(context).textTheme.*` for typography (e.g., `bodyMedium`, `displayLarge`)
- Use `Color.withValues(alpha: 0.5)` instead of deprecated `withOpacity()`
- Theme defined centrally (look for theme configuration in `lib/core/theme/` or similar)

### Immutability
- Use Freezed for domain entities and DTOs
- Prefer `const` constructors for widgets
- Apply `@JsonSerializable(fieldRename: FieldRename.snake)` for API models

### Assets
Located in `assets/`:
- `icons/` - Icon assets
- `images/` - Image assets
- `translations/` - Localization files
- `animations/` - Lottie animations
- `store.json` - App metadata

## Localization

Uses both `slang_flutter` and `easy_localization`. Translation files in `assets/translations/`.

## Testing Strategy

- **Unit tests** - For domain logic and data layer (use mock data sources)
- **Widget tests** - For UI components with `package:flutter_test`
- **Integration tests** - End-to-end flows with `package:integration_test`

Mock implementations are already part of data sources, so prefer using those over additional mocking libraries.

## Important Notes

- The domain layer must remain pure Dart (no Flutter dependencies)
- Never hardcode colors or text styles - always use theme
- Use the common package for shared widgets - check there first before creating new components
- Keep functions under 20 lines and line length under 80 characters
- Use meaningful variable names - avoid abbreviations
- Prefer composition over inheritance for widgets
- Use `ListView.builder` for dynamic lists (performance)
- Use `compute()` for expensive operations (isolates)
- Always handle errors with try-catch - no silent failures
- Use `dart:developer` logging instead of `print()`
