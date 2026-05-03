import 'package:admin_panel/features/partner/employee/domain/employee_form_field.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_gender.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_role.dart';
import 'package:admin_panel/features/partner/employee/domain/employment_type.dart';
import 'package:admin_panel/features/partner/employee/domain/medical_education.dart';
import 'package:admin_panel/features/partner/employee/domain/therapist_level.dart';
import 'package:admin_panel/features/partner/employee/domain/therapist_type.dart';
import 'package:admin_panel/features/partner/employee/domain/work_history_key.dart';

/// Dev-only autofill defaults for the Employee
/// Add form.
///
/// Activate via `?autofill=true`
/// (e.g. `/provider/employee/add?autofill=true`).
///
/// Uses the [forRole] factory to return
/// role-appropriate autofill data. Only active
/// when [kDebugMode] is `true`.
abstract final class EmployeeAddAutofill {
  /// Avatar URL shared across all roles.
  static const avatarUrl =
      'https://pub-58a545087a6b4221b1b0dab10d8d3517'
      '.r2.dev/1770315713692-'
      'Gemini_Generated_Image_86fd6v86fd6v86fd'
      '-Photoroom.png';

  /// Returns the autofill map for the given
  /// [role] and optional [therapistType].
  ///
  /// Supported roles: `THERAPIST` (default),
  /// `DOCTOR`.
  /// For therapist, supported types:
  /// `SPA`, `MASSAGE` (default).
  static Map<String, dynamic> forRole([String? role, String? therapistType]) {
    final effectiveRole =
        role?.toUpperCase() ?? EmployeeRole.therapist.apiValue;
    if (effectiveRole == EmployeeRole.doctor.apiValue) {
      return _doctorValues();
    }
    final effectiveType =
        therapistType?.toUpperCase() ?? TherapistType.massage.apiValue;
    if (effectiveType == TherapistType.spa.apiValue) {
      return _spaTherapistValues();
    }
    return _massageTherapistValues();
  }

  // ────────────────────────────────────────────
  // Therapist (Spa) defaults
  // ────────────────────────────────────────────

  static Map<String, dynamic> _spaTherapistValues() => {
    EmployeeFormField.employeeRole.key: EmployeeRole.therapist.apiValue,
    EmployeeFormField.therapistType.key: TherapistType.spa.apiValue,
    // Personal Info
    EmployeeFormField.firstName.key: 'Nguyen',
    EmployeeFormField.lastName.key: 'Thi Lan',
    EmployeeFormField.emailAddress.key: 'lan.therapist@healytics.dev',
    EmployeeFormField.phoneNumber.key: '0901234567',
    EmployeeFormField.dateOfBirth.key: DateTime(1995, 6, 15),
    EmployeeFormField.gender.key: EmployeeGender.female.displayName,
    EmployeeFormField.avatarUrl.key: avatarUrl,
    // Emergency Contact
    EmployeeFormField.emergencyContactName.key: 'Nguyen Van An',
    EmployeeFormField.emergencyContactPhone.key: '0912345678',
    // Professional
    EmployeeFormField.employmentType.key: EmploymentType.fullTime.displayName,
    EmployeeFormField.startDate.key: DateTime(2024),
    EmployeeFormField.jobTitle.key: 'Senior Spa Therapist',
    EmployeeFormField.description.key:
        '[{"insert":"Spa Therapist Profile"}'
        ',{"insert":"\\n"'
        ',"attributes":{"header":1}}'
        ',{"insert":"Experienced spa therapist '
        'specializing in aromatherapy and deep '
        'tissue massage with "}'
        ',{"insert":"5+ years"'
        ',"attributes":{"bold":true}}'
        ',{"insert":" of practice.\\n"}'
        ',{"insert":"Core Skills"'
        ',"attributes":{"bold":true}}'
        ',{"insert":"\\n"'
        ',"attributes":{"header":2}}'
        ',{"insert":"Aromatherapy"}'
        ',{"insert":"\\n"'
        ',"attributes":{"list":"bullet"}}'
        ',{"insert":"Hot Stone Massage"}'
        ',{"insert":"\\n"'
        ',"attributes":{"list":"bullet"}}'
        ',{"insert":"Deep Tissue Massage"}'
        ',{"insert":"\\n"'
        ',"attributes":{"list":"bullet"}}]',
    // Therapist-specific
    EmployeeFormField.therapistLevel.key: TherapistLevel.senior.displayName,
    EmployeeFormField.commissionRate.key: '15',
    EmployeeFormField.healthCheckDate.key: DateTime(2025, 1, 10),
    EmployeeFormField.spaSkills.key: 'Aromatherapy, Hot Stone, Deep Tissue',
    EmployeeFormField.workHistory.key: [
      {
        WorkHistoryKey.facility: 'Glow Saigon Spa Retreat',
        WorkHistoryKey.position: 'Senior Spa Therapist',
        WorkHistoryKey.period: '2022–Present',
        WorkHistoryKey.isCurrent: true,
      },
      {
        WorkHistoryKey.facility: 'Lotus Wellness Center',
        WorkHistoryKey.position: 'Junior Therapist',
        WorkHistoryKey.period: '2019–2022',
        WorkHistoryKey.isCurrent: false,
      },
    ],
  };

