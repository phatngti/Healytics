import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/service_manual.entity.dart';
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
    String? productType,
    double? basePrice,
    double? salePrice,
    String? description,
    String? status,
    bool? onlineStore,
    int? duration,
    int? buffer,
    int? capacity,
    int? leadTime,
    String? staffAllocation,
    List<String>? images,
    String? category,
    List<String>? staffIds,
    ServiceManualEntity? serviceManual,
    @Default(false) bool clearSalePrice,
    @Default(false) bool clearServiceManual,
  }) = _UpdateProductRequest;

  factory UpdateProductRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProductRequestFromJson(json);
}
