import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Displays professional level badges and time-joined
/// info derived from [EmployeeEntity].
class EmployeeBadgesStrength extends StatelessWidget {
  /// The employee entity to display data for.
  final EmployeeEntity employee;

  /// Whether the parent form is in editing mode.
  final bool isEditing;

  const EmployeeBadgesStrength({
    super.key,
    required this.employee,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PROFESSIONAL LEVEL',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _LevelBadge(label: _levelLabel),
            _LevelBadge(
              label: _typeLabel,
              showBorder: true,
            ),
          ],
        ),
        AppDimens.verticalMedium,
        Text(
          'TIME JOINED',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        AppDimens.verticalSmall,
        _TimeJoinedCard(startDate: employee.startDate),
      ],
    );
  }

  /// Returns the level label based on employee type.
  String get _levelLabel {
    return switch (employee) {
      DoctorEntity() => 'DOCTOR',
      SpaTherapistEntity e =>
        e.therapistLevel?.toUpperCase() ?? 'THERAPIST',
      MassageTherapistEntity e =>
        e.therapistLevel?.toUpperCase() ?? 'THERAPIST',
      _ => employee.role.toUpperCase(),
    };
  }

  /// Returns the type/speciality label.
  String get _typeLabel {
    return switch (employee) {
      DoctorEntity e => e.jobTitle,
      SpaTherapistEntity() => 'Spa Therapist',
      MassageTherapistEntity() => 'Massage Therapist',
      _ => employee.position,
    };
  }
}

class _LevelBadge extends StatelessWidget {
  final String label;
  final bool showBorder;

  const _LevelBadge({
    required this.label,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: AppDimens.radiusSmall,
        border: showBorder
            ? Border.all(color: colorScheme.outlineVariant)
            : null,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _TimeJoinedCard extends StatelessWidget {
  final String? startDate;

  const _TimeJoinedCard({required this.startDate});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (duration, since) = _computeJoinedInfo();

    return Container(
      padding: AppDimens.paddingAllMediumSmall,
      decoration: BoxDecoration(
        borderRadius: AppDimens.radiusSmall,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.schedule,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                duration,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                since,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  (String, String) _computeJoinedInfo() {
    if (startDate == null || startDate!.isEmpty) {
      return ('Unknown', 'Start date not set');
    }
    final parsed = DateTime.tryParse(startDate!);
    if (parsed == null) {
      return ('Unknown', 'Invalid date');
    }

    final now = DateTime.now();
    final diff = now.difference(parsed);
    final totalMonths =
        (now.year - parsed.year) * 12 + now.month - parsed.month;
    final years = totalMonths ~/ 12;
    final months = totalMonths % 12;

    final parts = <String>[];
    if (years > 0) parts.add('$years Year${years > 1 ? 's' : ''}');
    if (months > 0) {
      parts.add('$months Month${months > 1 ? 's' : ''}');
    }
    if (parts.isEmpty && diff.inDays > 0) {
      parts.add('${diff.inDays} Days');
    }
    if (parts.isEmpty) parts.add('Just started');

    final monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final since =
        'Since ${monthNames[parsed.month - 1]} ${parsed.year}';

    return (parts.join(', '), since);
  }
}
