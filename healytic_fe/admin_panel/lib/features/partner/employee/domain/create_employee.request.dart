import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_employee.request.freezed.dart';
part 'create_employee.request.g.dart';

@Freezed(toJson: true)
abstract class CreateDoctorRequest with _$CreateDoctorRequest {
  const factory CreateDoctorRequest({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String dateOfBirth,
    required String gender,
    required String emergencyContactName,
    required String emergencyContactPhone,
    required String employeeId,
    required String employmentType,
    required String startDate,
    @Default([]) List<Map<String, dynamic>> schedule,
    String? avatar,
    String? idCardUrl,
    @Default('Active') String status,
    @Default('') String branch,
    @Default('password123') String password,
    String? description,

    // Doctor specific additions
    required String jobTitle,
    required String medicalLicense,
    int? experienceYears,
    double? consultationFee,
    @Default([]) List<String> specializations,
    @Default([]) List<String> education,
    @Default([]) List<String> certifications,
  }) = _CreateDoctorRequest;

  factory CreateDoctorRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateDoctorRequestFromJson(json);
}

@Freezed(toJson: true)
abstract class CreateSpaTherapistRequest with _$CreateSpaTherapistRequest {
  const factory CreateSpaTherapistRequest({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String dateOfBirth,
    required String gender,
    required String emergencyContactName,
    required String emergencyContactPhone,
    required String employeeId,
    required String employmentType,
    required String startDate,
    @Default([]) List<Map<String, dynamic>> schedule,
    String? avatar,
    String? idCardUrl,
    @Default('Active') String status,
    @Default('') String branch,
    @Default('password123') String password,
    String? description,

    // Spa Therapist specific
    required String jobTitle,
    String? therapistLevel,
    @Default(0.0) double commissionRate,
    String? healthCheckDate,
    @Default([]) List<String> skills,
    @Default([]) List<String> deviceProficiency,
    String? licenseUrl,
  }) = _CreateSpaTherapistRequest;

  factory CreateSpaTherapistRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateSpaTherapistRequestFromJson(json);
}

@Freezed(toJson: true)
abstract class CreateMassageTherapistRequest
    with _$CreateMassageTherapistRequest {
  const factory CreateMassageTherapistRequest({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String dateOfBirth,
    required String gender,
    required String emergencyContactName,
    required String emergencyContactPhone,
    required String employeeId,
    required String employmentType,
    required String startDate,
    @Default([]) List<Map<String, dynamic>> schedule,
    String? avatar,
    String? idCardUrl,
    @Default('Active') String status,
    @Default('') String branch,
    @Default('password123') String password,
    String? description,

    // Massage Therapist specific
    required String jobTitle,
    String? therapistLevel,
    String? strengthLevel,
    @Default(0.0) double commissionRate,
    String? healthCheckDate,
    @Default([]) List<String> skills,
    String? licenseUrl,
  }) = _CreateMassageTherapistRequest;

  factory CreateMassageTherapistRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateMassageTherapistRequestFromJson(json);
}
