// Domain entities for the employee detail feature.
//
// Pure Dart — no Flutter or framework imports.

import 'package:user_app/features/employee/domain/entities/certificate.entity.dart';
import 'package:user_app/features/employee/domain/entities/medical_credential.entity.dart';

/// Employee role in the system.
enum EmployeeRole {
  doctor,
  therapist,
  receptionist,
  manager;

  /// Creates an [EmployeeRole] from its API string
  /// representation (e.g. "DOCTOR").
  static EmployeeRole fromString(String value) {
    return EmployeeRole.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => EmployeeRole.doctor,
    );
  }
}

/// Employee gender.
enum EmployeeGender {
  male,
  female,
  other;

  /// Creates an [EmployeeGender] from its API string
  /// representation (e.g. "MALE").
  static EmployeeGender? fromString(String? value) {
    if (value == null) return null;
    return EmployeeGender.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => EmployeeGender.other,
    );
  }

  /// Human-readable label.
  String get label {
    return switch (this) {
      EmployeeGender.male => 'Male',
      EmployeeGender.female => 'Female',
      EmployeeGender.other => 'Other',
    };
  }
}

/// Employee employment status.
enum EmployeeStatus {
  active,
  inactive,
  onLeave;

  /// Creates an [EmployeeStatus] from its API string
  /// representation (e.g. "ACTIVE", "ON_LEAVE").
  static EmployeeStatus fromString(String value) {
    final lower = value.toLowerCase();
    if (lower == 'on_leave') return EmployeeStatus.onLeave;
    return EmployeeStatus.values.firstWhere(
      (e) => e.name == lower,
      orElse: () => EmployeeStatus.active,
    );
  }

  /// Human-readable label.
  String get label {
    return switch (this) {
      EmployeeStatus.active => 'Active',
      EmployeeStatus.inactive => 'Inactive',
      EmployeeStatus.onLeave => 'On Leave',
    };
  }
}

/// Weekly schedule entry for an employee.
class WorkScheduleEntry {
  final String day;
  final String? startTime;
  final String? endTime;
  final bool isWorking;

  const WorkScheduleEntry({
    required this.day,
    this.startTime,
    this.endTime,
    required this.isWorking,
  });
}

/// Work history entry for an employee's
/// past/current positions at facilities.
class WorkHistoryEntry {
  /// Facility or clinic name.
  final String facility;

  /// Job position held.
  final String position;

  /// Duration or period string (e.g. "2020–Now").
  final String period;

  /// Whether this is the current position.
  final bool isCurrent;

  const WorkHistoryEntry({
    required this.facility,
    required this.position,
    required this.period,
    this.isCurrent = false,
  });
}

/// A single uploaded document (name + URL).
class DocumentEntryEntity {
  /// Display name of the document.
  final String name;

  /// URL of the uploaded document.
  final String url;

  /// ISO timestamp of the last update.
  final String? updatedTime;

  const DocumentEntryEntity({
    required this.name,
    required this.url,
    this.updatedTime,
  });
}

/// A group of verification documents keyed by
/// field (e.g. "id_card", "other_documents").
class VerificationDocumentEntity {
  /// Unique key identifying the document field.
  final String fieldKey;

  /// Documents belonging to this field.
  final List<DocumentEntryEntity> documents;

  const VerificationDocumentEntity({
    required this.fieldKey,
    this.documents = const [],
  });
}

/// Doctor-specific profile data.
class DoctorProfileEntity {
  /// Professional title (e.g. "MD, PhD").
  final String? title;

  /// Medical credentials (titles + licenses).
  final List<MedicalCredentialEntity> medicalCredentials;

  /// Years of professional experience.
  final int? experienceYears;

  /// Fee per consultation in VND.
  final double? consultationFee;

  /// Medical specializations.
  final List<String> specializations;

  /// Education history entries.
  final List<String> education;

  const DoctorProfileEntity({
    this.title,
    this.medicalCredentials = const [],
    this.experienceYears,
    this.consultationFee,
    this.specializations = const [],
    this.education = const [],
  });
}

/// Therapist-specific profile data.
class TherapistProfileEntity {
  /// Experience level (e.g. "Senior").
  final String? level;

  /// Therapy type (e.g. "Physical Therapy").
  final String? type;

  /// Physical strength level.
  final String? strengthLevel;

  /// Professional skills.
  final List<String> skills;

  /// Devices the therapist is proficient with.
  final List<String> deviceProficiency;

  /// Last health check date.
  final DateTime? healthCheckDate;

  const TherapistProfileEntity({
    this.level,
    this.type,
    this.strengthLevel,
    this.skills = const [],
    this.deviceProficiency = const [],
    this.healthCheckDate,
  });
}

/// Complete employee detail for the profile screen.
class EmployeeDetailEntity {
  final String id;
  final String employeeCode;
  final String fullName;
  final String? avatarUrl;
  final EmployeeRole role;
  final EmployeeStatus status;
  final String? jobTitle;
  final String? description;
  final String email;
  final String? phone;
  final DateTime? dob;
  final EmployeeGender? gender;
  final DateTime? startDate;
  final String? employmentType;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final double rating;
  final int reviewCount;
  final List<WorkScheduleEntry> schedule;
  final List<WorkHistoryEntry> workHistory;
  final List<VerificationDocumentEntity> verificationDocuments;
  final DoctorProfileEntity? doctorProfile;
  final TherapistProfileEntity? therapistProfile;

  const EmployeeDetailEntity({
    required this.id,
    required this.employeeCode,
    required this.fullName,
    this.avatarUrl,
    required this.role,
    required this.status,
    this.jobTitle,
    this.description,
    required this.email,
    this.phone,
    this.dob,
    this.gender,
    this.startDate,
    this.employmentType,
    this.emergencyContactName,
    this.emergencyContactPhone,
    required this.rating,
    required this.reviewCount,
    this.schedule = const [],
    this.workHistory = const [],
    this.verificationDocuments = const [],
    this.doctorProfile,
    this.therapistProfile,
  });

  /// Display name combining doctor title with name
  /// when available, otherwise just fullName.
  String get displayName {
    if (isDoctor && doctorProfile?.title != null) {
      return '${doctorProfile!.title} $fullName';
    }
    return fullName;
  }

  /// Flat list of all certificates derived from
  /// [verificationDocuments].
  List<CertificateEntity> get certificates {
    return verificationDocuments
        .expand((vd) => vd.documents)
        .map(
          (d) => CertificateEntity(
            name: d.name,
            url: d.url,
            type: CertificateType.fromUrl(d.url),
          ),
        )
        .toList();
  }

  /// Whether this employee is a doctor.
  bool get isDoctor => role == EmployeeRole.doctor;

  /// Whether this employee is a therapist.
  bool get isTherapist => role == EmployeeRole.therapist;

  /// Human-readable role label.
  String get roleLabel {
    return switch (role) {
      EmployeeRole.doctor => 'Doctor',
      EmployeeRole.therapist => 'Therapist',
      EmployeeRole.receptionist => 'Receptionist',
      EmployeeRole.manager => 'Manager',
    };
  }
}
