import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_doctor.request.freezed.dart';
part 'create_doctor.request.g.dart';

@Freezed(toJson: true)
abstract class CreateDoctorRequest with _$CreateDoctorRequest {
  const factory CreateDoctorRequest({
    required String employeeCode,
    required String fullName,
    String? displayName,
    required String email,
    String? phone,
    String? avatarUrl,
    String? dob,
    String? gender,
    String? branchId,
    // Doctor profile fields
    String? title,
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
