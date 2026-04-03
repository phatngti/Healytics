import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';

/// Horizontal scrollable row of date chips for the
/// next 14 days. Reports selected date via [onSelected].
class DatePickerRow extends StatelessWidget {
  const DatePickerRow({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _dayNames = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return SizedBox(
      height: AppDimens.adaptive(
        context,
        small: 80.0,
        medium: 88.0,
        large: 88.0,
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 14,
        separatorBuilder: (_, __) =>
            SizedBox(width: AppDimens.spaceMd),
        itemBuilder: (context, index) {
          final date = now.add(Duration(days: index));
          final dayName =
              _dayNames[date.weekday - 1];
          final dayNumber = '${date.day}';
          final isToday = index == 0;

          return _DateChip(
            dayName: isToday ? 'Today' : dayName,
            dayNumber: dayNumber,
            isSelected: index == selectedIndex,
            onTap: () => onSelected(index),
          );
        },
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.dayName,
    required this.dayNumber,
    required this.isSelected,
    required this.onTap,
  });

  final String dayName;
  final String dayNumber;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final chipWidth = AppDimens.adaptive(
      context,
      small: 56.0,
      medium: 62.0,
      large: 62.0,
    );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: chipWidth,
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.surfaceContainerLow,
          borderRadius: AppDimens.radiusMediumSmall,
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary
                        .withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: AppDimens.spaceXxs),
            Text(
              dayNumber,
              style: theme.textTheme.titleMedium?.copyWith(
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
