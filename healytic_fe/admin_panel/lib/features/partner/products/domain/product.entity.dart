import 'package:admin_panel/features/partner/products/domain/category.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.entity.freezed.dart';
part 'product.entity.g.dart';

/// Type-safe value object for Product IDs
extension type const ProductId(String value) implements String {
  factory ProductId.fromJson(dynamic json) => ProductId(json.toString());
  String toJson() => value;
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

    // General Information
    required String name,
    required String description,
    @Default('service') String productType,

    // Pricing & Inventory
    required double basePrice,
    double? salePrice,
    double? costPerItem,
    String? sku,
    String? barcode,
    int? stockQuantity,

    // Visibility
    @Default('draft') String status,
    @Default(true) bool onlineStore,

    // Organization
    required CategoryEntity category,
    @Default([]) List<String> tags,

    // Operations & Scheduling
    int? duration,
    int? buffer,
    int? capacity,
    int? leadTime,
    @Default('any') String staffAllocation,
    @Default([]) List<String> staffIds,

    // Media
    @Default([]) List<String> images,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
