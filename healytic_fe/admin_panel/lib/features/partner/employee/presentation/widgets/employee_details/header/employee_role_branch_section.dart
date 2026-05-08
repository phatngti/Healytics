import 'package:admin_panel/features/partner/employee/domain/employee_role.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class EmployeeRoleBranchSection extends StatelessWidget {
  final String role;
  final String status;
  final bool isEditing;

  const EmployeeRoleBranchSection({
    super.key,
    required this.role,
    required this.status,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _RoleBadge(role: role),
            _StatusBadge(status: status),
          ],
        ),
      ],
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;

  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>()!;
    final roleConfig = _getRoleConfig(role, colorScheme, semanticColors);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(roleConfig.icon, size: 14, color: roleConfig.color),
          AppDimens.horizontalExtraSmall,
          Text(
            role.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: roleConfig.color,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  ({IconData icon, Color color}) _getRoleConfig(
    String role,
    ColorScheme colorScheme,
    SemanticColors semanticColors,
  ) {
    try {
      final roleEnum = EmployeeRoleType.values.firstWhere(
        (e) => e.apiValue == role.toUpperCase(),
      );
      switch (roleEnum) {
        case EmployeeRoleType.doctor:
          return (icon: Icons.medical_services, color: semanticColors.info!);
        case EmployeeRoleType.therapist:
          return (icon: Icons.spa, color: semanticColors.success!);
        case EmployeeRoleType.receptionist:
          return (icon: Icons.person, color: semanticColors.warning!);
        case EmployeeRoleType.manager:
          return (
            icon: Icons.admin_panel_settings,
            color: colorScheme.tertiary,
          );
      }
    } catch (_) {
      return (icon: Icons.work, color: colorScheme.onSurfaceVariant);
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>()!;
    final statusConfig = _getStatusConfig(status, semanticColors, colorScheme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusConfig.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            statusConfig.label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: statusConfig.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  ({String label, Color color, Color textColor}) _getStatusConfig(
    String status,
    SemanticColors semanticColors,
    ColorScheme colorScheme,
  ) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return (
          label: 'Active',
          color: semanticColors.success!,
          textColor: semanticColors.success!,
        );
      case 'INACTIVE':
        return (
          label: 'Inactive',
          color: colorScheme.onSurfaceVariant,
          textColor: colorScheme.onSurfaceVariant,
        );
      case 'ON_LEAVE':
        return (
          label: 'On Leave',
          color: semanticColors.warning!,
          textColor: semanticColors.warning!,
        );
      default:
        return (
          label: status,
          color: colorScheme.onSurfaceVariant,
          textColor: colorScheme.onSurfaceVariant,
        );
    }
  }
}
