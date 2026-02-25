import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// A horizontal scrollable row of date chips for selecting
/// a day from a range, with an optional "Show More" button.
///
/// Dates can be individually disabled via [disabledDates].
/// Today's chip shows `"Today"` instead of the weekday name.
class HorizontalDateSelector extends StatelessWidget {
  /// Creates a [HorizontalDateSelector].
  const HorizontalDateSelector({
    super.key,
    required this.firstDate,
    required this.selectedDate,
    required this.onDateSelected,
    this.dayCount = 7,
    this.disabledDates = const {},
    this.onShowMore,
  });

  /// The first date shown (usually today).
  final DateTime firstDate;

  /// The currently selected date.
  final DateTime selectedDate;

  /// Called when a user taps an enabled date chip.
  final ValueChanged<DateTime> onDateSelected;

  /// Number of consecutive days to display.
  final int dayCount;

  /// Dates that should appear dimmed and non-tappable.
  final Set<DateTime> disabledDates;

  /// Optional callback for the "Show More" button.
  /// When provided, a calendar icon chip is appended
  /// to the end of the date list.
  final VoidCallback? onShowMore;

  @override
  Widget build(BuildContext context) {
    final dates = List.generate(
      dayCount,
      (i) => _dateOnly(firstDate.add(Duration(days: i))),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (int i = 0; i < dates.length; i++) ...[
            if (i > 0) AppDimens.horizontalSmall,
            _DateChip(
              date: dates[i],
              isSelected: _isSameDay(dates[i], selectedDate),
              isDisabled: disabledDates.contains(dates[i]),
              isToday: _isSameDay(dates[i], DateTime.now()),
              onTap: () => onDateSelected(dates[i]),
            ),
          ],
          if (onShowMore != null) ...[
            AppDimens.horizontalSmall,
            _ShowMoreChip(onTap: onShowMore!),
          ],
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────
// Individual date chip
// ───────────────────────────────────────────────────

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.date,
    required this.isSelected,
    required this.isDisabled,
    required this.isToday,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final bool isDisabled;
  final bool isToday;
  final VoidCallback onTap;

  static const _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final dayLabel = isToday ? 'Today' : _weekDays[date.weekday - 1];

    final dayNumber = '${date.day}';

    final effectiveOpacity = isDisabled ? 0.4 : 1.0;

    final bgColor = isSelected
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;

    final fgColor = isSelected ? colorScheme.onPrimary : colorScheme.onSurface;

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Opacity(
        opacity: effectiveOpacity,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 56,
          padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: AppDimens.radiusMediumSmall,
            border: isSelected
                ? null
                : Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dayLabel,
                style: textTheme.labelSmall?.copyWith(
                  color: fgColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dayNumber,
                style: textTheme.titleMedium?.copyWith(
                  color: fgColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────
// "Show More" calendar chip
// ───────────────────────────────────────────────────

/// A chip with a calendar icon that opens the full
/// date picker modal.
class _ShowMoreChip extends StatelessWidget {
  const _ShowMoreChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
        decoration: BoxDecoration(
          borderRadius: AppDimens.radiusMediumSmall,
          border: Border.all(color: colorScheme.primary),
          color: colorScheme.primary.withValues(alpha: 0.08),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month,
              size: AppDimens.iconSm,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 2),
            Text(
              'More',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────
// Helpers
// ───────────────────────────────────────────────────

/// Strips time component, returning date at midnight.
DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

/// Compares two dates ignoring time component.
bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
