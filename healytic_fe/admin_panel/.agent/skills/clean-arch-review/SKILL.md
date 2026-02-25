---
name: clean-arch-review
description: Reviews Flutter code for Clean Architecture compliance. Use when reviewing PRs, refactoring code, or validating that a feature follows the project's layered architecture correctly. Checks layer boundaries, dependency direction, and naming conventions.
---

# Clean Architecture Code Review

## When to Use
- Reviewing pull requests for architecture compliance.
- Auditing an existing feature for layer violations.
- Before merging a new feature to validate structure.
- When refactoring to improve separation of concerns.
- When onboarding to understand if code follows conventions.

## Review Checklist

### 1. Layer Boundaries

**Domain Layer (lib/features/<name>/domain/)**

- [ ] Contains ONLY entities and repository interfaces
- [ ] Zero imports from `package:flutter/*`
- [ ] Zero imports from `package:riverpod*`
- [ ] Zero imports from `package:user_openapi/*`
- [ ] Zero imports from data or presentation layers
- [ ] Entities use `@freezed` for immutability
- [ ] Repository interfaces are abstract classes only (no implementation)

**Red flags:**
```dart
// VIOLATION: Flutter import in domain
import 'package:flutter/material.dart';

// VIOLATION: Riverpod in domain
import 'package:riverpod_annotation/riverpod_annotation.dart';

// VIOLATION: Direct API client in domain
import 'package:user_openapi/model/user_dto.dart';
```

### 2. Data Layer (lib/features/<name>/data/)

- [ ] Implements domain repository interfaces
- [ ] Remote data source has 3 parts: interface, impl, mock
- [ ] DTOs from `user_openapi` are mapped to domain entities HERE (not in domain or presentation)
- [ ] Mock class uses `Future.delayed` for realistic async behavior
- [ ] Complex mock data in separate `*_mock_data.dart` files
- [ ] Provider switches between real/mock via config flag

**Red flags:**
```dart
// VIOLATION: Exposing DTO to presentation
// In repository impl
Future<UserDto> getUser() => _api.getUser(); // Should return UserEntity

// VIOLATION: Missing mock class in data source file
// Only has abstract + impl, no mock
```

### 3. Presentation Layer (lib/features/<name>/presentation/)

- [ ] Screens use `ConsumerWidget` or `HookConsumerWidget`
- [ ] No direct business logic in widgets (delegated to notifiers)
- [ ] Colors from `Theme.of(context).colorScheme.*`
- [ ] Typography from `Theme.of(context).textTheme.*`
- [ ] `const` constructors wherever possible
- [ ] No data fetching in widgets — done through providers

**Red flags:**
```dart
// VIOLATION: Business logic in widget
onPressed: () async {
  final response = await http.get(Uri.parse('/api/users'));
  // ... processing
}

// VIOLATION: Hardcoded color
color: Colors.blue // Should use Theme

// VIOLATION: Hardcoded text style
style: TextStyle(fontSize: 14) // Should use Theme.textTheme
```

### 4. Dependency Direction

The flow must be: **Presentation → Domain ← Data**

- [ ] Presentation imports domain entities (NOT data layer DTOs)
- [ ] Data layer imports domain interfaces (implements them)
- [ ] Domain imports NOTHING from data or presentation
- [ ] No circular dependencies between features

### 5. Naming Conventions

- [ ] Screens: `*.screen.dart`
- [ ] Widgets: `*.widget.dart`
- [ ] Providers: `*.provider.dart`
- [ ] Entities: `*.entity.dart`
- [ ] Data sources: `*_remote_datasource.dart`
- [ ] Repository impls: `*_impl.repository.dart`
- [ ] All file names snake_case

### 6. Provider Architecture

- [ ] Using `@riverpod` code generation
- [ ] Data providers in `data/provider/`
- [ ] Presentation providers in `presentation/providers/`
- [ ] Repository providers instantiate repo with mock switching
- [ ] Notifiers call repositories, not data sources directly

## Common Refactoring Patterns

### Extract Business Logic from Widget
```dart
// Before: Logic in widget
onPressed: () {
  if (items.length > 10) { showError(); return; }
  final total = items.fold(0, (sum, i) => sum + i.price);
  // ... more logic
}

// After: Logic in notifier
onPressed: () =>
    ref.read(cartNotifierProvider.notifier).checkout(),
```

### Fix Layer Violation (DTO in Presentation)
```dart
// Before: DTO in presentation
final UserDto user = ref.watch(userProvider);
Text(user.first_name); // Raw DTO field

// After: Entity in presentation
final UserEntity user = ref.watch(userProvider);
Text(user.firstName); // Clean entity field
```

## How to Run Review

1. List all files in the feature: `lib/features/<name>/`
2. Check each file against the layer it belongs to.
3. Verify imports respect dependency direction.
4. Check naming conventions match.
5. Report violations with file paths and line numbers.
6. Suggest specific fixes for each violation.
