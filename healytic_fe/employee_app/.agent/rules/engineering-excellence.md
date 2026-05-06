---
trigger: always_on
description: Engineering standards for code quality, testing, linting, and documentation in the Healytics project.
---

# Engineering Excellence

## Code Quality Standards

- **Functions:** Single purpose, under 20 lines.
- **Line length:** 80 characters max.
- **Meaningful names:** No abbreviations (`userProfile` not `usrPrf`).
- **Prefer functional/declarative** patterns where appropriate.
- **Immutability:** Use Freezed for entities, `const` for widgets, `final` for locals.

## Testing Strategy

### Test Types
| Type | Target | Package |
|------|--------|---------|
| Unit | Domain logic, data layer, providers | `package:test` |
| Widget | UI components | `package:flutter_test` |
| Integration | End-to-end flows | `package:integration_test` |

### Test Pattern (AAA / Given-When-Then)
```dart
test('should return user when sign in succeeds', () async {
  // Arrange (Given)
  final mockDataSource = AuthRemoteDataSourceMock();
  final repo = AuthRepositoryImpl(mockDataSource);

  // Act (When)
  final result = await repo.signIn('test@email.com', 'pass');

  // Assert (Then)
  expect(result, isA<User>());
  expect(result.email, 'test@email.com');
});
```

### Testing Rules
- Use the project's built-in mock data sources (no need for extra mocking libraries).
- Test each layer independently.
- High coverage for domain and data layers.
- Widget tests should verify rendering and interaction.
- Run with: `flutter test` or specific file: `flutter test test/path/to_test.dart`.

## Linting and Formatting

- Config: `analysis_options.yaml` includes `package:flutter_lints/flutter.yaml`.
- Plugins: `custom_lint`, `riverpod_lint`.
- Commands:
  - `dart analyze` — check for lint issues.
  - `dart format lib test` — format code.
  - `dart fix --apply` — auto-fix.

## Error Handling

- **No silent failures** — always handle errors.
- Use try-catch with meaningful error types.
- Log with `dart:developer`, never `print()`.
- Propagate errors to UI via state (e.g., Freezed error states).

## Documentation

- `///` doc comments for all public APIs.
- Explain "why", not "what".
- Before annotations, not after.
- Use dartdoc-compatible Markdown.

## Code Generation

After modifying `@riverpod`, `@freezed`, `@JsonSerializable`, or `TypedGoRoute`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Watch mode for active development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Project-Specific Quality Checks

Beyond standard linting, verify:
- No Flutter imports in `domain/` layer files.
- No `print()` statements — use `dart:developer` `log()`.
- File naming follows conventions (`.screen.dart`, `.widget.dart`, `.provider.dart`, `.entity.dart`).
- Functions under 20 lines, line length under 80 chars.
- Shared widgets imported from `package:common/...` (not re-implemented).
- OpenAPI models from `package:user_openapi/...` (not hand-written DTOs).
- Network images use `NetworkImageAuto` from `package:common/...` (not `Image.network`, `NetworkImage`, or `CachedNetworkImage` directly).

## Git Practices

- Commit messages: imperative mood, concise subject line.
- Feature branches from `main`.
- PR reviews required before merge.
