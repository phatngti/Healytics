---
trigger: always_on
---

# Scope A: Core Architecture

As a Senior Flutter Architect, this scope outlines the foundational architecture for professional Flutter projects. Adopt Clean Architecture to ensure separation of concerns, scalability, and testability. Use Riverpod for state management and dependency injection, as it provides type-safe, composable providers without boilerplate. Organize code in a feature-based structure to promote modularity. This approach allows new developers to quickly understand and contribute to the project by focusing on isolated features.

## Architecture Pattern
- **Pattern:** Clean Architecture combined with Riverpod for state and dependency management.
- **Dependency Flow:** Presentation → Domain → Data (ensuring outer layers depend on inner ones).
- **Folder Structure:** Use a feature-based organization under `lib/features/<feature_name>/`, with subfolders for layers: `domain/`, `data/`, `presentation/`. For shared utilities, use `lib/core/` (e.g., utilities, extensions, common models). Assume a standard Flutter structure with `lib/main.dart` as the entry point.
  - Example:
    ```
    lib/
    ├── core/
    │   ├── entities/
    │   ├── repositories/
    │   └── utilities/
    ├── features/
    │   ├── authentication/
    │   │   ├── data/
    │   │   ├── domain/
    │   │   └── presentation/
    │   └── products/
    │       ├── data/
    │       ├── domain/
    │       └── presentation/
    └── main.dart
    ```
- **Shared Common Package:** Reusable widgets and utilities are located in the `common` package at the workspace root (`../common`). Import shared components using `package:common/...`:
  ```dart
  // Shared widgets 
  import 'package:common/widgets/button/button.dart';
  import 'package:common/widgets/input/simple_fields.dart'; // AppTextField, AppDatePickField
  import 'package:common/widgets/toast.dart';
  import 'package:common/widgets/linear_indicator.dart';
  import 'package:common/widgets/adaptive_root_scaffold/adaptive_root_scraffold.dart';
  
  // Shared utilities
  import 'package:common/utils/demensions.dart';
  ```
- **Separation of Concerns:** Aim for patterns like MVC/MVVM, with defined Model (data/domain), View (presentation), and ViewModel/Controller roles. Separate UI logic from business logic.

## Layer Rules
### Domain Layer (Pure Dart)
- **Role:** Houses business logic, entities, use cases, and repository interfaces. This layer is platform-agnostic and focuses on core domain rules.
- **Constraints:** No dependencies on Flutter, Riverpod, or external services (e.g., HTTP clients). Keep it testable in isolation.
- **Entities and Models:** Use Freezed for immutable data classes with union types (e.g., `@freezed` with `sealed` for success/failure states). Include serialization if needed (e.g., `toJson: true`). Prefer immutable data structures.
- **Naming Conventions:** 
  - Entities: `*.entity.dart` (e.g., `product.entity.dart`).
  - Repository Interfaces: `*.repository.dart` (e.g., `product.repository.dart`).
  - Request/Response Models: `*.request.dart` or `*.response.dart`.
- **Data Flow:** Define data structures (classes) to represent application data. Abstract data sources using repositories/services for testability.

### Data Layer (Repositories and Data Sources)
- **Role:** Implements repository interfaces from the domain layer. Handles data fetching, mapping, and persistence (e.g., API calls, databases).
- **Structure per Data Source File:** For remote data sources (e.g., `*_remote.datasource.dart`), include:
  1. **Abstract Interface:** Defines the contract (e.g., `ProductRemoteDataSource`).
  2. **Implementation Class:** Real logic (e.g., `ProductRemoteDataSourceImpl`), injecting services like API clients. Map external DTOs to domain entities, handling nulls and errors.
  3. **Mock Class:** For testing (e.g., `ProductRemoteDataSourceMock`), simulating delays (e.g., `Future.delayed`) and fake data.
- **Mock Data Handling:** 
  - Simple data: Inline in mock methods.
  - Complex data: Extract to separate files (e.g., `data/<name>_mock_data.dart`) using const/final variables.
- **Repository Implementation:** Place in `*_impl.repository.dart`. Use Riverpod providers to instantiate repositories, injecting data sources.
- **Provider Switching:** In providers, use a flag (e.g., from a config store) to switch between real and mock implementations for testing/debugging.
- **Naming Conventions:**
  - Data Sources: `*_remote.datasource.dart` (e.g., `product_remote.datasource.dart`).
  - Repository Implementations: `*_impl.repository.dart`.
  - Providers: `*.provider.dart`.
- **Data Handling & Serialization:** Use `json_serializable` and `json_annotation` for JSON. Apply `fieldRename: FieldRename.snake` for field renaming.
  ```dart
  // Example model
  import 'package:json_annotation/json_annotation.dart';

  part 'user.g.dart';

  @JsonSerializable(fieldRename: FieldRename.snake)
  class User {
    final String firstName;
    final String lastName;

    User({required this.firstName, required this.lastName});

    factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
    Map<String, dynamic> toJson() => _$UserToJson(this);
  }
  ```

### Presentation Layer (UI and Logic)
- **Role:** Contains widgets, screens, and view models/controllers. Handles UI rendering and user interactions. Widgets are for UI; compose complex UIs from smaller, reusable widgets.
- **State Management:** Use Riverpod with `@riverpod` annotations for providers and notifiers. Separate ephemeral and app state. For simple cases, use built-ins like `ValueNotifier` with `ValueListenableBuilder`, `ChangeNotifier` with `ListenableBuilder`, `Streams` with `StreamBuilder`, or `Futures` with `FutureBuilder`. Prioritize Riverpod for consistency.
  ```dart
  // ValueNotifier example
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  ValueListenableBuilder<int>(
    valueListenable: _counter,
    builder: (context, value, child) => Text('Count: $value'),
  );
  ```
- **Logic Separation:** Notifiers/controllers call domain repositories via providers. Keep widgets focused on UI, using hooks or builders for state.
- **Naming Conventions:**
  - Screens: `*.screen.dart` (e.g., `product_list.screen.dart`).
  - Widgets: `*.widget.dart` (e.g., `product_card.widget.dart`).
  - Providers/Notifiers: `*.provider.dart` (e.g., `product.provider.dart`).
- **Dependency Injection:** Use manual constructor injection; enhance with Riverpod's `ref.read/watch`. If requested, use `provider` package.

## Code Generation and Best Practices
- **Code Generation:** Annotate with `@riverpod` or `@Freezed`. Run `dart run build_runner build -d`. Ensure `build_runner` is a dev dependency.
- **API Design:** Design intuitive APIs with user perspective; include clear documentation and examples.
- **SOLID Principles:** Apply throughout for maintainable code.

This architecture ensures loose coupling, easy testing, and scalability. New developers should start by identifying the feature, then navigate layers inward from presentation.
