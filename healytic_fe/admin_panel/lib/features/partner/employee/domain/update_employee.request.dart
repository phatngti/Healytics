import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_employee.request.freezed.dart';
part 'update_employee.request.g.dart';

/// Request model for updating an existing employee.
///
/// Contains all fields that can be updated for an employee.
/// The [id] field is required to identify which employee to update.
@Freezed(toJson: true)
abstract class UpdateEmployeeRequest with _$UpdateEmployeeRequest {
  /// Creates a new [UpdateEmployeeRequest].
  const factory UpdateEmployeeRequest({
    /// The unique identifier of the employee to update.
    required EmployeeId id,

    /// Updated employee code.
    String? employeeCode,

    /// Updated first name.
    String? firstName,

    /// Updated last name.
    String? lastName,

    /// Updated full name.
    required String fullName,

    /// Updated display name.
    required String displayName,

    /// Updated avatar URL.
    required String avatar,

    /// Updated role (e.g., 'DOCTOR', 'THERAPIST').
    required String role,

    /// Updated position/title.
    required String position,

    /// Updated status (e.g., 'ACTIVE', 'INACTIVE', 'ON_LEAVE').
    required String status,

    /// Updated branch assignment.
    required String branch,

    /// Updated email address.
    required String email,

    /// Updated phone number.
    required String phone,

    /// Updated date of birth in ISO date format.
    String? dateOfBirth,

    /// Updated gender API value.
    String? gender,

    /// Updated street address.
    required String address,

    /// Updated city.
    required String city,

    /// Updated state/province.
    required String state,

    /// Updated country.
    required String country,

    /// Updated professional job title.
    String? jobTitle,

    /// Updated employment start date in ISO date format.
    String? startDate,

    /// Updated employment type.
    String? employmentType,

    /// Updated emergency contact name.
    String? emergencyContactName,

    /// Updated emergency contact phone.
    String? emergencyContactPhone,

    /// Updated description / bio.
    String? description,

    /// Updated verification documents.
    @Default([]) List<Map<String, dynamic>> verificationDocuments,

    /// Updated weekly work schedule.
    @Default([]) List<Map<String, dynamic>> schedule,

    /// Updated work history entries.
    @Default([]) List<Map<String, dynamic>> workHistory,

    /// Updated doctor medical titles.
    @Default([]) List<String> medicalTitles,

    /// Updated doctor medical licenses.
    @Default([]) List<String> medicalLicenses,

    /// Updated doctor years of experience.
    int? experienceYears,

    /// Updated doctor consultation fee.
    double? consultationFee,

    /// Updated doctor specializations.
    @Default([]) List<String> specializations,

    /// Updated doctor education entries.
    @Default([]) List<String> education,

    /// Updated doctor certifications.
    @Default([]) List<String> certifications,

    /// Updated therapist type API value.
    String? therapistType,

    /// Updated therapist level API value.
    String? therapistLevel,

    /// Updated massage therapist strength level API value.
    String? strengthLevel,

    /// Updated therapist commission rate.
    double? commissionRate,

    /// Updated therapist health-check date in ISO date format.
    String? healthCheckDate,

    /// Updated therapist skill list.
    @Default([]) List<String> skills,

    /// Updated spa therapist device proficiency list.
    @Default([]) List<String> deviceProficiency,
  }) = _UpdateEmployeeRequest;

  /// Creates an [UpdateEmployeeRequest] from JSON data.
  factory UpdateEmployeeRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateEmployeeRequestFromJson(json);
}
