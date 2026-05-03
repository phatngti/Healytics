---
name: flutter-testing
description: Comprehensive testing skill for Flutter apps using the project's mock data source pattern. Covers unit tests, widget tests, integration tests, and Riverpod 3.0 provider testing with ProviderContainer.test, overrideWithBuild, and WidgetTester.container.
---

# Flutter Testing (Riverpod 3.0)

## When to Use
- Writing tests for new features or bug fixes.
- Reviewing test coverage and quality.
- Debugging flaky or failing tests.
- Setting up test infrastructure for a new feature.
- Understanding how to test Riverpod providers.

## Test Organization

```
test/
├── features/
│   └── <feature_name>/
│       ├── data/
│       │   └── <feature>_repository_test.dart
│       ├── domain/
│       │   └── <feature>_entity_test.dart
│       └── presentation/
│           ├── <feature>_provider_test.dart
│           └── <feature>_screen_test.dart
└── core/
    └── ...
```

## Unit Tests (Domain & Data)

### Testing Entities
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:user_app/features/home/domain/entities/product.entity.dart';

void main() {
  group('ProductEntity', () {
    test('creates with required fields', () {
      const product = ProductEntity(
        id: '1',
        name: 'Test',
        price: 9.99,
      );
      expect(product.id, '1');
      expect(product.name, 'Test');
    });

    test('copyWith creates new instance', () {
      const original = ProductEntity(
        id: '1',
        name: 'Original',
        price: 9.99,
      );
      final updated = original.copyWith(name: 'Updated');
      expect(updated.name, 'Updated');
      expect(updated.id, '1'); // Unchanged
    });

    test('equality works correctly', () {
      const a = ProductEntity(id: '1', name: 'A', price: 1);
      const b = ProductEntity(id: '1', name: 'A', price: 1);
      expect(a, equals(b));
    });
  });
}
```

### Testing Repositories (using built-in mocks)
```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProductRepository', () {
    late ProductRemoteDataSourceMock mockDataSource;
    late ProductRepositoryImpl repository;

    setUp(() {
      mockDataSource = ProductRemoteDataSourceMock();
      repository = ProductRepositoryImpl(mockDataSource);
    });

    test('getProducts returns non-empty list', () async {
      final products = await repository.getProducts();
      expect(products, isNotEmpty);
      expect(products.first, isA<ProductEntity>());
    });

    test('getProductById returns correct item', () async {
      final product = await repository.getProductById('1');
      expect(product.id, '1');
    });
  });
}
```

**Important:** Use the project's built-in mock data source classes. They already exist in every `*_remote_datasource.dart` file. No need for mockito/mocktail unless testing edge cases the mock doesn't cover.

## Riverpod 3.0 Provider Tests

### `ProviderContainer.test` (auto-dispose)

Replaces manual `ProviderContainer` + `addTearDown(dispose)`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('ProductListNotifier', () {
    test('initial state loads products', () async {
      // Auto-disposes after test — no tearDown needed
      final container = ProviderContainer.test(
        overrides: [
          productRepositoryProvider.overrideWithValue(
            ProductRepositoryImpl(
              ProductRemoteDataSourceMock(),
            ),
          ),
        ],
      );

      final future = container.read(
        productListNotifierProvider.future,
      );
      final products = await future;
      expect(products, isNotEmpty);
    });

    test('refresh reloads data', () async {
      final container = ProviderContainer.test(
        overrides: [
          productRepositoryProvider.overrideWithValue(
            ProductRepositoryImpl(
              ProductRemoteDataSourceMock(),
            ),
          ),
        ],
      );

      final notifier = container.read(
        productListNotifierProvider.notifier,
      );
      await notifier.refresh();
      final state = container.read(
        productListNotifierProvider,
      );
      expect(state.hasValue, isTrue);
    });
  });
}
```

### `overrideWithBuild` — Mock Only `build()`

Mock the initial state without replacing the whole notifier:

```dart
test('notifier starts with custom state', () {
  final container = ProviderContainer.test(
    overrides: [
      myNotifierProvider.overrideWithBuild((ref) {
        // Custom initial state; methods still work
        return 42;
      }),
    ],
  );

  expect(container.read(myNotifierProvider), 42);
  // Notifier methods like increment() still function
  container.read(myNotifierProvider.notifier).increment();
  expect(container.read(myNotifierProvider), 43);
});
```

### `overrideWithValue` for Future/Stream Providers

```dart
test('override async provider with value', () {
  final container = ProviderContainer.test(
    overrides: [
      myFutureProvider.overrideWithValue(
        AsyncValue.data(42),
      ),
    ],
  );

  final state = container.read(myFutureProvider);
  expect(state.value, 42);
});
```

## Widget Tests

### Using `WidgetTester.container`

Access the `ProviderContainer` inside widget tests:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('ProductListScreen', () {
    testWidgets('shows loading then products', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            productRepositoryProvider.overrideWithValue(
              ProductRepositoryImpl(
                ProductRemoteDataSourceMock(),
              ),
            ),
          ],
          child: const MaterialApp(
            home: ProductListScreen(),
          ),
        ),
      );

      // Initially shows loading
      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );

      // Pump until async completes
      await tester.pumpAndSettle();

      // Shows products
      expect(find.byType(ProductCard), findsWidgets);

      // Access container for assertions
      final container = tester.container();
      final state = container.read(
        productListNotifierProvider,
      );
      expect(state.hasValue, isTrue);
    });

    testWidgets('tapping product navigates', (tester) async {
      // ... setup with mock navigator
      await tester.pumpWidget(/* ... */);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ProductCard).first);
      await tester.pumpAndSettle();

      // Verify navigation occurred
    });
  });
}
```

## Best Practices

- **AAA Pattern:** Arrange (setUp), Act (call method), Assert (expect).
- **Group related tests** with `group()`.
- **Use `ProviderContainer.test`** — no manual `dispose()` / `tearDown`.
- **Use `overrideWithBuild`** to test notifier methods with custom initial state.
- **Use `overrideWithValue`** for deterministic async provider states.
- **Test error paths** — not just happy paths.
- **Prefer built-in mocks** from data sources over mocking libraries.
- **Widget tests:** Always wrap in `MaterialApp` and `ProviderScope`.
- **Async tests:** Use `await tester.pumpAndSettle()` for animations and async.

## Running Tests

```bash
flutter test                                    # All tests
flutter test test/features/home/                # Feature tests
flutter test --coverage                         # With coverage
flutter test --name "should return products"    # By name
```

## Checklist

- [ ] Tests cover happy path and error cases
- [ ] Using project's built-in mock data sources
- [ ] Provider tests use `ProviderContainer.test` (not manual container)
- [ ] Using `overrideWithBuild` for notifier state mocking
- [ ] Widget tests wrapped in `MaterialApp` + `ProviderScope`
- [ ] `WidgetTester.container()` for in-test assertions
- [ ] Async operations properly awaited
- [ ] Test files follow naming: `*_test.dart`
- [ ] Tests in mirror structure under `test/`
