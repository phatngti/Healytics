---
trigger: glob
globs: ["*.dart"]
description: Dart language conventions and coding standards. Applied to all Dart files.
---

# Dart Conventions

## Naming Conventions

| Element              | Style        | Example                          |
|----------------------|-------------|----------------------------------|
| Classes/Enums/Types  | PascalCase  | `AuthNotifier`, `UserEntity`     |
| Variables/Functions  | camelCase   | `userName`, `fetchData()`        |
| Files                | snake_case  | `auth_session.provider.dart`     |
| Constants            | camelCase   | `defaultPadding`, `apiBaseUrl`   |
| Private members      | _camelCase  | `_isLoading`, `_handleTap()`     |

### File Naming by Type

- Screens: `*.screen.dart` (e.g., `signin.screen.dart`)
- Widgets: `*.widget.dart` (e.g., `product_card.widget.dart`)
- Providers: `*.provider.dart` (e.g., `auth.provider.dart`)
- Entities: `*.entity.dart` (e.g., `user.entity.dart`)
- Data sources: `*_remote_datasource.dart`
- Repositories: `*_impl.repository.dart`

## Code Structure

- **Functions:** Single purpose, under 20 lines.
- **Line length:** 80 characters max.
- **Imports:** Organize as dart:, package:, relative. Remove unused.
- **`const` constructors:** Use everywhere possible.
- **Prefer `final`** for local variables that don't change.

## Null Safety

- Write fully null-safe code.
- Avoid the `!` operator — use null-aware alternatives:
  ```dart
  // Prefer
  final name = user?.name ?? 'Unknown';
  if (user case final user?) { ... }

  // Avoid
  final name = user!.name;
  ```

## Modern Dart Features

- **Pattern matching:** Use exhaustive switch expressions.
  ```dart
  final label = switch (status) {
    Status.active => 'Active',
    Status.inactive => 'Inactive',
  };
  ```
- **Records:** For returning multiple values.
- **Arrow functions:** For single-expression bodies.
- **async/await:** Always prefer over raw Futures.

## Error Handling

- Always use try-catch — no silent failures.
- Throw typed exceptions, not strings.
- Use `dart:developer` for logging, never `print()`:
  ```dart
  import 'dart:developer' as developer;
  developer.log('Message', error: e, stackTrace: s);
  ```

## Documentation

- `///` doc comments for all public APIs.
- Single-sentence summary first, then details.
- Place doc comments before annotations.
- Explain "why", not "what" — the code shows "what".

## JSON Serialization

- Use `@JsonSerializable(fieldRename: FieldRename.snake)` for API models.
- Always provide `fromJson` factory and `toJson` method.
  ```dart
  @JsonSerializable(fieldRename: FieldRename.snake)
  class UserDto {
    final String firstName;
    final String lastName;

    UserDto({required this.firstName, required this.lastName});

    factory UserDto.fromJson(Map<String, dynamic> json) =>
        _$UserDtoFromJson(json);
    Map<String, dynamic> toJson() => _$UserDtoToJson(this);
  }
  ```
