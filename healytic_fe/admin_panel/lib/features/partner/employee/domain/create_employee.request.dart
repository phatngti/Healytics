import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'create_employee.request.freezed.dart';
part 'create_employee.request.g.dart';

@Freezed(toJson: true)
abstract class CreateEmployeeRequest with _$CreateEmployeeRequest {
  const factory CreateEmployeeRequest({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String dateOfBirth,
    required String gender,
    required String emergencyContactName,
    required String emergencyContactPhone,
    required String jobTitle,
    required String employeeId,
    required String employmentType,
    required String startDate,
    @Default([]) List<String> skills,
    @Default([]) List<String> services,
    @Default([]) List<Map<String, dynamic>> schedule,
    String? avatar,
    String? licenseUrl,
    String? idCardUrl,
    @Default('Active') String status,
    @Default('') String branch,
    @Default('password123') String password,
  }) = _CreateEmployeeRequest;

  factory CreateEmployeeRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateEmployeeRequestFromJson(json);
}
