import 'package:common/widgets/button/back_button.dart';
import 'package:common/widgets/button/button.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_role.dart';
import 'package:admin_panel/features/partner/employee/domain/therapist_type.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/doctor_fields_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/employee_professional_role_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/employee_work_schedule_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/therapist_fields_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_details/employee_details_profile_section.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_details/details_infonmation/employee_details_documents_card.dart';
import 'package:admin_panel/router/partner_routes.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmployeeEditDesktop extends StatelessWidget {
  final EmployeeEntity employee;
  final bool isEditing;
  final EmployeeRole selectedRole;
  final ValueChanged<EmployeeRole> onRoleChanged;
  final VoidCallback onToggleEdit;
  final VoidCallback onSave;

  const EmployeeEditDesktop({
    super.key,
    required this.employee,
    required this.isEditing,
    required this.selectedRole,
    required this.onRoleChanged,
    required this.onToggleEdit,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        // Scrollable content
        SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: 24,
            top: 100, // Height for the floating header
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column - Profile Image & Contact Info
                  SizedBox(
                    width: 340,
                    child: EmployeeDetailsProfileSection(
                      avatarUrl: employee.avatar,
                    ),
                  ),
                  AppDimens.horizontalLarge,
                  // Right Column - Role, Skills, Schedule
                  Expanded(
                    child: _RightColumn(
                      employee: employee,
                      selectedRole: selectedRole,
                      onRoleChanged: onRoleChanged,
                      isEditing: isEditing,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Floating header
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                bottom: BorderSide(color: colorScheme.outlineVariant),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withAlpha(8),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    AppBackButton(
                      onTap: () {
                        context.goNamed(EmployeeHomeRoute.name);
                      },
                    ),
                    AppDimens.horizontalMedium,
                    Text(
                      isEditing
                          ? 'Edit ${selectedRole.displayName}'
                          : '${selectedRole.displayName} Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (isEditing) ...[
                      AppButton(
                        buttonType: ButtonType.outline,
                        onPressed: onToggleEdit,
                        child: const Text('Cancel'),
                      ),
                      AppDimens.horizontalSmall,
                      AppButton(
                        buttonType: ButtonType.elevated,
                        onPressed: onSave,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.save,
                              size: 18,
                              color: colorScheme.onPrimary,
                            ),
                            AppDimens.horizontalSmall,
                            const Text('Save Changes'),
                          ],
                        ),
                      ),
                    ] else
                      AppButton(
                        buttonType: ButtonType.elevated,
                        onPressed: onToggleEdit,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit,
                              size: 18,
                              color: colorScheme.onPrimary,
                            ),
                            AppDimens.horizontalSmall,
                            const Text('Edit Profile'),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RightColumn extends StatelessWidget {
  final EmployeeEntity employee;
  final EmployeeRole selectedRole;
  final ValueChanged<EmployeeRole> onRoleChanged;
  final bool isEditing;

  const _RightColumn({
    required this.employee,
    required this.selectedRole,
    required this.onRoleChanged,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EmployeeProfessionalRoleCard(
          // key: ValueKey(selectedRole),
          initialRole: selectedRole,
          onRoleChanged: onRoleChanged,
          readOnly: !isEditing,
          employee: employee,
        ),

        AppDimens.verticalMedium,
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: switch (selectedRole) {
            EmployeeRole.therapist => TherapistFieldsCard(
              key: const ValueKey('therapist'),
              initialTherapistType: _getTherapistType(employee),
              initialStrengthLevel: _getStrengthLevel(employee),
            ),
            EmployeeRole.doctor => DoctorFieldsCard(
              key: const ValueKey('doctor'),
              isEditing: isEditing,
              doctor: employee is DoctorEntity
                  ? employee as DoctorEntity
                  : null,
            ),
            _ => const SizedBox.shrink(),
          },
        ),
        AppDimens.verticalMedium,
        EmployeeDetailsDocumentsCard(isEditing: isEditing),
        AppDimens.verticalMedium,
        EmployeeWorkScheduleCard(initialSchedule: employee.workSchedule),
      ],
    );
  }

  TherapistType? _getTherapistType(EmployeeEntity employee) {
    if (employee is SpaTherapistEntity) return TherapistType.spa;
    if (employee is MassageTherapistEntity) return TherapistType.massage;
    return null;
  }

  String? _getStrengthLevel(EmployeeEntity employee) {
    if (employee is MassageTherapistEntity) return employee.strengthLevel;
    return null;
  }
}
