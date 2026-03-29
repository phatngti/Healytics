# Healytics — User App

The **user-facing mobile application** for the Healytics health & wellness
platform. Built with **Flutter**, following **Clean Architecture** and
**Riverpod 3.0** for state management.

## Project Goal

Healytics aims to **simplify access to healthcare services** by providing
a unified mobile platform where users can:

- **Discover** health & wellness services and browse service categories
- **Find** qualified healthcare providers and view their profiles,
  specialties, and certifications
- **Book** appointments seamlessly and track their status
  (upcoming, completed, canceled)
- **Chat** with an AI-powered assistant (Dr. AI) for health guidance
  and service recommendations
- **Manage** their health profile, preferences, and notification settings

The app serves as the patient/consumer side of the Healytics ecosystem,
complementing the admin panel used by platform operators.

## Monorepo Structure

```
healytic_fe/
├── user_app/       ← this app
├── admin_panel/    Admin dashboard
└── common/         Shared UI & logic (package:common)
```

## Features

| Feature           | Description                              |
| ----------------- | ---------------------------------------- |
| **Authentication** | Sign-in / sign-up with JWT sessions     |
| **Onboarding**    | First-launch walkthrough                 |
| **Home**          | Dashboard with quick actions & services  |
| **Orders**        | Appointment booking & status tracking    |
| **Employee**      | Health-care provider profiles            |
| **Bot Chat**      | AI-powered Dr. AI assistant (SSE)        |
| **Checkout**      | Service checkout flow                    |
| **Profile**       | User account management                 |
| **Notifications** | Push & in-app notifications              |

## Tech Stack

- **Flutter** (SDK ^3.9.2) — cross-platform UI
- **Riverpod 3.0** + code generation — state management
- **Freezed** — immutable entities & sealed unions
- **GoRouter** — declarative routing with code generation
- **Drift** — local SQLite database
- **OpenAPI** (`user_openapi`) — generated API client
- **ShadCN UI** + **Flex Color Scheme** — design system

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.9.2
- Dart SDK ≥ 3.9.2

### Install Dependencies

```bash
flutter pub get
```

### Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Run the App

```bash
flutter run
```

### Lint & Format

```bash
dart analyze
dart format lib test
dart fix --apply
```

### Run Tests

```bash
flutter test
```

## Architecture

The app follows **Clean Architecture** with three layers:

```
Presentation → Domain → Data
```

Each feature lives under `lib/features/<name>/` with `data/`,
`domain/`, and `presentation/` sub-folders. Shared concerns
(auth, API, database, utils) are in `lib/core/`.

## Resources

- [Flutter documentation](https://docs.flutter.dev/)
- [Riverpod documentation](https://riverpod.dev/)
- [Freezed documentation](https://pub.dev/packages/freezed)
