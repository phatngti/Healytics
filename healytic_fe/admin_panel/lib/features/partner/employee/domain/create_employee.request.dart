import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_employee.request.freezed.dart';
part 'create_employee.request.g.dart';

/// Request model for creating a new doctor employee.
///
/// Contains all required and optional fields for doctor registration.
@Freezed(toJson: true)
abstract class CreateDoctorRequest with _$CreateDoctorRequest {
  /// Creates a new [CreateDoctorRequest].
  const factory CreateDoctorRequest({
    /// First name of the doctor.
    required String firstName,

    /// Last name of the doctor.
    required String lastName,

    /// Email address for account and communication.
    required String email,

    /// Phone number for contact.
    required String phone,

    /// Date of birth in ISO 8601 format.
    required String dateOfBirth,

    /// Gender of the doctor (e.g., 'MALE', 'FEMALE', 'OTHER').
    required String gender,

    /// Name of emergency contact person.
    required String emergencyContactName,

    /// Phone number of emergency contact.
    required String emergencyContactPhone,

    /// Unique employee ID/code.
    required String employeeId,

    /// Employment type (e.g., 'Full-Time', 'Part-Time', 'Contract').
    required String employmentType,

    /// Employment start date in ISO 8601 format.
    required String startDate,

    /// Weekly work schedule configuration.
    @Default([]) List<Map<String, dynamic>> schedule,

    /// Work history entries.
    @Default([]) List<Map<String, dynamic>> workHistory,

    /// URL to avatar image.
    String? avatar,

    /// Verification documents (ID card, licenses, etc.).
    @Default([]) List<Map<String, dynamic>> verificationDocuments,

    /// Employment status (defaults to 'Active').
    @Default('Active') String status,

    /// Branch/location assignment.
    @Default('') String branch,

    /// Initial password (defaults to temporary password).
    @Default('password123') String password,

    /// Optional description or bio.
    String? description,

    // Doctor-specific fields

    /// Job title (e.g., 'Dermatologist', 'General Practitioner').
    @Default('Doctor') String jobTitle,

    /// List of medical titles.
    @Default([]) List<String> medicalTitles,

    /// List of medical license numbers.
    @Default([]) List<String> medicalLicenses,

    /// Years of professional experience.
    int? experienceYears,

    /// Consultation fee amount.
    double? consultationFee,

    /// List of medical specializations.
    @Default([]) List<String> specializations,

    /// Educational background entries.
    @Default([]) List<String> education,

    /// Professional certifications.
    @Default([]) List<String> certifications,
  }) = _CreateDoctorRequest;

  /// Creates a [CreateDoctorRequest] from JSON data.
  factory CreateDoctorRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateDoctorRequestFromJson(json);
}

/// Request model for creating a new spa therapist employee.
///
/// Contains all required and optional fields for spa therapist registration.
@Freezed(toJson: true)
abstract class CreateSpaTherapistRequest with _$CreateSpaTherapistRequest {
  /// Creates a new [CreateSpaTherapistRequest].
  const factory CreateSpaTherapistRequest({
    /// First name of the therapist.
    required String firstName,

    /// Last name of the therapist.
    required String lastName,

    /// Email address for account and communication.
    required String email,

    /// Phone number for contact.
    required String phone,

    /// Date of birth in ISO 8601 format.
    required String dateOfBirth,

    /// Gender of the therapist (e.g., 'MALE', 'FEMALE', 'OTHER').
    required String gender,

    /// Name of emergency contact person.
    required String emergencyContactName,

    /// Phone number of emergency contact.
    required String emergencyContactPhone,

    /// Unique employee ID/code.
    required String employeeId,

    /// Employment type (e.g., 'Full-Time', 'Part-Time', 'Contract').
    required String employmentType,

    /// Employment start date in ISO 8601 format.
    required String startDate,

    /// Weekly work schedule configuration.
    @Default([]) List<Map<String, dynamic>> schedule,

    /// Work history entries.
    @Default([]) List<Map<String, dynamic>> workHistory,

    /// URL to avatar image.
    String? avatar,

    /// Verification documents (ID card, licenses, etc.).
    @Default([]) List<Map<String, dynamic>> verificationDocuments,

    /// Employment status (defaults to 'Active').
    @Default('Active') String status,

    /// Branch/location assignment.
    @Default('') String branch,

    /// Initial password (defaults to temporary password).
    @Default('password123') String password,

    /// Optional description or bio.
    String? description,

    // Spa therapist-specific fields

    /// Job title (e.g., 'Senior Spa Therapist').
    required String jobTitle,

    /// Therapist skill level (e.g., 'JUNIOR', 'SENIOR', 'MASTER').
    String? therapistLevel,

    /// Commission rate percentage.
    @Default(0.0) double commissionRate,

    /// Last health check date in ISO 8601 format.
    String? healthCheckDate,

    /// List of spa treatment skills.
    @Default([]) List<String> skills,

    /// List of device/equipment proficiencies.
    @Default([]) List<String> deviceProficiency,
  }) = _CreateSpaTherapistRequest;

