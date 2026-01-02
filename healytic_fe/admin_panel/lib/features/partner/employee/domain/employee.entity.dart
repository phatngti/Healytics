import 'package:freezed_annotation/freezed_annotation.dart';
part 'employee.entity.freezed.dart';
part 'employee.entity.g.dart';

extension type const EmployeeId(String value) implements String {
  factory EmployeeId.fromJson(dynamic json) => EmployeeId(json as String);
  String toJson() => value;
}

@Freezed(toJson: true)
abstract class EmployeeEntity with _$EmployeeEntity {
  const factory EmployeeEntity({
    required EmployeeId id,
    required String fullName,
    required String displayName,
    required String avatar,
    required String role,
    required String position,
    required double rating,
    required int reviewCount,
    required String status,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String state,
    required String country,
    String? licenseUrl,
    String? idCardUrl,
    @Default([]) List<String> documents,
  }) = _EmployeeEntity;

  factory EmployeeEntity.fromJson(Map<String, dynamic> json) =>
      _$EmployeeEntityFromJson(json);
}
