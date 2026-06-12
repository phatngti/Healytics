import 'package:admin_panel/features/partner/employee/domain/employee_form_field.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_role.dart';
import 'package:admin_panel/features/partner/employee/domain/therapist_type.dart';
import 'package:admin_panel/features/partner/employee/presentation/validation/employee_create_form_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EmployeeCreateFormValidation', () {
    test('requires massage-specific fields for massage therapists', () {
      final values = _baseValues()
        ..addAll({
          EmployeeFormField.therapistType.key: TherapistType.massage.apiValue,
          EmployeeFormField.therapistLevel.key: 'Senior',
          EmployeeFormField.commissionRate.key: '15',
          EmployeeFormField.healthCheckDate.key: '2026-05-14',
          EmployeeFormField.strengthLevel.key: 'MEDIUM',
          EmployeeFormField.massageSkills.key: ['deep_tissue'],
        });

      expect(
        EmployeeCreateFormValidation.missingRequiredFields(
          values,
          role: EmployeeRoleType.therapist,
          therapistType: TherapistType.massage,
        ),
        isEmpty,
      );

      values.remove(EmployeeFormField.massageSkills.key);

      expect(
        EmployeeCreateFormValidation.missingRequiredFields(
          values,
          role: EmployeeRoleType.therapist,
          therapistType: TherapistType.massage,
        ),
        contains(EmployeeFormField.massageSkills.key),
      );
    });

    test('switching to spa requires spa fields instead of massage fields', () {
      final values = _baseValues()
        ..addAll({
          EmployeeFormField.therapistType.key: TherapistType.spa.apiValue,
          EmployeeFormField.therapistLevel.key: 'Senior',
          EmployeeFormField.commissionRate.key: '15',
          EmployeeFormField.healthCheckDate.key: '2026-05-14',
          EmployeeFormField.spaSkills.key: ['facial'],
          EmployeeFormField.deviceProficiency.key: ['laser'],
        });

      final missing = EmployeeCreateFormValidation.missingRequiredFields(
        values,
        role: EmployeeRoleType.therapist,
        therapistType: TherapistType.spa,
      );

      expect(missing, isEmpty);
      expect(missing, isNot(contains(EmployeeFormField.massageSkills.key)));
      expect(missing, isNot(contains(EmployeeFormField.strengthLevel.key)));
    });

    test('requires all visible doctor fields', () {
      final values = _baseValues(role: EmployeeRoleType.doctor)
        ..addAll({
          '${EmployeeFormField.medicalTitlePrefix.key}0': 'MD',
          '${EmployeeFormField.medicalLicensePrefix.key}0': 'LIC-001',
          EmployeeFormField.experienceYears.key: '10',
          EmployeeFormField.consultationFee.key: '500000',
          EmployeeFormField.specializations.key: ['dermatology'],
          EmployeeFormField.education.key: ['Doctor of Medicine'],
          EmployeeFormField.certifications.key: ['BLS'],
        });

      expect(
        EmployeeCreateFormValidation.missingRequiredFields(
          values,
          role: EmployeeRoleType.doctor,
          therapistType: TherapistType.massage,
        ),
        isEmpty,
      );

      values.remove(EmployeeFormField.experienceYears.key);

      expect(
        EmployeeCreateFormValidation.missingRequiredFields(
          values,
          role: EmployeeRoleType.doctor,
          therapistType: TherapistType.massage,
        ),
        contains(EmployeeFormField.experienceYears.key),
      );
    });

    test('treats blank quill documents as missing descriptions', () {
      expect(
        EmployeeCreateFormValidation.hasMeaningfulRichText(
          '[{"insert":"\\n"}]',
        ),
        isFalse,
      );
      expect(
        EmployeeCreateFormValidation.hasMeaningfulRichText(
          '[{"insert":"Employee bio\\n"}]',
        ),
        isTrue,
      );
    });
  });
}

Map<String, dynamic> _baseValues({
  EmployeeRoleType role = EmployeeRoleType.therapist,
}) {
  return {
    EmployeeFormField.firstName.key: 'An',
    EmployeeFormField.lastName.key: 'Nguyen',
    EmployeeFormField.emailAddress.key: 'an.nguyen@healytics.dev',
    EmployeeFormField.password.key: 'Password123!',
    EmployeeFormField.phoneNumber.key: '0901234567',
    EmployeeFormField.dateOfBirth.key: '1990-01-01',
    EmployeeFormField.gender.key: 'MALE',
    EmployeeFormField.emergencyContactName.key: 'Binh Nguyen',
    EmployeeFormField.emergencyContactPhone.key: '0912345678',
    EmployeeFormField.employeeRole.key: role.apiValue,
    EmployeeFormField.employeeId.key: 'EMP-001',
    EmployeeFormField.employmentType.key: 'Full-Time',
    EmployeeFormField.startDate.key: '2026-05-14',
    EmployeeFormField.jobTitle.key: role.displayName,
    EmployeeFormField.description.key: '[{"insert":"Employee bio\\n"}]',
    EmployeeFormField.verificationDocuments.key: [
      {
        'fieldKey': 'license',
        'documents': [
          {'name': 'license.pdf', 'url': 'https://example.com/license.pdf'},
        ],
      },
      {
        'fieldKey': 'id_card',
        'documents': [
          {'name': 'id.pdf', 'url': 'https://example.com/id.pdf'},
        ],
      },
    ],
  };
}
