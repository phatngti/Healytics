import 'package:admin_panel/features/common/widgets/table/helper.dart';
import 'package:admin_panel/features/partner/products/datasource/product_implement.repository.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/update_product.request.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product.provider.freezed.dart';
part 'product.provider.g.dart';

@freezed
abstract class ProductState with _$ProductState {
  const factory ProductState() = _ProductState;
}

@riverpod
class ProductNotifier extends _$ProductNotifier {
  @override
  FutureOr<ProductState> build() async {
    return ProductState();
  }

  Future<int> getTotalRows() async {
    final repo = ref.read(productRepositoryProvider);
    return repo.getTotalRows();
  }

  Future<List<DataRow>> getProducts({
    required SetRowSelectionCallback setRowSelection,
    required int startingAt,
    required int count,
    String? search,
    bool? sortAscending,
  }) async {
    final repo = ref.read(productRepositoryProvider);
    return repo.getProducts(
      setRowSelection,
      startingAt,
      count,
      search,
      sortAscending,
    );
  }

  Future<void> deleteProduct(ProductId id) async {
    final repo = ref.read(productRepositoryProvider);
    await repo.deleteProduct(id);
  }

  Future<void> updateProduct(UpdateProductRequest request) async {
    final repo = ref.read(productRepositoryProvider);
    await repo.updateProduct(request);
  }

  Future<Product> getProductById(ProductId id) async {
    final repo = ref.read(productRepositoryProvider);
    return repo.getProductById(id);
  }
}
