import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Displays the weekly work schedule from
/// [EmployeeSchedule] data.
class EmployeeScheduleSection extends StatelessWidget {
  /// Work schedule entries for the week.
  final List<EmployeeSchedule> schedule;

  /// Employment type label (e.g. 'Full-Time').
  final String? employmentType;

  /// Whether the parent form is in editing mode.
  final bool isEditing;

  const EmployeeScheduleSection({
    super.key,
    required this.schedule,
    this.employmentType,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>()!;

    final days = _buildDayList();
    final weeklyHours = _computeWeeklyHours();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WORK SCHEDULE SUMMARY',
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        AppDimens.verticalMedium,
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withAlpha(128),
            borderRadius: AppDimens.radiusSmall,
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              _ShiftHeader(
                employmentType: employmentType,
                weeklyHours: weeklyHours,
              ),
              Padding(
                padding: AppDimens.paddingAllMedium,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: days.map((day) {
                    final isActive = day.isWorking;
                    return Opacity(
                      opacity: isActive ? 1.0 : 0.5,
                      child: Column(
                        children: [
                          Text(
                            day.dayAbbr,
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AppDimens.verticalExtraSmall,
                          Container(
                            width: 32,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? semanticColors.success
                                  : colorScheme.outlineVariant,
                              borderRadius: AppDimens.radiusExtraSmall,
                            ),
                          ),
                          AppDimens.verticalExtraSmall,
                          Text(
                            day.timeLabel,
                            style: textTheme.labelSmall?.copyWith(
                              color: isActive
                                  ? null
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<_DayDisplay> _buildDayList() {
    if (schedule.isEmpty) {
      return _defaultWeek;
    }

    return schedule.map((s) {
      final abbr = _abbreviateDay(s.day);
      final time = s.isWorking
          ? '${_formatHour(s.start)}-${_formatHour(s.end)}'
          : 'OFF';
      return _DayDisplay(
        dayAbbr: abbr,
        timeLabel: time,
        isWorking: s.isWorking,
        startHour: _parseHour(s.start),
        endHour: _parseHour(s.end),
      );
    }).toList();
  }

  String _abbreviateDay(String day) {
    if (day.length >= 3) return day.substring(0, 3).toUpperCase();
    return day.toUpperCase();
  }

  String _formatHour(String time) {
    final parts = time.split(':');
    if (parts.isEmpty) return time;
    return parts[0];
  }

  double _parseHour(String time) {
    final parts = time.split(':');
    if (parts.isEmpty) return 0;
    final h = double.tryParse(parts[0]) ?? 0;
    final m = parts.length > 1 ? (double.tryParse(parts[1]) ?? 0) / 60 : 0.0;
    return h + m;
  }

  int _computeWeeklyHours() {
    var total = 0.0;
    for (final s in schedule) {
      if (!s.isWorking) continue;
      final start = _parseHour(s.start);
      final end = _parseHour(s.end);
      if (end > start) total += end - start;
    }
    return total.round();
  }

  static final _defaultWeek = [
    for (final d in ['MON', 'TUE', 'WED', 'THU', 'FRI'])
      _DayDisplay(
        dayAbbr: d,
        timeLabel: '9-17',
        isWorking: true,
        startHour: 9,
        endHour: 17,
      ),
    for (final d in ['SAT', 'SUN'])
      _DayDisplay(
        dayAbbr: d,
        timeLabel: 'OFF',
        isWorking: false,
        startHour: 0,
        endHour: 0,
      ),
  ];
}

class _DayDisplay {
  final String dayAbbr;
  final String timeLabel;
  final bool isWorking;
  final double startHour;
  final double endHour;

  const _DayDisplay({
    required this.dayAbbr,
    required this.timeLabel,
    required this.isWorking,
    required this.startHour,
    required this.endHour,
  });
}

class _ShiftHeader extends StatelessWidget {
  final String? employmentType;
  final int weeklyHours;

  const _ShiftHeader({required this.employmentType, required this.weeklyHours});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>()!;

    return Container(
      padding: AppDimens.paddingAllMedium,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shift Type',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              AppDimens.verticalExtraSmall,
              Row(
                children: [
                  Icon(Icons.wb_sunny, size: 18, color: semanticColors.warning),
                  AppDimens.horizontalSmall,
                  Text(
                    employmentType ?? 'Not specified',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Weekly Hours',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              AppDimens.verticalExtraSmall,
              Text(
                '${weeklyHours}h',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
