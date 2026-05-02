---
name: riverpod-mastery
description: Deep expertise in Riverpod 3.0 state management for Flutter. Use when creating, refactoring, or debugging Riverpod providers, notifiers, and state patterns. Covers code generation, async state, caching, automatic retry, mutations, and advanced patterns.
---

# Riverpod 3.0 Mastery

## When to Use
- Creating new Riverpod providers or notifiers.
- Debugging state management issues (stale state, rebuild loops, missing updates).
- Refactoring from Riverpod 2.x to 3.0 patterns.
- Implementing complex async state flows (pagination, optimistic updates, caching).
- Choosing between provider types for a use case.
- Reviewing provider architecture for best practices.

## Provider Decision Matrix

| Scenario | Provider Type | Annotation |
|----------|--------------|------------|
| Fetch data once | Function provider | `@riverpod` |
| Computed/derived value | Function provider | `@riverpod` |
| Mutable UI state | Class notifier | `@riverpod class` |
| Global persistent state | Class notifier | `@Riverpod(keepAlive: true)` |
| Family (parameterized) | Function/Class with params | Add parameter to `build()` |

## Code Generation Patterns

### Basic Provider (Unified `Ref`)
```dart
// In 3.0, always use `Ref` — no more typed refs
@riverpod
Future<List<Product>> products(Ref ref) async {
  final repo = ref.read(productRepositoryProvider);
  return repo.getAll();
}
```

### Notifier with `ref.mounted`
```dart
@riverpod
class ProductListNotifier extends _$ProductListNotifier {
  @override
  FutureOr<List<Product>> build() => _fetch();

  Future<List<Product>> _fetch() async {
    final repo = ref.read(productRepositoryProvider);
    return repo.getAll();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> addProduct(Product product) async {
    final repo = ref.read(productRepositoryProvider);
    await repo.create(product);
    // Always check mounted after await
    if (!ref.mounted) return;
    ref.invalidateSelf();
  }
}
```

### Family Provider (Parameterized)
```dart
@riverpod
Future<Product> productById(
  Ref ref,
  {required String id},
) async {
  final repo = ref.read(productRepositoryProvider);
  return repo.getById(id);
}
```

### Generic Provider (New in 3.0)
```dart
@riverpod
T multiply<T extends num>(T a, T b) {
  return a * b;
}
// Usage:
// ref.watch(multiplyProvider<int>(2, 3))
// ref.watch(multiplyProvider<double>(2.5, 3.5))
```

## Consuming Patterns

### In Widgets — Sealed AsyncValue Pattern Matching
```dart
// AsyncValue is now sealed — use exhaustive matching
final asyncProducts = ref.watch(productsProvider);
return switch (asyncProducts) {
  AsyncData(:final value) =>
    ProductList(products: value),
  AsyncError(:final error) =>
    ErrorWidget(error.toString()),
  AsyncLoading() =>
    const CircularProgressIndicator(),
};
```

### Watch / Read / Listen
```dart
// Watch for reactive rebuilds (in build method)
final state = ref.watch(productsProvider);

// Read for one-time access (in callbacks)
onPressed: () {
  ref.read(cartNotifierProvider.notifier)
    .addItem(product);
}

// Listen for side effects
ref.listen(authNotifierProvider, (prev, next) {
  if (next is _Error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next.message)),
    );
  }
});

// Pause/Resume listeners (new in 3.0)
final sub = ref.listen(
  todoListProvider,
  (previous, next) { /* ... */ },
);
sub.pause();
sub.resume();
```

### Combining Providers
```dart
@riverpod
Future<FilteredProducts> filteredProducts(
  Ref ref,
) async {
  final products = await ref.watch(
    productsProvider.future,
  );
  final filter = ref.watch(filterProvider);
  return products
    .where((p) => p.category == filter)
    .toList();
}
```

## AsyncValue Changes (3.0)

| Old (2.x) | New (3.0) |
|-----------|-----------|
| `.valueOrNull` | `.value` (renamed) |
| `.when(data:, error:, loading:)` | `switch` pattern matching (preferred) |
| Not sealed | Sealed — exhaustive matching |
| No progress | `AsyncLoading(progress: 0.5)` |
| No cache flag | `.isFromCache` for offline persistence |

### Progress Tracking
```dart
@riverpod
class UploadNotifier extends _$UploadNotifier {
  @override
  Future<UploadResult> build() async { ... }

  Future<void> upload(File file) async {
    state = AsyncLoading(progress: 0.0);
    await uploadChunk1();
    if (!ref.mounted) return;
    state = AsyncLoading(progress: 0.5);
    await uploadChunk2();
    if (!ref.mounted) return;
    state = AsyncData(UploadResult.success());
  }
}
```

## Automatic Retry (3.0)

