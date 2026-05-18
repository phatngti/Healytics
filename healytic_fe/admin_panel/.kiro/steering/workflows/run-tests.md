---
inclusion: manual
---

# Workflow: Run Tests

Executes tests following the project's testing strategy with proper coverage and reporting.

## Steps

1. **Identify test scope:** Determine what needs testing based on recent changes:
   - Domain logic changes → unit tests
   - Data layer changes → unit tests with mock data sources
   - UI changes → widget tests
   - Flow changes → integration tests

2. **Run all tests:**
   ```bash
   flutter test
   ```

3. **Run specific test file:**
   ```bash
   flutter test test/features/<feature>/presentation/<test_file>.dart
   ```

4. **Run with coverage:**
   ```bash
   flutter test --coverage
   ```

5. **Analyze results:**
   - Review any failures carefully.
   - Check if failures are in new or existing tests.
   - For flaky tests, check for async timing issues.

6. **Fix failures:**
   - Update expected values if behavior intentionally changed.
   - Fix regressions if unintentional.
   - Ensure mock data sources match the current entity structure.

7. **Verify coverage:** Check that critical paths are covered:
   - Domain entity creation and validation.
   - Repository method calls with success and error cases.
   - Widget rendering with different states (loading, loaded, error).
   - User interaction handling (tap, input, navigation).

## Test File Structure
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

## Writing New Tests

Follow AAA pattern (Arrange-Act-Assert):

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

    test('getProducts returns list', () async {
      // Arrange — setUp handles this

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result, isNotEmpty);
      expect(result.first, isA<ProductEntity>());
    });
  });
}
```
