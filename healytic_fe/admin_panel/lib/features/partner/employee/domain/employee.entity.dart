import 'package:freezed_annotation/freezed_annotation.dart';
part 'employee.entity.freezed.dart';
part 'employee.entity.g.dart';

extension type const EmployeeId(int value) implements int {
  factory EmployeeId.fromJson(dynamic json) => EmployeeId(json as int);
  int toJson() => value;
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
    required String branch,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String state,
    required String country,
  }) = _EmployeeEntity;

  factory EmployeeEntity.fromJson(Map<String, dynamic> json) =>
      _$EmployeeEntityFromJson(json);
}
