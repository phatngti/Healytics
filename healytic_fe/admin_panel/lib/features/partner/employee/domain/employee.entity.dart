import 'package:admin_panel/features/partner/employee/domain/verification_document_entry.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee.entity.freezed.dart';
part 'employee.entity.g.dart';

/// Type-safe identifier for employees.
///
/// Uses extension types for zero-cost abstraction while maintaining
/// type safety throughout the codebase.
extension type const EmployeeId(String value) implements String {
  /// Creates an [EmployeeId] from a JSON value.
  factory EmployeeId.fromJson(dynamic json) => EmployeeId(json as String);

  /// Converts the ID to a JSON-compatible value.
  String toJson() => value;
}

/// Base sealed class for all employee types.
///
/// This sealed class defines the common interface for all employee
/// entities. Use pattern matching to handle different employee types:
///
/// ```dart
/// switch (employee) {
///   case DoctorEntity doctor:
///     print('Doctor: ${doctor.medicalLicense}');
///   case SpaTherapistEntity spa:
///     print('Spa Therapist: ${spa.skills}');
///   case MassageTherapistEntity massage:
///     print('Massage Therapist: ${massage.strengthLevel}');
///   case BasicEmployeeEntity basic:
///     print('Basic Employee: ${basic.fullName}');
/// }
/// ```
sealed class EmployeeEntity {
  /// The unique identifier for the employee.
  EmployeeId get id;

  /// The employee code (e.g. 'EMP-001').
  String get employeeCode;

  /// The employee's full legal name.
  String get fullName;

  /// The name to display in the UI.
  String get displayName;

  /// URL to the employee's avatar image.
  String get avatar;

  /// The employee's role (e.g., 'DOCTOR', 'THERAPIST').
  String get role;

  /// The employee's position/title.
  String get position;

  /// Average rating from reviews.
  double get rating;

  /// Total number of reviews received.
  int get reviewCount;

  /// Current employment status (e.g., 'ACTIVE', 'INACTIVE', 'ON_LEAVE').
  String get status;

  /// The employee's email address.
  String get email;

  /// The employee's phone number.
  String get phone;

  /// Street address.
  String get address;

  /// City name.
  String get city;

  /// State/Province name.
  String get state;

  /// Country name.
  String get country;

  /// Optional description or bio.
  String? get description;

  /// Verification documents (ID card, licenses, etc.).
  List<VerificationDocumentEntry> get verificationDocuments;

  /// Weekly work schedule.
  List<EmployeeSchedule> get workSchedule;

  /// Work history entries for the employee.
  List<WorkHistoryEntry> get workHistory;

  /// Date of birth in ISO 8601 format.
  String? get dateOfBirth;

  /// Gender (e.g., 'MALE', 'FEMALE', 'OTHER').
  String? get gender;

  /// Employment type (e.g., 'Full-Time', 'Part-Time', 'Contract').
  String? get employmentType;

  /// Employment start date in ISO 8601 format.
  String? get startDate;

  /// Emergency contact person's name.
  String? get emergencyContactName;

  /// Emergency contact person's phone number.
  String? get emergencyContactPhone;

  /// Creates an [EmployeeEntity] from JSON data.
  ///
  /// Automatically determines the correct subtype based on the
  /// 'role' and 'therapistType' fields in the JSON.
  factory EmployeeEntity.fromJson(Map<String, dynamic> json) {
    final role = json['role']?.toString().toUpperCase();
    final therapistType = json['therapistType']?.toString().toUpperCase();

    if (role == 'DOCTOR') {
      return DoctorEntity.fromJson(json);
    } else if (role == 'THERAPIST') {
      if (therapistType == 'SPA') {
        return SpaTherapistEntity.fromJson(json);
      } else if (therapistType == 'MASSAGE') {
        return MassageTherapistEntity.fromJson(json);
      }
    }
    return BasicEmployeeEntity.fromJson(json);
  }
}

/// Entity representing a doctor employee.
///
/// Contains doctor-specific fields like medical license,
/// specializations, and consultation fees.
@Freezed(toJson: true)
abstract class DoctorEntity with _$DoctorEntity implements EmployeeEntity {
  /// Creates a new [DoctorEntity].
  const factory DoctorEntity({
    required EmployeeId id,
    @Default('') String employeeCode,
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
    required String jobTitle,
    @Default([]) List<String> medicalTitles,
    @Default([]) List<String> medicalLicenses,
    @Default([]) List<String> specializations,
    @Default([]) List<String> education,
    @Default([]) List<String> certifications,
    int? experienceYears,
    double? consultationFee,
    String? description,
    @Default([])
    List<VerificationDocumentEntry> verificationDocuments,
    @Default([]) List<EmployeeSchedule> workSchedule,
    @Default([]) List<WorkHistoryEntry> workHistory,
    String? dateOfBirth,
    String? gender,
    String? employmentType,
    String? startDate,
    String? emergencyContactName,
    String? emergencyContactPhone,
  }) = _DoctorEntity;

  /// Creates a [DoctorEntity] from JSON data.
  factory DoctorEntity.fromJson(Map<String, dynamic> json) =>
      _$DoctorEntityFromJson(json);
}

