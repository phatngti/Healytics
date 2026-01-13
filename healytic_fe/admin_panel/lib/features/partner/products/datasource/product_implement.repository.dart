import 'package:admin_panel/features/partner/products/datasource/remote_datasource.dart';
import 'package:admin_panel/features/partner/products/domain/category.entity.dart';
import 'package:admin_panel/features/partner/products/domain/create_product.request.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/product.repository.dart';
import 'package:admin_panel/features/partner/products/domain/update_product.request.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_implement.repository.g.dart';

class ProductImplementRepository implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductImplementRepository({required this.remoteDataSource});

  @override
  Future<List<Product>> getProducts(
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  ) async {
    return remoteDataSource.getProducts(startingAt, count, sortedBy, sortedAsc);
  }

  @override
  Future<int> getTotalRows() {
    return remoteDataSource.getTotalRows();
  }

  @override
  Future<Product> getProductById(ProductId id) {
    return remoteDataSource.getProductById(id);
  }

  @override
  Future<Product> createProduct(CreateProductRequest request) {
    return remoteDataSource.createProduct(request);
  }

  @override
  Future<void> updateProduct(UpdateProductRequest request) {
    return remoteDataSource.updateProduct(request);
  }

  @override
  Future<void> deleteProduct(ProductId id) {
    return remoteDataSource.deleteProduct(id);
  }

  @override
  Future<List<CategoryEntity>> getCategories() {
    return remoteDataSource.getCategories();
  }
}

@riverpod
ProductRepository productRepository(Ref ref) {
  final remoteDataSource = ref.read(productRemoteDataSourceProvider);
  return ProductImplementRepository(remoteDataSource: remoteDataSource);
}
