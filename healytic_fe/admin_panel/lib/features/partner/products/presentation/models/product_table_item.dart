import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_table_item.freezed.dart';

/// UI model for displaying products in a table
///
/// Wraps the domain Product and adds UI-specific state (selection)
@freezed
abstract class ProductTableItem with _$ProductTableItem {
  const factory ProductTableItem({
    required Product product,
    @Default(false) bool selected,
  }) = _ProductTableItem;
}
