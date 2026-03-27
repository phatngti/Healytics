import 'package:admin_panel/features/partner/employee/domain/employee_role.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// A segmented toggle button to switch between Doctor and Therapist roles
class RoleToggleSelector extends StatelessWidget {
  final EmployeeRole selectedRole;
  final ValueChanged<EmployeeRole> onRoleChanged;

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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RoleButton(
            role: EmployeeRole.therapist,
            isSelected: selectedRole == EmployeeRole.therapist,
            icon: Icons.spa_outlined,
            onTap: () => onRoleChanged(EmployeeRole.therapist),
          ),
          AppDimens.horizontalExtraSmall,
          _RoleButton(
            role: EmployeeRole.doctor,
            isSelected: selectedRole == EmployeeRole.doctor,
            icon: Icons.medical_services_outlined,
            onTap: () => onRoleChanged(EmployeeRole.doctor),
          ),
        ],
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final EmployeeRole role;
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
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colorScheme.shadow,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
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