  // ────────────────────────────────────────────
  // Therapist (Massage) defaults
  // ────────────────────────────────────────────

  static Map<String, dynamic> _massageTherapistValues() => {
    EmployeeFormField.employeeRole.key: EmployeeRole.therapist.apiValue,
    EmployeeFormField.therapistType.key: TherapistType.massage.apiValue,
    // Personal Info
    EmployeeFormField.firstName.key: 'Le',
    EmployeeFormField.lastName.key: 'Van Huy',
    EmployeeFormField.emailAddress.key: 'huy.massage@healytics.dev',
    EmployeeFormField.phoneNumber.key: '0908765432',
    EmployeeFormField.dateOfBirth.key: DateTime(1993, 9, 5),
    EmployeeFormField.gender.key: EmployeeGender.male.displayName,
    EmployeeFormField.avatarUrl.key: avatarUrl,
    // Emergency Contact
    EmployeeFormField.emergencyContactName.key: 'Le Thi Mai',
    EmployeeFormField.emergencyContactPhone.key: '0923456789',
    // Professional
    EmployeeFormField.employmentType.key: EmploymentType.fullTime.displayName,
    EmployeeFormField.startDate.key: DateTime(2023, 3),
    EmployeeFormField.jobTitle.key: 'Senior Massage Therapist',
    EmployeeFormField.description.key:
        '[{"insert":"Massage Therapist Profile"}'
        ',{"insert":"\\n"'
        ',"attributes":{"header":1}}'
        ',{"insert":"Experienced massage '
        'therapist specializing in '
        'Thai and deep tissue techniques '
        'with "}'
        ',{"insert":"7+ years"'
        ',"attributes":{"bold":true}}'
        ',{"insert":" of practice.\\n"}'
        ',{"insert":"Core Skills"'
        ',"attributes":{"bold":true}}'
        ',{"insert":"\\n"'
        ',"attributes":{"header":2}}'
        ',{"insert":"Thai Massage"}'
        ',{"insert":"\\n"'
        ',"attributes":{"list":"bullet"}}'
        ',{"insert":"Deep Tissue Massage"}'
        ',{"insert":"\\n"'
        ',"attributes":{"list":"bullet"}}'
        ',{"insert":"Sports Massage"}'
        ',{"insert":"\\n"'
        ',"attributes":{"list":"bullet"}}]',
    // Therapist-specific
    EmployeeFormField.therapistLevel.key: TherapistLevel.senior.displayName,
    EmployeeFormField.commissionRate.key: '18',
    EmployeeFormField.healthCheckDate.key: DateTime(2025, 2, 15),
    EmployeeFormField.massageSkills.key:
        'Thai Massage, Deep Tissue, '
        'Sports Massage',
    EmployeeFormField.strengthLevel.key: 'Strong',
    EmployeeFormField.workHistory.key: [
      {
        WorkHistoryKey.facility: 'Healing Hands Spa',
        WorkHistoryKey.position: 'Senior Massage Therapist',
        WorkHistoryKey.period: '2021–Present',
        WorkHistoryKey.isCurrent: true,
      },
      {
        WorkHistoryKey.facility: 'Zen Body Massage Center',
        WorkHistoryKey.position: 'Massage Therapist',
        WorkHistoryKey.period: '2018–2021',
        WorkHistoryKey.isCurrent: false,
      },
    ],
  };

