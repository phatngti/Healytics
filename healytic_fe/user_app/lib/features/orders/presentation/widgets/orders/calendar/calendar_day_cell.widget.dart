import 'package:flutter/material.dart';

/// Builds custom day cells for the three calendar
/// day states: default, selected, and today.
///
/// Each returns a [Column] with the day number at
/// the top, leaving space for markers below.
class CalendarDayCellBuilder {
  const CalendarDayCellBuilder._();

  /// Regular (unselected, not-today) day cell.
  static Widget defaultCell(BuildContext context, DateTime day) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 56,
      child: Column(
        children: [
          const SizedBox(height: 4),
          Text(
            '${day.day}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Selected day: filled primary circle with
  /// white bold text and subtle drop shadow.
  static Widget selectedCell(BuildContext context, DateTime day) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      height: 56,
      child: Column(
        children: [
          const SizedBox(height: 4),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Today indicator (when not selected): outlined
  /// circle with primary border, common UX pattern.
  static Widget todayCell(BuildContext context, DateTime day) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      height: 56,
      child: Column(
        children: [
          const SizedBox(height: 4),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colors.primary, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
