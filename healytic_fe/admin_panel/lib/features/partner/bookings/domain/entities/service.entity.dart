import 'package:freezed_annotation/freezed_annotation.dart';

part 'service.entity.freezed.dart';
part 'service.entity.g.dart';

/// A service offered by the partner that a [Booking] is placed against.
///
/// Carries an [id], a display [name], [categoryName], a non-negative
/// [price], and an ISO 4217 [currencyCode] (for example `"VND"`, `"USD"`).
/// The [price] is rendered with the active locale's currency formatter at
/// the presentation layer; the domain entity itself stores the raw
/// non-negative value as emitted by the wire schema.
///
/// Pure Dart: no Flutter imports per Clean Architecture domain rules.
@Freezed(toJson: true)
abstract class Service with _$Service {
  /// Creates a new [Service] domain entity.
  ///
  /// [price] must be non-negative; callers (the data layer) are
  /// responsible for dropping bookings whose service price is missing
  /// or invalid before the entity is constructed.
  const factory Service({
    required String id,
    required String name,
    @Default('General') @JsonKey(name: 'category_name') String categoryName,
    required double price,
    @JsonKey(name: 'currency_code') required String currencyCode,
  }) = _Service;

  /// Creates a [Service] from JSON, mapping snake-case wire keys
  /// (`currency_code`) to camel-case Dart fields.
  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);
}
