import 'package:admin_panel/features/partner/employee/domain/employee_role.dart';
import 'package:flutter/material.dart';

class EmployeeRoleBranchSection extends StatelessWidget {
  final String role;
  final String status;

  const EmployeeRoleBranchSection({
    super.key,
    required this.role,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.storefront,
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
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
    final roleConfig = _getRoleConfig(role);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(roleConfig.icon, size: 14, color: roleConfig.color),
          const SizedBox(width: 4),
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

  ({IconData icon, Color color}) _getRoleConfig(String role) {
    try {
      final roleEnum = EmployeeRole.values.firstWhere(
        (e) => e.apiValue == role.toUpperCase(),
      );
      switch (roleEnum) {
        case EmployeeRole.doctor:
          return (icon: Icons.medical_services, color: Colors.blue);
        case EmployeeRole.therapist:
          return (icon: Icons.spa, color: const Color(0xFF13EC13));
        case EmployeeRole.receptionist:
          return (icon: Icons.person, color: Colors.orange);
        case EmployeeRole.manager:
          return (icon: Icons.admin_panel_settings, color: Colors.purple);
      }
    } catch (_) {
      return (icon: Icons.work, color: Colors.grey);
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusConfig = _getStatusConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
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
  ) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return (
          label: 'Active',
          color: Colors.green,
          textColor: Colors.green.shade700,
        );
      case 'INACTIVE':
        return (
          label: 'Inactive',
          color: Colors.grey,
          textColor: Colors.grey.shade700,
        );
      case 'ON_LEAVE':
        return (
          label: 'On Leave',
          color: Colors.orange,
          textColor: Colors.orange.shade700,
        );
      default:
        return (
          label: status,
          color: Colors.grey,
          textColor: Colors.grey.shade700,
        );
    }
  }
}
