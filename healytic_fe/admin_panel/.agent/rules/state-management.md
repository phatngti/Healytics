---
trigger: always_on
---

# ARCHITECTURE & STATE MANAGEMENT (STRICT)

## 1. ARCHITECTURE PATTERN
**Pattern:** Clean Architecture + Riverpod.
**Dependency Flow:** `Presentation` -> `Datasource` -> `Domain`.
**Folder Structure:** Feature-based.
`lib/features/<feature>/` -> `domain/`, `datasource/`, `presentation/`.

## 2. LAYER RULES (MANDATORY)

### A. Domain Layer (Pure Dart)
- **Role:** Business logic, Entities, Repository Interfaces.
- **Constraints:** NO dependencies on Flutter UI, Riverpod, or HTTP clients.
- **Entities:** Use `freezed` with `sealed` classes for unions.
- **Naming:** `*.entity.dart`, `*.repository.dart`, `*.request.dart`.

### B. Datasource Layer (Data & Mocking Strategy)
**CRITICAL RULE:** Every datasource file (`*_remote.datasource.dart`) MUST contain 3 distinct classes and specific provider logic.

**1. File Structure:**
   - **Abstract Interface:** Defines the contract (e.g., `ProductRemoteDataSource`).
   - **Implementation (`Impl`):** Real API calls using `admin_openapi` (e.g., `ProductRemoteDataSourceImpl`).
   - **Mock Class (`Mock`):** Fake data with delays (e.g., `ProductRemoteDataSourceMock`).

**2. Implementation Rules:**
   - **Impl Class:**
     - Must inject `ApiService`.
     - Must map `admin_openapi` DTOs -> Domain Entities.
     - **Strict:** Handle `null` responses from generated API clients.
   - **Mock Class:**
     - Must implement the Abstract Interface.
     - Must use `Future.delayed` (e.g., 1s) to simulate network latency.

**3. Mock Data Storage Rules:**
   - **Complex Data (>10 lines):** MUST extract to a separate file in `datasource/data/`.
     - *Path:* `lib/features/<feature>/datasource/data/<name>_mock_data.dart`.
     - *Format:* Use `const`/`final` Dart variables. DO NOT use `.json` files.
   - **Simple Data:** Define inline within the Mock class methods.

**4. Provider Logic (Switching):**
   - The Riverpod provider **MUST** check `Store.get(StoreKey.mockFlag, false)` to determine which implementation to return.

### C. Presentation Layer (UI & State)
- **Role:** UI Widgets, State Management.
- **State:** Use `riverpod_annotation` (`@riverpod`).
- **Logic:** Controllers/Notifiers call Repositories (via Providers).
- **Naming:** `*.provider.dart`, `*.screen.dart`, `*.widget.dart`.

## 3. CODING STANDARDS & GENERATION

### Code Generation
- **Entities:** `@Freezed(toJson: true)`
- **Providers:** `@riverpod` (Avoid manual `Provider` definitions).
- **Command:** `dart run build_runner build -d`

### File Naming Conventions
| Type | Suffix | Example |
|---|---|---|
| Entity | `*.entity.dart` | `employee.entity.dart` |
| Repo Interface | `*.repository.dart` | `employee.repository.dart` |
| Repo Impl | `*_implement.repository.dart` | `employee_implement.repository.dart` |
| Provider | `*.provider.dart` | `employee.provider.dart` |
| Request Model | `*.request.dart` | `create_employee.request.dart` |
| Datasource | `*_remote.datasource.dart` | `employee_remote.datasource.dart` |
| Mock Data File | `*_mock_data.dart` | `employee_mock_data.dart` |
## 4. EXAMPLE IMPLEMENTATION

❌ **BAD (REJECT):**
```dart
// domain/user_repo.dart
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ERROR: Domain depends on Riverpod

// datasource/product_remote.datasource.dart
class ProductRemoteDataSource { // ERROR: Missing Interface/Impl/Mock split
  final ApiService api;
  ProductRemoteDataSource(this.api);
  Future<List<Product>> get() => api.getProducts(); 
}

@riverpod
ProductRemoteDataSource productRemoteDataSource(Ref ref) {
  return ProductRemoteDataSource(ref.read(apiServiceProvider)); // ERROR: No Mock Switching
}
```
✅ **GOOD (APPROVE):**
```dart
/ --- domain/product.entity.dart ---
@freezed
class ProductEntity with _$ProductEntity { ... }

// --- datasource/product_remote.datasource.dart ---
// 1. Abstract
abstract class ProductRemoteDataSource {
  Future<Product> getById(String id);
}

// 2. Implementation
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService apiService;
  ProductRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Product> getById(String id) async {
    final response = await apiService.productsApi.find(id);
    return ProductEntity.fromDto(response!); // Map DTO -> Entity
  }
}

// 3. Mock
class ProductRemoteDataSourceMock implements ProductRemoteDataSource {
  @override
  Future<Product> getById(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return Product(id: 'mock-1', name: 'Mock Product');
  }
}

// 4. Provider with Switch
@riverpod
ProductRemoteDataSource productRemoteDataSource(Ref ref) {
  // Requires: import 'package:admin_panel/core/entities/store.entity.dart';
  // Requires: import 'package:admin_panel/core/models/store.model.dart';
  final isMock = Store.get(StoreKey.mockFlag, false);
  if (isMock) return ProductRemoteDataSourceMock();
  
  final apiService = ref.read(apiServiceProvider);
  return ProductRemoteDataSourceImpl(apiService: apiService);
}

// --- datasource/product_implement.repository.dart ---
@riverpod
ProductRepository productRepository(Ref ref) {
  return ProductImplementRepository(dataSource: ref.read(productRemoteDataSourceProvider));
}

// --- presentation/product.provider.dart ---
@riverpod
class ProductNotifier extends _$ProductNotifier {
  Future<void> fetch(String id) async {
     state = AsyncValue.data(await ref.read(productRepositoryProvider).getById(id));
  }
}
```