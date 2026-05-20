import 'package:admin_panel/features/partner/employee/domain/employee_role.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// A segmented toggle button to switch between Doctor and Therapist roles
class RoleToggleSelector extends StatelessWidget {
  final EmployeeRoleType selectedRole;
  final ValueChanged<EmployeeRoleType> onRoleChanged;

  const RoleToggleSelector({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RoleButton(
            role: EmployeeRoleType.therapist,
            isSelected: selectedRole == EmployeeRoleType.therapist,
            icon: Icons.spa_outlined,
            onTap: () => onRoleChanged(EmployeeRoleType.therapist),
          ),
          AppDimens.horizontalExtraSmall,
          _RoleButton(
            role: EmployeeRoleType.doctor,
            isSelected: selectedRole == EmployeeRoleType.doctor,
            icon: Icons.medical_services_outlined,
            onTap: () => onRoleChanged(EmployeeRoleType.doctor),
          ),
        ],
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final EmployeeRoleType role;
  final bool isSelected;
  final IconData icon;
  final VoidCallback onTap;

  const _RoleButton({
    required this.role,
    required this.isSelected,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface.withAlpha(0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.surface
                : colorScheme.surface.withAlpha(0),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? colorScheme.outlineVariant
                  : colorScheme.surface.withAlpha(0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              AppDimens.horizontalSmall,
              Text(
                role.displayName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