  /// Creates a [CreateSpaTherapistRequest] from JSON data.
  factory CreateSpaTherapistRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateSpaTherapistRequestFromJson(json);
}

/// Request model for creating a new massage therapist employee.
///
/// Contains all required and optional fields for massage therapist
/// registration.
@Freezed(toJson: true)
abstract class CreateMassageTherapistRequest
    with _$CreateMassageTherapistRequest {
  /// Creates a new [CreateMassageTherapistRequest].
  const factory CreateMassageTherapistRequest({
    /// First name of the therapist.
    required String firstName,

    /// Last name of the therapist.
    required String lastName,

    /// Email address for account and communication.
    required String email,

    /// Phone number for contact.
    required String phone,

    /// Date of birth in ISO 8601 format.
    required String dateOfBirth,

    /// Gender of the therapist (e.g., 'MALE', 'FEMALE', 'OTHER').
    required String gender,

    /// Name of emergency contact person.
    required String emergencyContactName,

    /// Phone number of emergency contact.
    required String emergencyContactPhone,

    /// Unique employee ID/code.
    required String employeeId,

    /// Employment type (e.g., 'Full-Time', 'Part-Time', 'Contract').
    required String employmentType,

    /// Employment start date in ISO 8601 format.
    required String startDate,

    /// Weekly work schedule configuration.
    @Default([]) List<Map<String, dynamic>> schedule,

    /// Work history entries.
    @Default([]) List<Map<String, dynamic>> workHistory,

    /// URL to avatar image.
    String? avatar,

    /// Verification documents (ID card, licenses, etc.).
    @Default([]) List<Map<String, dynamic>> verificationDocuments,

    /// Employment status (defaults to 'Active').
    @Default('Active') String status,

    /// Branch/location assignment.
    @Default('') String branch,

    /// Initial password (defaults to temporary password).
    @Default('password123') String password,

    /// Optional description or bio.
    String? description,

    // Massage therapist-specific fields

    /// Job title (e.g., 'Master Massage Therapist').
    required String jobTitle,

    /// Therapist skill level (e.g., 'JUNIOR', 'SENIOR', 'MASTER').
    String? therapistLevel,

    /// Massage pressure strength level (e.g., 'SOFT', 'MEDIUM', 'STRONG').
    String? strengthLevel,

    /// Commission rate percentage.
    @Default(0.0) double commissionRate,

    /// Last health check date in ISO 8601 format.
    String? healthCheckDate,

    /// List of massage technique skills.
    @Default([]) List<String> skills,
  }) = _CreateMassageTherapistRequest;

  /// Creates a [CreateMassageTherapistRequest] from JSON data.
  factory CreateMassageTherapistRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateMassageTherapistRequestFromJson(json);
}
