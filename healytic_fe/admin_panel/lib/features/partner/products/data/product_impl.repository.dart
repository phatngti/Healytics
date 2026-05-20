import 'package:admin_panel/features/partner/products/data/product_remote.datasource.dart';
import 'package:admin_panel/features/partner/products/domain/category.entity.dart';
import 'package:admin_panel/features/partner/products/domain/create_product.request.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/product.repository.dart';
import 'package:admin_panel/features/partner/products/domain/update_product.request.dart';
import 'package:admin_openapi/api.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_impl.repository.g.dart';

class ProductImplRepository implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductImplRepository({required this.remoteDataSource});

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
  Future<List<Product>> getAllProducts({String? sortedBy, bool? sortedAsc}) {
    return remoteDataSource.getAllProducts(
      sortedBy: sortedBy,
      sortedAsc: sortedAsc,
    );
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

  @override
  Future<List<ServiceTagResponseDto>> getServiceTags() {
    return remoteDataSource.getServiceTags();
  }
}

@riverpod
ProductRepository productRepository(Ref ref) {
  final remoteDataSource = ref.read(productRemoteDataSourceProvider);
  return ProductImplRepository(remoteDataSource: remoteDataSource);
}
