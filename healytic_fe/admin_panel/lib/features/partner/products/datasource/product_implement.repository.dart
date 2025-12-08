import 'package:admin_panel/features/partner/products/datasource/remote_datasource.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/product.repository.dart';
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
            key: ValueKey<int>(product.id),
            onSelectChanged: (value) {
              if (value != null) {
                setRowSelection(ValueKey<int>(product.id), value);
              }
            },
            cells: [
              DataCell(Center(child: Text(product.name))),
              DataCell(Center(child: Text(product.price.toString()))),
              DataCell(Center(child: Text(product.description))),
              DataCell(Center(child: Text(product.image))),
              DataCell(Center(child: Text(product.category))),
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
  Future<ProductEntity> getProductById(int id) {
    return remoteDataSource.getProductById(id);
  }

  @override
  Future<void> updateProduct(ProductEntity product) {
    return remoteDataSource.updateProduct(product);
  }
}

@riverpod
ProductRepository productRepository(Ref ref) {
  final remoteDataSource = ref.read(productRemoteDataSourceProvider);
  return ProductImplementRepository(remoteDataSource: remoteDataSource);
}
