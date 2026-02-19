---
trigger: model_decision
description: Data layer patterns including data sources, repositories, API integration, and mock data. Apply when working on data fetching, API calls, or repository implementations.
---

# Data Layer Patterns

## Data Source Structure

Every remote data source file (`*_remote_datasource.dart`) contains exactly 3 parts:

```dart
// 1. Abstract Interface
abstract class ProductRemoteDataSource {
  Future<List<ProductEntity>> getProducts();
  Future<ProductEntity> getProductById(String id);
}

// 2. Implementation (real API)
class ProductRemoteDataSourceImpl
    implements ProductRemoteDataSource {
  final ApiService _api;

  ProductRemoteDataSourceImpl(this._api);

  @override
  Future<List<ProductEntity>> getProducts() async {
    final response = await _api.get('/products');
    return (response.data as List)
        .map((json) => ProductEntity.fromJson(json))
        .toList();
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    final response = await _api.get('/products/$id');
    return ProductEntity.fromJson(response.data);
  }
}

// 3. Mock (for testing and development)
class ProductRemoteDataSourceMock
    implements ProductRemoteDataSource {
  @override
  Future<List<ProductEntity>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockProductList; // from *_mock_data.dart
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockProductList.firstWhere((p) => p.id == id);
  }
}
```

## Mock Data

- **Simple data:** Inline in mock methods.
- **Complex data:** Extract to `*_mock_data.dart` files.
  ```dart
  // product_mock_data.dart
  final mockProductList = [
    ProductEntity(id: '1', name: 'Product A', price: 29.99),
    ProductEntity(id: '2', name: 'Product B', price: 49.99),
  ];
  ```

## Repository Implementation

```dart
// product_impl.repository.dart
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _dataSource;

  ProductRepositoryImpl(this._dataSource);

  @override
  Future<List<ProductEntity>> getProducts() =>
      _dataSource.getProducts();
}
```

## Provider with Mock Switching

```dart
@riverpod
ProductRepository productRepository(ref) {
  final useMock = ref.read(useMockProvider);
  final dataSource = useMock
      ? ProductRemoteDataSourceMock()
      : ProductRemoteDataSourceImpl(ref.read(apiServiceProvider));
  return ProductRepositoryImpl(dataSource);
}
```

## OpenAPI Client

The generated client is at `./openapi` (package `user_openapi`):

```dart
import 'package:user_openapi/model/product_dto.dart';
```

Map DTOs to domain entities in the data source implementation. Never expose DTOs to the domain or presentation layers.

## Error Handling in Data Layer

- Wrap API calls in try-catch.
- Transform API errors into domain-level exceptions.
- Let repositories propagate typed errors to presentation.
