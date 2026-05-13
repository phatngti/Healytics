import 'dart:convert';

import 'package:admin_panel/features/partner/employee/domain/employee_form_field.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_role.dart';
import 'package:admin_panel/features/partner/employee/domain/therapist_type.dart';

abstract final class EmployeeCreateFormValidation {
  static const _licenseDocKey = 'license';
  static const _idCardDocKey = 'id_card';

  static final List<String> commonRequiredFields = [
    EmployeeFormField.firstName.key,
    EmployeeFormField.lastName.key,
    EmployeeFormField.emailAddress.key,
    EmployeeFormField.phoneNumber.key,
    EmployeeFormField.dateOfBirth.key,
    EmployeeFormField.gender.key,
    EmployeeFormField.emergencyContactName.key,
    EmployeeFormField.emergencyContactPhone.key,
    EmployeeFormField.employeeRole.key,
    EmployeeFormField.employeeId.key,
    EmployeeFormField.employmentType.key,
    EmployeeFormField.startDate.key,
    EmployeeFormField.jobTitle.key,
    EmployeeFormField.description.key,
    EmployeeFormField.verificationDocuments.key,
  ];

  static List<String> requiredFields({
    required EmployeeRoleType role,
    required TherapistType therapistType,
  }) {
    if (role == EmployeeRoleType.doctor) {
      return [
        ...commonRequiredFields,
        '${EmployeeFormField.medicalTitlePrefix.key}0',
        '${EmployeeFormField.medicalLicensePrefix.key}0',
        EmployeeFormField.experienceYears.key,
        EmployeeFormField.consultationFee.key,
        EmployeeFormField.specializations.key,
        EmployeeFormField.education.key,
        EmployeeFormField.certifications.key,
      ];
    }

    if (role == EmployeeRoleType.therapist) {
      return [
        ...commonRequiredFields,
        EmployeeFormField.therapistType.key,
        EmployeeFormField.therapistLevel.key,
        EmployeeFormField.commissionRate.key,
        EmployeeFormField.healthCheckDate.key,
        if (therapistType == TherapistType.massage) ...[
          EmployeeFormField.strengthLevel.key,
          EmployeeFormField.massageSkills.key,
        ],
        if (therapistType == TherapistType.spa) ...[
          EmployeeFormField.spaSkills.key,
          EmployeeFormField.deviceProficiency.key,
        ],
      ];
    }

    return commonRequiredFields;
  }

  static List<String> missingRequiredFields(
    Map<String, dynamic> values, {
    required EmployeeRoleType role,
    required TherapistType therapistType,
  }) {
    return requiredFields(
      role: role,
      therapistType: therapistType,
    ).where((fieldKey) => !hasValue(values[fieldKey], fieldKey)).toList();
  }

  static bool isComplete(
    Map<String, dynamic> values, {
    required EmployeeRoleType role,
    required TherapistType therapistType,
  }) {
    return missingRequiredFields(
      values,
      role: role,
      therapistType: therapistType,
    ).isEmpty;
  }

  static bool hasValue(dynamic value, [String? fieldKey]) {
    if (value == null) return false;
    if (fieldKey == EmployeeFormField.verificationDocuments.key) {
      return hasRequiredDocuments(value);
    }
    if (fieldKey == EmployeeFormField.description.key) {
      return hasMeaningfulRichText(value);
    }
    if (value is String) {
      return value.trim().isNotEmpty;
    }
    if (value is Iterable) return value.isNotEmpty;
    return true;
  }

  static bool hasRequiredDocuments(dynamic value) {
    if (value is! List) return false;
    final groups = value.whereType<Map>().toList();
    var hasLicense = false;
    var hasIdCard = false;

    for (final group in groups) {
      final key = group['fieldKey']?.toString();
      final docs = group['documents'];
      final hasDocs = docs is List && docs.isNotEmpty;
      if (key == _licenseDocKey && hasDocs) {
        hasLicense = true;
      }
      if (key == _idCardDocKey && hasDocs) {
        hasIdCard = true;
      }
    }

    return hasLicense && hasIdCard;
  }

  static bool hasMeaningfulRichText(dynamic value) {
    if (value == null) return false;
    final raw = value.toString().trim();
    if (raw.isEmpty) return false;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        final plainText = decoded
            .whereType<Map>()
            .map((op) => op['insert']?.toString() ?? '')
            .join()
            .trim();
        return plainText.isNotEmpty;
      }
    } catch (_) {
      // Non-JSON values are treated as plain text below.
    }

    return raw.isNotEmpty;
  }

  static EmployeeRoleType roleFromValues(
    Map<String, dynamic> values, {
    EmployeeRoleType fallback = EmployeeRoleType.therapist,
  }) {
    final role = EmployeeRoleType.fromApiValue(
      values[EmployeeFormField.employeeRole.key]?.toString(),
    );
    return role ?? fallback;
  }

  static TherapistType therapistTypeFromValues(
    Map<String, dynamic> values, {
    TherapistType fallback = TherapistType.massage,
  }) {
    final type = TherapistType.fromApiValue(
      values[EmployeeFormField.therapistType.key]?.toString(),
    );
    return type ?? fallback;
  }
}
