import 'package:admin_panel/features/partner/products/datasource/remote_datasource.dart';
import 'package:admin_panel/features/partner/products/domain/category.entity.dart';
import 'package:admin_panel/features/partner/products/domain/create_product.request.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/product.repository.dart';
import 'package:admin_panel/features/partner/products/domain/update_product.request.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_implement.repository.g.dart';

class ProductImplementRepository implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductImplementRepository({required this.remoteDataSource});

  @override
  Future<List<DataRow>> getProducts(
    void Function(LocalKey, bool) setRowSelection,
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  ) async {
    final products = await remoteDataSource.getProducts(
      startingAt,
      count,
      sortedBy,
      sortedAsc,
    );
    return products
        .map(
          (product) => DataRow(
            key: ValueKey<String>(product.id.value),
            onSelectChanged: (value) {
              if (value != null) {
                setRowSelection(ValueKey<String>(product.id.value), value);
              }
            },
            cells: [
              DataCell(
                Center(
                  child: Text(
                    product.id.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(Center(child: Text(product.name))),
              DataCell(Center(child: Text(product.basePrice.toString()))),
              DataCell(Center(child: Text(product.description))),
              DataCell(
                Center(
                  child:
                      product.images.isNotEmpty && product.images[0].isNotEmpty
                      ? SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.network(
                            product.images[0],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 24),
                          ),
                        )
                      : const SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(Icons.image_not_supported, size: 24),
                        ),
                ),
              ),
              DataCell(Center(child: Text(product.category.name))),
            ],
          ),
        )
        .toList();
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
