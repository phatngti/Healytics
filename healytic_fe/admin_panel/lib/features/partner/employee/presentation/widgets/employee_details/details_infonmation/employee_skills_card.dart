import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../employee_badges_strength.dart';
import '../employee_skill_cloud.dart';

/// Card displaying therapy skills and professional
/// attributes for an employee.
class EmployeeSkillsCard extends StatelessWidget {
  /// The employee entity to display data for.
  final EmployeeEntity employee;

  /// Whether the parent form is in editing mode.
  final bool isEditing;

  const EmployeeSkillsCard({
    super.key,
    required this.employee,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors =
        Theme.of(context).extension<SemanticColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.surfaceContainerHighest
                      .withAlpha(100),
                  colorScheme.surface,
                ],
              ),
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.psychology,
                      color: semanticColors.success,
                    ),
                    AppDimens.horizontalSmall,
                    Text(
                      _headerTitle,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                _HealthCheckBadge(
                  healthCheckDate: _healthCheckDate,
                ),
              ],
            ),
          ),
          Padding(
            padding: AppDimens.paddingAllLarge,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: EmployeeBadgesStrength(
                    employee: employee,
                    isEditing: isEditing,
                  ),
                ),
                Container(
                  width: 1,
                  height: 150,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 32,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: EmployeeSkillCloud(
                    skills: _skills,
                    isEditing: isEditing,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get _headerTitle {
    return switch (employee) {
      DoctorEntity() => 'Medical Skills & Specializations',
      _ => 'Therapy Skills & Attributes',
    };
  }

  String? get _healthCheckDate {
    return switch (employee) {
      SpaTherapistEntity e => e.healthCheckDate,
      MassageTherapistEntity e => e.healthCheckDate,
      _ => null,
    };
  }

  List<String> get _skills {
    return switch (employee) {
      DoctorEntity e => e.specializations,
      SpaTherapistEntity e => e.skills,
      MassageTherapistEntity e => e.skills,
      _ => [],
    };
  }
}

class _HealthCheckBadge extends StatelessWidget {
  final String? healthCheckDate;

  const _HealthCheckBadge({required this.healthCheckDate});

  @override
  Widget build(BuildContext context) {
    if (healthCheckDate == null) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors =
        Theme.of(context).extension<SemanticColors>()!;

    final formatted = _formatDate(healthCheckDate!);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: semanticColors.success?.withAlpha(25),
        borderRadius: AppDimens.radiusLarge,
        border: Border.all(
          color: semanticColors.success?.withAlpha(75) ??
              colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_user,
            size: 18,
            color: semanticColors.success,
          ),
          const SizedBox(width: 6),
          Text(
            'Health Check Verified: $formatted',
            style: textTheme.labelSmall?.copyWith(
              color: semanticColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String isoDate) {
    final parsed = DateTime.tryParse(isoDate);
    if (parsed == null) return isoDate;
    return DateFormat('MMM dd, yyyy').format(parsed);
  }
}
