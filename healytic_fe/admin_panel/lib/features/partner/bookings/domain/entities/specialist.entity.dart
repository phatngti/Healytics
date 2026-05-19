import 'package:freezed_annotation/freezed_annotation.dart';

part 'specialist.entity.freezed.dart';
part 'specialist.entity.g.dart';

/// Domain entity describing the partner-side specialist assigned to a
/// booking.
///
/// The wire schema uses snake-case keys (`full_name`, `role_label`,
/// `avatar_url`); the generated `fromJson` maps them to the Dart
/// camelCase fields below via `FieldRename.snake`.
///
/// `fullName` is rendered up to 40 characters and `roleLabel` up to 50
/// characters by the booking card per requirement 2.2; truncation is a
/// presentation concern and is not enforced here. `avatarUrl` is
/// nullable so the UI can fall back to initials per requirement 2.6.
@Freezed(fromJson: true, toJson: true)
abstract class Specialist with _$Specialist {
  const factory Specialist({
    required String id,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'role_label') required String roleLabel,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _Specialist;

  factory Specialist.fromJson(Map<String, dynamic> json) =>
      _$SpecialistFromJson(json);
}
