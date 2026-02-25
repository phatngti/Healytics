---
trigger: glob
globs: ["**/*.provider.dart", "**/providers/**"]
description: Riverpod state management patterns and conventions. Applied to provider files and provider directories.
---

# Riverpod State Management Patterns

## Code Generation (Required)

Always use `@riverpod` annotations with code generation. Never write providers manually.

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'example.provider.g.dart';

// Simple provider (auto-dispose by default)
@riverpod
Future<List<Product>> products(ref) async {
  final repo = ref.read(productRepositoryProvider);
  return repo.getAll();
}

// Notifier (for mutable state)
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => AuthState.initial();

  Future<void> signIn(String email, String password) async {
    state = AuthState.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.signIn(email, password);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}
```

## Provider Types and When to Use

| Type | Use Case | Example |
|------|----------|---------|
| `@riverpod` function | Read-only data, computed values | Fetching a list, filtering |
| `@riverpod` class (Notifier) | Mutable state with methods | Auth state, form state |
| `@Riverpod(keepAlive: true)` | State that persists across screens | Session, app config |

## Consuming Providers in Widgets

```dart
// Watch (rebuilds on change) — use in build()
final state = ref.watch(authNotifierProvider);

// Read (one-time) — use in callbacks
ref.read(authNotifierProvider.notifier).signIn(email, password);

// Listen (side effects) — use for navigation, snackbars
ref.listen(authNotifierProvider, (prev, next) {
  if (next.isError) showSnackbar(next.errorMessage);
});
```

## Provider Organization

### Data layer providers (`features/<name>/data/provider/`)
- Repository providers that inject data sources.
- Switch between real and mock via config flag.

```dart
@riverpod
ProductRepository productRepository(ref) {
  final api = ref.read(apiServiceProvider);
  final useMock = ref.read(useMockProvider);
  final dataSource = useMock
      ? ProductRemoteDataSourceMock()
      : ProductRemoteDataSourceImpl(api);
  return ProductRepositoryImpl(dataSource);
}
```

### Presentation layer providers (`features/<name>/presentation/providers/`)
- Notifiers that manage screen/feature state.
- Call domain repositories, never data sources directly.

## State Modeling

Use Freezed sealed classes for complex states:

```dart
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.error(String message) = _Error;
}
```

Handle with pattern matching in widgets:

```dart
switch (authState) {
  _Initial() => const LoginForm(),
  _Loading() => const CircularProgressIndicator(),
  _Authenticated(:final user) => HomeScreen(user: user),
  _Error(:final message) => ErrorWidget(message),
}
```

## Rules

- Run `dart run build_runner build -d` after creating/modifying providers.
- Never access `ref` outside of `build()` or provider callbacks.
- Prefer `ref.watch` over `ref.read` in build methods.
- Keep notifier methods focused — delegate to repositories.
- Use `AsyncValue` helpers: `.when()`, `.whenData()`, `.hasError`.
