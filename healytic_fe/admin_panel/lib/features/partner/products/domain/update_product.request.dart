import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_product.request.freezed.dart';
part 'update_product.request.g.dart';

/// Request DTO for updating an existing product
///
/// All fields except ID are optional to support partial updates
@Freezed(toJson: true)
abstract class UpdateProductRequest with _$UpdateProductRequest {
  const factory UpdateProductRequest({
    required ProductId id,
    String? name,
    double? price,
    String? description,
    String? image,
    String? category,
  }) = _UpdateProductRequest;

  factory UpdateProductRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProductRequestFromJson(json);
}
