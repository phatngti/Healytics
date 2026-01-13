import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_employee.request.freezed.dart';
part 'update_employee.request.g.dart';

@Freezed(toJson: true)
abstract class UpdateEmployeeRequest with _$UpdateEmployeeRequest {
  const factory UpdateEmployeeRequest({
    required EmployeeId id,
    required String fullName,
    required String displayName,
    required String avatar,
    required String role,
    required String position,
    required String status,
    required String branch,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String state,
    required String country,
    String? licenseUrl,
    String? idCardUrl,
    @Default([]) List<String> documents,
    String? password,
  }) = _UpdateEmployeeRequest;

  factory UpdateEmployeeRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateEmployeeRequestFromJson(json);
}