/// Entity representing a spa therapist employee.
///
/// Contains spa-specific fields like skills, device proficiency,
/// and commission rates.
@Freezed(toJson: true)
abstract class SpaTherapistEntity
    with _$SpaTherapistEntity
    implements EmployeeEntity {
  /// Creates a new [SpaTherapistEntity].
  const factory SpaTherapistEntity({
    required EmployeeId id,
    @Default('') String employeeCode,
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
    required String jobTitle,
    @Default(0.0) double commissionRate,
    @Default([]) List<String> skills,
    @Default([]) List<String> deviceProficiency,
    String? therapistLevel,
    String? healthCheckDate,
    String? description,
    @Default([])
    List<VerificationDocumentEntry> verificationDocuments,
    @Default([]) List<EmployeeSchedule> workSchedule,
    @Default([]) List<WorkHistoryEntry> workHistory,
    String? dateOfBirth,
    String? gender,
    String? employmentType,
    String? startDate,
    String? emergencyContactName,
    String? emergencyContactPhone,
  }) = _SpaTherapistEntity;

  /// Creates a [SpaTherapistEntity] from JSON data.
  factory SpaTherapistEntity.fromJson(Map<String, dynamic> json) =>
      _$SpaTherapistEntityFromJson(json);
}

/// Entity representing a massage therapist employee.
///
/// Contains massage-specific fields like strength level,
/// skills, and commission rates.
@Freezed(toJson: true)
abstract class MassageTherapistEntity
    with _$MassageTherapistEntity
    implements EmployeeEntity {
  /// Creates a new [MassageTherapistEntity].
  const factory MassageTherapistEntity({
    required EmployeeId id,
    @Default('') String employeeCode,
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
    required String jobTitle,
    @Default(0.0) double commissionRate,
    @Default([]) List<String> skills,
    String? strengthLevel,
    String? therapistLevel,
    String? healthCheckDate,
    String? description,
    @Default([])
    List<VerificationDocumentEntry> verificationDocuments,
    @Default([]) List<EmployeeSchedule> workSchedule,
    @Default([]) List<WorkHistoryEntry> workHistory,
    String? dateOfBirth,
    String? gender,
    String? employmentType,
    String? startDate,
    String? emergencyContactName,
    String? emergencyContactPhone,
  }) = _MassageTherapistEntity;

  /// Creates a [MassageTherapistEntity] from JSON data.
  factory MassageTherapistEntity.fromJson(Map<String, dynamic> json) =>
      _$MassageTherapistEntityFromJson(json);
}

/// Entity representing a basic employee without specialized fields.
///
/// Used as a fallback when the employee type cannot be determined
/// or for employees without role-specific attributes.
@Freezed(toJson: true)
abstract class BasicEmployeeEntity
    with _$BasicEmployeeEntity
    implements EmployeeEntity {
  /// Creates a new [BasicEmployeeEntity].
  const factory BasicEmployeeEntity({
    required EmployeeId id,
    @Default('') String employeeCode,
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
    String? description,
    @Default([])
    List<VerificationDocumentEntry> verificationDocuments,
    @Default([]) List<EmployeeSchedule> workSchedule,
    @Default([]) List<WorkHistoryEntry> workHistory,
    String? dateOfBirth,
    String? gender,
    String? employmentType,
    String? startDate,
    String? emergencyContactName,
    String? emergencyContactPhone,
  }) = _BasicEmployeeEntity;

  /// Creates a [BasicEmployeeEntity] from JSON data.
  factory BasicEmployeeEntity.fromJson(Map<String, dynamic> json) =>
      _$BasicEmployeeEntityFromJson(json);
}

/// Represents a single day's work schedule for an employee.
@Freezed(toJson: true)
abstract class EmployeeSchedule with _$EmployeeSchedule {
  /// Creates a new [EmployeeSchedule].
  ///
  /// - [day]: Day of the week (e.g., 'Monday', 'Tuesday').
  /// - [start]: Start time in HH:mm format (e.g., '09:00').
  /// - [end]: End time in HH:mm format (e.g., '17:00').
  /// - [isWorking]: Whether the employee works on this day.
  const factory EmployeeSchedule({
    required String day,
    required String start,
    required String end,
    @Default(true) bool isWorking,
  }) = _EmployeeSchedule;

  /// Creates an [EmployeeSchedule] from JSON data.
  factory EmployeeSchedule.fromJson(Map<String, dynamic> json) =>
      _$EmployeeScheduleFromJson(json);
}

/// Represents a single work history entry for an employee.
///
/// Tracks the facility, position, employment period, and
/// whether this is the employee's current position.
@Freezed(toJson: true)
abstract class WorkHistoryEntry with _$WorkHistoryEntry {
  /// Creates a new [WorkHistoryEntry].
  ///
  /// - [facility]: Name of the workplace or facility.
  /// - [position]: Job title or position held.
  /// - [period]: Employment period (e.g., '2022–Present').
  const factory WorkHistoryEntry({
    required String facility,
    required String position,
    required String period,
    @Default(false) bool isCurrent,
  }) = _WorkHistoryEntry;

  /// Creates a [WorkHistoryEntry] from JSON data.
  factory WorkHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$WorkHistoryEntryFromJson(json);
}
