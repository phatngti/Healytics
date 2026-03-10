import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

import 'employee_avatar_section.dart';
import 'employee_role_branch_section.dart';
import 'employee_stats_actions_section.dart';

class EmployeeHeaderCard extends StatelessWidget {
  final EmployeeEntity employee;
  final bool isEditing;
  final VoidCallback? onEdit;

  const EmployeeHeaderCard({
    super.key,
    required this.employee,
    this.isEditing = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          EmployeeAvatarSection(
            avatar: employee.avatar,
            fullName: employee.fullName,
            displayName: employee.displayName,
            employeeId: employee.id,
            isEditing: isEditing,
          ),
          AppDimens.horizontalLarge,
          Expanded(
            child: EmployeeRoleBranchSection(
              role: employee.role,
              status: employee.status,
              isEditing: isEditing,
            ),
          ),
          EmployeeStatsActionsSection(
            rating: employee.rating,
            reviewCount: employee.reviewCount,
            gender: employee.gender,
            dateOfBirth: employee.dateOfBirth,
            isEditing: isEditing,
            onEdit: onEdit,
          ),
        ],
      ),
    );
  }
}