Providers that fail during init automatically retry
with exponential backoff (200ms → 6.4s). Customize:

```dart
// Per-provider (code generation)
Duration retry(int retryCount, Object error) {
  if (retryCount > 3) return null;
  return Duration(seconds: retryCount * 2);
}

@Riverpod(retry: retry)
Future<List<Product>> products(Ref ref) async {
  return ref.read(productRepositoryProvider).getAll();
}

// Globally on ProviderScope
ProviderScope(
  retry: (retryCount, error) {
    if (error is ProviderException) return null;
    if (retryCount > 5) return null;
    return Duration(seconds: retryCount * 2);
  },
  child: MyApp(),
)
```

## Mutations (Experimental)

Track side-effect status (loading/success/error):

```dart
final submitOrderMutation = Mutation<void>();

// In widget:
final mutation = ref.watch(submitOrderMutation);
return switch (mutation) {
  MutationIdle() => ElevatedButton(
    onPressed: () {
      submitOrderMutation.run(ref, (tsx) async {
        await tsx.get(orderProvider.notifier)
          .submit(orderData);
      });
    },
    child: const Text('Submit'),
  ),
  MutationPending() =>
    const CircularProgressIndicator(),
  MutationError() => ElevatedButton(
    onPressed: () { /* retry */ },
    child: const Text('Retry'),
  ),
  MutationSuccess() =>
    const Text('Order placed!'),
};
```

## Error Handling: `ProviderException`

Errors from provider reads are wrapped in
`ProviderException` (better stack traces + origin tracking):

```dart
try {
  ref.watch(failingProvider);
} on ProviderException catch (e) {
  switch (e.exception) {
    case SomeSpecificError():
      // Handle
    default:
      rethrow;
  }
}
```

`AsyncValue.error`, `ref.listen`, and `ProviderObserver`
still receive the original unaltered error.

## Common Pitfalls and Fixes

### Pitfall: Using old typed Ref
```dart
// WRONG (2.x): Typed ref
Example example(ExampleRef ref) { ... }

// CORRECT (3.0): Unified Ref
Example example(Ref ref) { ... }
```

### Pitfall: Not checking mounted after async
```dart
// WRONG: ref may be invalid after await
Future<void> doSomething() async {
  await someAsyncWork();
  state = newState; // May throw!

// CORRECT: Check ref.mounted
  await someAsyncWork();
  if (!ref.mounted) return;
  state = newState;
}
```

### Pitfall: Reading provider in build
```dart
// WRONG: Won't rebuild when auth changes
final user = ref.read(authProvider);

// CORRECT: Rebuilds when auth changes
final user = ref.watch(authProvider);
```

### Pitfall: Using valueOrNull (removed)
```dart
// WRONG (2.x)
final val = asyncValue.valueOrNull;

// CORRECT (3.0)
final val = asyncValue.value;
```

## Testing Providers (3.0)

```dart
test('products provider returns list', () async {
  // ProviderContainer.test auto-disposes after test
  final container = ProviderContainer.test(
    overrides: [
      productRepositoryProvider.overrideWithValue(
        ProductRepositoryImpl(
          ProductRemoteDataSourceMock(),
        ),
      ),
    ],
  );

  final result = await container.read(
    productsProvider.future,
  );
  expect(result, isNotEmpty);
});

// Override only build() — keep notifier methods
final container = ProviderContainer.test(
  overrides: [
    myNotifierProvider.overrideWithBuild((ref) {
      return 42; // Custom initial state
    }),
  ],
);

// Override Future/Stream with a value
final container = ProviderContainer.test(
  overrides: [
    myFutureProvider.overrideWithValue(
      AsyncValue.data(42),
    ),
  ],
);
```

## Weak Listeners (Advanced)

Listen without preventing auto-dispose:

```dart
ref.listen(
  anotherProvider,
  weak: true,
  (previous, next) { /* ... */ },
);
```

## Lifecycle Listeners (Removable)

All `ref.onDispose`, `ref.onCancel`, etc. now return
a removal function:

```dart
final removeListener = ref.onDispose(() {
  // cleanup
});
// Can remove early if needed:
removeListener();
```

## Checklist

- [ ] Using `@riverpod` code generation
- [ ] Unified `Ref ref` in all function providers
- [ ] `ref.watch` in build, `ref.read` in callbacks
- [ ] `ref.mounted` check after every `await`
- [ ] Sealed `AsyncValue` pattern matching (switch)
- [ ] `.value` not `.valueOrNull`
- [ ] `AsyncValue.guard` or try-catch for errors
- [ ] State modeled with Freezed sealed classes
- [ ] `keepAlive: true` only for persistent state
- [ ] Generated `.g.dart` files up to date
- [ ] No legacy `StateProvider`/`StateNotifierProvider`
