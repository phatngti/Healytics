import 'package:admin_panel/features/partner/employee/domain/employee_gender.dart';
import 'package:admin_panel/features/partner/employee/domain/employment_type.dart';
import 'package:admin_panel/features/partner/employee/domain/medical_education.dart';
import 'package:admin_panel/features/partner/employee/domain/therapist_level.dart';
import 'package:admin_panel/features/partner/employee/domain/therapist_type.dart';

/// Dev-only autofill defaults for the Employee Add form.
///
/// Activate via `?autofill=true`
/// (e.g. `/provider/employee/add?autofill=true`).
///
/// Uses the [forRole] factory to return role-appropriate
/// autofill data. Only active when [kDebugMode] is `true`.
abstract final class EmployeeAddAutofill {
  /// Avatar URL shared across all roles.
  static const avatarUrl =
      'https://pub-58a545087a6b4221b1b0dab10d8d3517'
      '.r2.dev/1770315713692-'
      'Gemini_Generated_Image_86fd6v86fd6v86fd'
      '-Photoroom.png';

  /// Returns the autofill map for the given [role].
  ///
  /// Supported roles: `THERAPIST` (default), `DOCTOR`.
  static Map<String, dynamic> forRole([String role = 'THERAPIST']) {
    return switch (role.toUpperCase()) {
      'DOCTOR' => _doctorValues(),
      _ => _therapistValues(),
    };
  }

  // ──────────────────────────────────────────────
  // Therapist (Spa) defaults
  // ──────────────────────────────────────────────

  static Map<String, dynamic> _therapistValues() => {
    'employee_role': 'THERAPIST',
    'therapist_type': TherapistType.spa.apiValue,
    // Personal Info
    'first_name': 'Nguyen',
    'last_name': 'Thi Lan',
    'email_address': 'lan.therapist@healytics.dev',
    'phone_number': '0901234567',
    'date_of_birth': DateTime(1995, 6, 15),
    'gender': EmployeeGender.female.displayName,
    'avatar_url': avatarUrl,
    // Emergency Contact
    'emergency_contact_name': 'Nguyen Van An',
    'emergency_contact_phone': '0912345678',
    // Professional
    'employment_type': EmploymentType.fullTime.displayName,
    'start_date': DateTime(2024),
    'job_title': 'Senior Spa Therapist',
    'description':
        '[{"insert":"Spa Therapist Profile"},{"insert":"\\n","attributes":{"header":1}}'
        ',{"insert":"Experienced spa therapist specializing in aromatherapy and deep tissue massage with "}'
        ',{"insert":"5+ years","attributes":{"bold":true}}'
        ',{"insert":" of practice.\\n"}'
        ',{"insert":"Core Skills","attributes":{"bold":true}}'
        ',{"insert":"\\n","attributes":{"header":2}}'
        ',{"insert":"Aromatherapy"},{"insert":"\\n","attributes":{"list":"bullet"}}'
        ',{"insert":"Hot Stone Massage"},{"insert":"\\n","attributes":{"list":"bullet"}}'
        ',{"insert":"Deep Tissue Massage"},{"insert":"\\n","attributes":{"list":"bullet"}}]',
    // Therapist-specific
    'therapist_level': TherapistLevel.senior.displayName,
    'commission_rate': '15',
    'health_check_date': DateTime(2025, 1, 10),
    'spa_skills': 'Aromatherapy, Hot Stone, Deep Tissue',
  };

  // ──────────────────────────────────────────────
  // Doctor defaults
  // ──────────────────────────────────────────────

  static Map<String, dynamic> _doctorValues() => {
    'employee_role': 'DOCTOR',
    // Personal Info
    'first_name': 'Tran',
    'last_name': 'Minh Duc',
    'email_address': 'duc.doctor@healytics.dev',
    'phone_number': '0987654321',
    'date_of_birth': DateTime(1988, 3, 22),
    'gender': EmployeeGender.male.displayName,
    'avatar_url': avatarUrl,
    // Emergency Contact
    'emergency_contact_name': 'Tran Thi Hoa',
    'emergency_contact_phone': '0934567890',
    // Professional
    'employment_type': EmploymentType.fullTime.displayName,
    'start_date': DateTime(2023, 6, 1),
    'job_title': 'Dermatologist',
    'description':
        '[{"insert":"Dermatologist Profile"},{"insert":"\\n","attributes":{"header":1}}'
        ',{"insert":"Board-certified dermatologist with "}'
        ',{"insert":"10+ years","attributes":{"bold":true}}'
        ',{"insert":" of experience in cosmetic dermatology and skin health consultations.\\n"}'
        ',{"insert":"Areas of Expertise","attributes":{"bold":true}}'
        ',{"insert":"\\n","attributes":{"header":2}}'
        ',{"insert":"Cosmetic Dermatology"},{"insert":"\\n","attributes":{"list":"bullet"}}'
        ',{"insert":"Skin Health Consultations"},{"insert":"\\n","attributes":{"list":"bullet"}}'
        ',{"insert":"Anti-Aging Treatments"},{"insert":"\\n","attributes":{"list":"bullet"}}]',
    // Doctor-specific
    'medical_title': 'BS CKI',
    'medical_license': 'CCHN-00456',
    'experience_years': '10',
    'consultation_fee': '20',
    'specializations': ['dermatology'],
    'education': MedicalEducation.doctorOfMedicine.displayName,
  };
}
