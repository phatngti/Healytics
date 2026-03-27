import 'package:freezed_annotation/freezed_annotation.dart';

part 'facility_image.entity.freezed.dart';
part 'facility_image.entity.g.dart';

/// Domain entity for a facility/clinic image
///
/// Used for displaying and creating facility images
/// associated with a product.
@Freezed(toJson: true)
abstract class FacilityImageEntity with _$FacilityImageEntity {
  const factory FacilityImageEntity({
    required String imageUrl,
    required String label,
    int? sortOrder,
  }) = _FacilityImageEntity;

  factory FacilityImageEntity.fromJson(Map<String, dynamic> json) =>
      _$FacilityImageEntityFromJson(json);
}
