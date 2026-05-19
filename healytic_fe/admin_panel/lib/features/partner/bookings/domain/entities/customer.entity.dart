import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer.entity.freezed.dart';
part 'customer.entity.g.dart';

/// Domain entity describing the customer who created a booking.
///
/// The wire schema uses snake-case keys (`full_name`, `avatar_url`); the
/// generated `fromJson` maps them to the Dart camelCase fields below via
/// `FieldRename.snake`.
///
/// `age` is a non-negative integer in the inclusive range 0..120 per
/// requirement 2.1; values outside that range indicate malformed data and
/// are dropped upstream by the bookings repository (requirement 6.7).
@Freezed(fromJson: true, toJson: true)
abstract class Customer with _$Customer {
  const factory Customer({
    required String id,
    @JsonKey(name: 'full_name') required String fullName,
    required int age,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}
