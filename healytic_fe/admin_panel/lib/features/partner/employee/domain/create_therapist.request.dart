import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_therapist.request.freezed.dart';
part 'create_therapist.request.g.dart';

@Freezed(toJson: true)
abstract class CreateTherapistRequest with _$CreateTherapistRequest {
  const factory CreateTherapistRequest({
    required String employeeCode,
    required String fullName,
    String? displayName,
    required String email,
    String? phone,
    String? avatarUrl,
    String? dob,
    String? gender,
    String? branchId,
    // Therapist profile fields
    String? level, // JUNIOR, SENIOR, MASTER
    String? type, // SPA, MASSAGE
    String? strengthLevel, // SOFT, MEDIUM, STRONG
    @Default(0.0) double commissionRate,
    String? healthCheckDate,
    @Default([]) List<String> skills,
  }) = _CreateTherapistRequest;

  factory CreateTherapistRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTherapistRequestFromJson(json);
}
