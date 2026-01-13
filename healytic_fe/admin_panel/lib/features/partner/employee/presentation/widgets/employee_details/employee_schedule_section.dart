import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

class EmployeeScheduleSection extends StatelessWidget {
  final bool isEditing;

  const EmployeeScheduleSection({super.key, this.isEditing = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>()!;

    final days = [
      {'day': 'MON', 'time': '9-5', 'active': true},
      {'day': 'TUE', 'time': '9-5', 'active': true},
      {'day': 'WED', 'time': '9-5', 'active': true},
      {'day': 'THU', 'time': '9-5', 'active': true},
      {'day': 'FRI', 'time': '9-5', 'active': true},
      {'day': 'SAT', 'time': 'OFF', 'active': false},
      {'day': 'SUN', 'time': 'OFF', 'active': false},
    ];

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
            color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: AppDimens.radiusSmall,
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              Container(
                padding: AppDimens.paddingAllMedium,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: colorScheme.outlineVariant),
                  ),
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
                            Icon(
                              Icons.wb_sunny,
                              size: 18,
                              color: semanticColors.warning,
                            ),
                            AppDimens.horizontalSmall,
                            Text(
                              'Full Time - Morning',
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
                          '40h',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: AppDimens.paddingAllMedium,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: days.map((day) {
                    final isActive = day['active'] as bool;
                    return Opacity(
                      opacity: isActive ? 1.0 : 0.5,
                      child: Column(
                        children: [
                          Text(
                            day['day'] as String,
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
                            day['time'] as String,
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
}
