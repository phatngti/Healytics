import 'package:admin_panel/features/common/widgets/table/helper.dart';
import 'package:admin_panel/features/partner/products/datasource/product_implement.repository.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/utils/demensions.dart';
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
    required List<({IconData icon, ActionButtonCallback onPressed})>
    actionButtons,
    String? search,
    bool? sortAscending,
  }) async {
    final repo = ref.read(productRepositoryProvider);
    final result = await repo.getProducts(
      setRowSelection,
      startingAt,
      count,
      search,
      sortAscending,
    );
    if (result.isEmpty || actionButtons.isEmpty) {
      return result;
    }
    for (var element in result) {
      element.cells.add(
        DataCell(
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actionButtons
                  .map(
                    (e) => [
                      IconButton(
                        onPressed: () {
                          e.onPressed(element.key);
                        },
                        icon: Icon(e.icon),
                      ),
                      AppDimens.horizontalSmall,
                    ],
                  )
                  .expand((x) => x)
                  .toList(),
            ),
          ),
        ),
      );
    }
    return result;
  }

  Future<void> deleteProduct(LocalKey? id) async {
    print('deleted id: $id');
    // final repo = ref.read(productRepositoryProvider);
    // await repo.deleteProduct(id);
  }

  Future<void> updateProduct(ProductEntity product) async {
    final repo = ref.read(productRepositoryProvider);
    await repo.updateProduct(product);
  }

  Future<ProductEntity> getProductById(int id) async {
    final repo = ref.read(productRepositoryProvider);
    return repo.getProductById(id);
  }
}
