---
name: riverpod-mastery
description: Deep expertise in Riverpod state management for Flutter. Use when creating, refactoring, or debugging Riverpod providers, notifiers, and state patterns. Covers code generation, async state, caching, and advanced patterns.
---

# Riverpod Mastery

## When to Use
- Creating new Riverpod providers or notifiers.
- Debugging state management issues (stale state, rebuild loops, missing updates).
- Refactoring from manual providers to code generation.
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

### Basic Provider
```dart
@riverpod
Future<List<Product>> products(ref) async {
  final repo = ref.read(productRepositoryProvider);
  return repo.getAll();
}
```

### Notifier with Complex State
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
    ref.invalidateSelf();
  }
}
```

### Family Provider (Parameterized)
```dart
@riverpod
Future<Product> productById(ref, {required String id}) async {
  final repo = ref.read(productRepositoryProvider);
  return repo.getById(id);
}
```

## Consuming Patterns

### In Widgets
```dart
// Watch for reactive rebuilds (in build method)
final asyncProducts = ref.watch(productsProvider);
asyncProducts.when(
  data: (products) => ProductList(products: products),
  loading: () => const CircularProgressIndicator(),
  error: (err, stack) => ErrorWidget(err.toString()),
);

// Read for one-time access (in callbacks)
onPressed: () {
  ref.read(cartNotifierProvider.notifier).addItem(product);
}

// Listen for side effects (in build or initState equivalent)
ref.listen(authNotifierProvider, (prev, next) {
  if (next is _Error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next.message)),
    );
  }
});
```

### Combining Providers
```dart
@riverpod
Future<FilteredProducts> filteredProducts(ref) async {
  final products = await ref.watch(productsProvider.future);
  final filter = ref.watch(filterProvider);
  return products.where((p) => p.category == filter).toList();
}
```

## Common Pitfalls and Fixes

### Pitfall: Reading provider in build without watch
```dart
// WRONG: Won't rebuild when auth changes
final user = ref.read(authProvider);

// CORRECT: Rebuilds when auth changes
final user = ref.watch(authProvider);
```

### Pitfall: Infinite rebuild loops
```dart
// WRONG: Creates new object every build, triggering rebuilds
ref.watch(Provider((ref) => MyService()));

// CORRECT: Use code generation and stable references
@riverpod
MyService myService(ref) => MyService();
```

### Pitfall: Using ref after dispose
```dart
// WRONG: ref may be invalid after async gap
Future<void> doSomething() async {
  await someAsyncWork();
  ref.read(otherProvider); // May throw if disposed

// CORRECT: Check mounted or capture ref before async
  final otherNotifier = ref.read(otherProvider.notifier);
  await someAsyncWork();
  otherNotifier.doSomething();
}
```

## Async State Best Practices

- Use `AsyncValue.guard` for error handling:
  ```dart
  state = await AsyncValue.guard(() => repo.fetch());
  ```
- Use `ref.invalidateSelf()` to re-trigger build (refetch).
- Use `state = const AsyncLoading<T>().copyWithPrevious(state)` to keep previous data during loading.

## Testing Providers

```dart
test('products provider returns list', () async {
  final container = ProviderContainer(overrides: [
    productRepositoryProvider.overrideWithValue(
      MockProductRepository(),
    ),
  ]);
  addTearDown(container.dispose);

  final result = await container.read(productsProvider.future);
  expect(result, isNotEmpty);
});
```

## Checklist

- [ ] Using `@riverpod` code generation (not manual providers)
- [ ] `ref.watch` in build methods, `ref.read` in callbacks
- [ ] Proper error handling with `AsyncValue.guard` or try-catch
- [ ] State modeled with Freezed sealed classes for complex states
- [ ] `keepAlive: true` only for genuinely persistent state
- [ ] Generated `.g.dart` files are up to date
- [ ] No `ref` access after potential disposal in async code
