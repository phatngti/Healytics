---
trigger: always_on
description: Core Clean Architecture rules for the Healytics Flutter project. Enforces layer separation, folder structure, and dependency flow.
---

# Core Architecture

## Project Context

Healytics is a health and wellness platform. This is the `user_app` — a Flutter mobile/web app in a monorepo workspace:

```
healytic_fe/
├── user_app/       # This app
├── admin_panel/    # Admin application
└── common/         # Shared package (package:common)
```

The workspace uses `resolution: workspace` in pubspec.yaml.

## Architecture Pattern

**Clean Architecture + Riverpod** for state and dependency management.

**Dependency flow:** Presentation → Domain → Data (outer layers depend on inner ones, never the reverse).

## Folder Structure

```
lib/
├── core/                  # Shared app-wide concerns
│   ├── database/          # Drift DB entities and repos
│   ├── entities/          # Shared domain entities
│   ├── models/            # Shared data models
│   ├── providers/         # Core Riverpod providers (auth, api)
│   ├── repositories/      # Core repository interfaces
│   ├── services/          # Core services (api, log, store)
│   └── utils/             # Helpers, extensions
├── features/              # Feature modules
│   └── <feature_name>/
│       ├── data/
│       │   ├── datasources/remote/
│       │   │   └── *_remote_datasource.dart
│       │   ├── repositories/
│       │   │   └── *_impl.repository.dart
│       │   └── provider/
│       │       └── *.provider.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── *.entity.dart
│       │   └── repositories/
│       │       └── *.repository.dart
│       └── presentation/
│           ├── providers/
│           │   └── *.provider.dart
│           ├── screens/
│           │   └── *.screen.dart
│           └── widgets/
│               └── *.widget.dart
├── gen/                   # Generated code (assets, etc.)
├── hooks/                 # Flutter hooks
├── localization/          # Localization setup
├── preferences/           # Preferences management
├── router/                # GoRouter configuration
├── theme/                 # Theme configuration
└── utils/                 # Global utilities
```

Current features: `authenticate`, `home`, `onboarding`, `orders`, `profile`, `notifications`, `bot_chat`, `app`.

## Layer Rules

### Domain Layer (Pure Dart)
- Houses entities, repository interfaces, and business logic.
- **Zero Flutter imports.** No Riverpod, no HTTP clients.
- Entities use `@freezed` for immutability.
- Repository interfaces are abstract classes only.
- Naming: `*.entity.dart`, `*.repository.dart`.

### Data Layer
- Implements domain repository interfaces.
- Each remote data source file contains 3 parts:
  1. **Abstract interface** (contract)
  2. **Implementation class** (real API via `user_openapi`)
  3. **Mock class** (with `Future.delayed` and fake data)
- Use a config flag in providers to switch real/mock.
- Complex mock data goes in separate `*_mock_data.dart` files.
- Naming: `*_remote_datasource.dart`, `*_impl.repository.dart`.

### Presentation Layer
- Widgets, screens, and Riverpod providers/notifiers.
- Notifiers call domain repositories via providers.
- Keep widgets focused on UI only — no business logic.
- Naming: `*.screen.dart`, `*.widget.dart`, `*.provider.dart`.

## Shared Common Package

Always check `package:common` before creating new shared widgets:

```dart
import 'package:common/widgets/button/button.dart';
import 'package:common/widgets/input/simple_fields.dart';
import 'package:common/widgets/toast.dart';
import 'package:common/widgets/linear_indicator.dart';
import 'package:common/utils/demensions.dart';
```

## OpenAPI Integration

Generated client at `./openapi` (package `user_openapi`):

```dart
import 'package:user_openapi/model/partner_request_dto.dart';
```

Regenerate when backend spec changes at `../../backend/openapi/openapi.json`.

## SOLID Principles

Apply throughout: single responsibility per class, open for extension, depend on abstractions. Prefer composition over inheritance.