  // ────────────────────────────────────────────
  // Doctor defaults
  // ────────────────────────────────────────────

  static Map<String, dynamic> _doctorValues() => {
    EmployeeFormField.employeeRole.key: EmployeeRole.doctor.apiValue,
    // Personal Info
    EmployeeFormField.firstName.key: 'Tran',
    EmployeeFormField.lastName.key: 'Minh Duc',
    EmployeeFormField.emailAddress.key: 'duc.doctor@healytics.dev',
    EmployeeFormField.phoneNumber.key: '0987654321',
    EmployeeFormField.dateOfBirth.key: DateTime(1988, 3, 22),
    EmployeeFormField.gender.key: EmployeeGender.male.displayName,
    EmployeeFormField.avatarUrl.key: avatarUrl,
    // Emergency Contact
    EmployeeFormField.emergencyContactName.key: 'Tran Thi Hoa',
    EmployeeFormField.emergencyContactPhone.key: '0934567890',
    // Professional
    EmployeeFormField.employmentType.key: EmploymentType.fullTime.displayName,
    EmployeeFormField.startDate.key: DateTime(2023, 6, 1),
    EmployeeFormField.jobTitle.key: 'Dermatologist',
    EmployeeFormField.description.key:
        '[{"insert":"Dermatologist Profile"}'
        ',{"insert":"\\n"'
        ',"attributes":{"header":1}}'
        ',{"insert":"Board-certified '
        'dermatologist with "}'
        ',{"insert":"10+ years"'
        ',"attributes":{"bold":true}}'
        ',{"insert":" of experience in cosmetic '
        'dermatology and skin health '
        'consultations.\\n"}'
        ',{"insert":"Areas of Expertise"'
        ',"attributes":{"bold":true}}'
        ',{"insert":"\\n"'
        ',"attributes":{"header":2}}'
        ',{"insert":"Cosmetic Dermatology"}'
        ',{"insert":"\\n"'
        ',"attributes":{"list":"bullet"}}'
        ',{"insert":"Skin Health Consultations"}'
        ',{"insert":"\\n"'
        ',"attributes":{"list":"bullet"}}'
        ',{"insert":"Anti-Aging Treatments"}'
        ',{"insert":"\\n"'
        ',"attributes":{"list":"bullet"}}]',
    // Doctor-specific (indexed credentials)
    '${EmployeeFormField.medicalTitlePrefix.key}0': 'BS CKI',
    '${EmployeeFormField.medicalLicensePrefix.key}0': 'CCHN-00456',
    '${EmployeeFormField.medicalTitlePrefix.key}1': 'Thạc sĩ Y khoa',
    '${EmployeeFormField.medicalLicensePrefix.key}1': 'CCHN-00789',
    EmployeeFormField.experienceYears.key: '10',
    EmployeeFormField.consultationFee.key: '20',
    EmployeeFormField.specializations.key: ['dermatology'],
    EmployeeFormField.education.key: [
      MedicalEducation.doctorOfMedicine.displayName,
    ],
    EmployeeFormField.certifications.key: ['BLS'],
    EmployeeFormField.workHistory.key: [
      {
        WorkHistoryKey.facility: 'SkinCare International',
        WorkHistoryKey.position: 'Head of Dermatology',
        WorkHistoryKey.period: '2021–Present',
        WorkHistoryKey.isCurrent: true,
      },
      {
        WorkHistoryKey.facility: 'City General Hospital',
        WorkHistoryKey.position: 'Resident Dermatologist',
        WorkHistoryKey.period: '2018–2021',
        WorkHistoryKey.isCurrent: false,
      },
    ],
  };
}
