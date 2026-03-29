import 'package:admin_panel/features/partner/employee/domain/employee_role.dart';
import 'package:admin_panel/features/partner/employee/domain/therapist_type.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/doctor_fields_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/doctor_experience_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/employee_documents_certifications_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/employee_professional_role_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/employee_work_history_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/employee_work_schedule_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/therapist_fields_card.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class EmployeeAddFormSection extends StatelessWidget {
  final EmployeeRole selectedRole;
  final ValueChanged<EmployeeRole> onRoleChanged;

  /// The currently selected therapist type.
  final TherapistType selectedTherapistType;

  /// Called when the therapist type toggle changes.
  final ValueChanged<TherapistType>?
      onTherapistTypeChanged;

  const EmployeeAddFormSection({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
    this.selectedTherapistType =
        TherapistType.massage,
    this.onTherapistTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EmployeeProfessionalRoleCard(
          initialRole: selectedRole,
          onRoleChanged: onRoleChanged,
        ),
        AppDimens.verticalMedium,
        // Conditionally show role-specific fields
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: selectedRole == EmployeeRole.therapist
              ? TherapistFieldsCard(
                  key: const ValueKey('therapist'),
                  initialTherapistType:
                      selectedTherapistType,
                  onTherapistTypeChanged:
                      onTherapistTypeChanged,
                )
              : Column(
                  key: const ValueKey('doctor'),
                  children: const [
                    DoctorFieldsCard(
                      isEditing: true,
                    ),
                    AppDimens.verticalMedium,
                    DoctorExperienceCard(
                      isEditing: true,
                    ),
                  ],
                ),
        ),
        AppDimens.verticalMedium,
        const EmployeeWorkHistoryCard(),
        AppDimens.verticalMedium,
        const EmployeeDocumentsCertificationsCard(),
        AppDimens.verticalMedium,
        const EmployeeWorkScheduleCard(),
      ],
    );
  }
}
