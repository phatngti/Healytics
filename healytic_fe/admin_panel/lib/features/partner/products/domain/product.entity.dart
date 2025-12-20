import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.entity.freezed.dart';
part 'product.entity.g.dart';

/// Type-safe value object for Product IDs
extension type const ProductId(int value) implements int {
  factory ProductId.fromJson(dynamic json) => ProductId(json as int);
  int toJson() => value;
}

/// Pure domain model representing a Product
///
/// Used for:
/// - Fetching product data from API
/// - Displaying product information
/// - Business logic operations
@Freezed(toJson: true)
abstract class Product with _$Product {
  const factory Product({
    required ProductId id,
    required String name,
    required double price,
    required String description,
    required String image,
    required String category,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
