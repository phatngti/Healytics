import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:flutter/material.dart';

abstract class ProductRepository {
  Future<List<DataRow>> getProducts(
    void Function(LocalKey, bool) setRowSelection,
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  );

  Future<int> getTotalRows();

  Future<ProductEntity> getProductById(int id);

  Future<void> updateProduct(ProductEntity product);
}
