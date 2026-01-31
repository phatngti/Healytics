import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.entity.freezed.dart';
part 'location.entity.g.dart';

/// Represents a location entity (province, district, or ward).
///
/// Used for cascading location dropdowns in the business location section.
@Freezed(toJson: true)
abstract class LocationEntity with _$LocationEntity {
  const factory LocationEntity({
    /// The unique identifier for the location.
    required String id,

    /// The short name of the location (e.g., "Hà Nội").
    required String name,

    /// The full name of the location (e.g., "Thành phố Hà Nội").
    String? fullName,

    /// The administrative level (e.g., "province", "district", "ward").
    String? level,
  }) = _LocationEntity;

  factory LocationEntity.fromJson(Map<String, dynamic> json) =>
      _$LocationEntityFromJson(json);
}
