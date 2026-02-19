import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// An inline calendar widget that displays a month grid
/// with selectable and disabled dates.
///
/// Shows month/year header with navigation arrows,
/// weekday labels, and a grid of day cells. Dates can
/// be individually disabled via [enabledDates] or
/// [disabledDates].
class InlineCalendar extends StatefulWidget {
  /// Creates an [InlineCalendar].
  const InlineCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.enabledDates,
    this.disabledDates,
  });

  /// The currently selected date.
  final DateTime selectedDate;

  /// Called when a user taps an enabled date cell.
  final ValueChanged<DateTime> onDateSelected;

  /// Earliest navigable month (defaults to today).
  final DateTime? firstDate;

  /// Latest navigable month (defaults to +1 year).
  final DateTime? lastDate;

  /// If provided, only these dates are selectable.
  /// Takes precedence over [disabledDates].
  final Set<DateTime>? enabledDates;

  /// Dates that should appear dimmed and non-tappable.
  /// Ignored when [enabledDates] is provided.
  final Set<DateTime>? disabledDates;

  @override
  State<InlineCalendar> createState() => _InlineCalendarState();
}

class _InlineCalendarState extends State<InlineCalendar> {
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
    );
  }

  DateTime get _effectiveFirstDate =>
      _dateOnly(widget.firstDate ?? DateTime.now());

  DateTime get _effectiveLastDate => _dateOnly(
    widget.lastDate ?? DateTime.now().add(const Duration(days: 365)),
  );

  bool get _canGoBack {
    final prev = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    return !prev.isBefore(
      DateTime(_effectiveFirstDate.year, _effectiveFirstDate.month),
    );
  }

  bool get _canGoForward {
    final next = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    return !next.isAfter(
      DateTime(_effectiveLastDate.year, _effectiveLastDate.month),
    );
  }

  void _goToPreviousMonth() {
    if (!_canGoBack) return;
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _goToNextMonth() {
    if (!_canGoForward) return;
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  bool _isDateEnabled(DateTime date) {
    final d = _dateOnly(date);
    if (d.isBefore(_effectiveFirstDate)) return false;
    if (d.isAfter(_effectiveLastDate)) return false;

    if (widget.enabledDates != null) {
      return widget.enabledDates!.contains(d);
    }
    if (widget.disabledDates != null) {
      return !widget.disabledDates!.contains(d);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // Month navigation header
        _MonthHeader(
          month: _displayedMonth,
          canGoBack: _canGoBack,
          canGoForward: _canGoForward,
          onPrevious: _goToPreviousMonth,
          onNext: _goToNextMonth,
        ),
        AppDimens.verticalMediumSmall,

        // Weekday labels
        _WeekdayLabels(textTheme: textTheme, colorScheme: colorScheme),
        AppDimens.verticalSmall,

        // Day grid
        _DayGrid(
          displayedMonth: _displayedMonth,
          selectedDate: widget.selectedDate,
          isDateEnabled: _isDateEnabled,
          onDateSelected: widget.onDateSelected,
        ),
      ],
    );
  }
}

// ───────────────────────────────────────────────────
// Month header with arrows
// ───────────────────────────────────────────────────

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.month,
    required this.canGoBack,
    required this.canGoForward,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime month;
  final bool canGoBack;
  final bool canGoForward;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _NavButton(
          icon: Icons.chevron_left,
          enabled: canGoBack,
          onTap: onPrevious,
        ),
        Text(
          '${_monthNames[month.month - 1]} '
          '${month.year}',
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        _NavButton(
          icon: Icons.chevron_right,
          enabled: canGoForward,
          onTap: onNext,
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled
              ? colorScheme.surfaceContainerHighest
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: AppDimens.iconSm,
          color: enabled
              ? colorScheme.onSurface
              : colorScheme.onSurface.withValues(alpha: 0.2),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────
// Weekday labels (Mon – Sun)
// ───────────────────────────────────────────────────

class _WeekdayLabels extends StatelessWidget {
  const _WeekdayLabels({required this.textTheme, required this.colorScheme});

  final TextTheme textTheme;
  final ColorScheme colorScheme;

  static const _labels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _labels
          .map(
            (label) => Expanded(
              child: Center(
                child: Text(
                  label,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

// ───────────────────────────────────────────────────
// Day grid
// ───────────────────────────────────────────────────

class _DayGrid extends StatelessWidget {
  const _DayGrid({
    required this.displayedMonth,
    required this.selectedDate,
    required this.isDateEnabled,
    required this.onDateSelected,
  });

  final DateTime displayedMonth;
  final DateTime selectedDate;
  final bool Function(DateTime) isDateEnabled;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final cells = _buildCells();

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: cells,
    );
  }

  List<Widget> _buildCells() {
    final year = displayedMonth.year;
    final month = displayedMonth.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;

    // Monday = 1, Sunday = 7
    final firstWeekday = DateTime(year, month, 1).weekday;

    // Leading empty cells (Mon-based week)
    final leadingBlanks = firstWeekday - 1;

    final cells = <Widget>[];

    // Empty leading cells
    for (var i = 0; i < leadingBlanks; i++) {
      cells.add(const SizedBox.shrink());
    }

    // Day cells
    final today = DateTime.now();
    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final isSelected = _isSameDay(date, selectedDate);
      final isToday = _isSameDay(date, today);
      final enabled = isDateEnabled(date);

      cells.add(
        _DayCell(
          day: day,
          isSelected: isSelected,
          isToday: isToday,
          isEnabled: enabled,
          onTap: () => onDateSelected(date),
        ),
      );
    }

    return cells;
  }
}

// ───────────────────────────────────────────────────
// Individual day cell
// ───────────────────────────────────────────────────

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.isEnabled,
    required this.onTap,
  });

  final int day;
  final bool isSelected;
  final bool isToday;
  final bool isEnabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Color bgColor;
    Color textColor;
    BoxBorder? border;

    if (isSelected) {
      bgColor = colorScheme.primary;
      textColor = colorScheme.onPrimary;
    } else if (isToday) {
      bgColor = Colors.transparent;
      textColor = colorScheme.primary;
      border = Border.all(color: colorScheme.primary, width: 1.5);
    } else if (!isEnabled) {
      bgColor = Colors.transparent;
      textColor = colorScheme.onSurface.withValues(alpha: 0.25);
    } else {
      bgColor = Colors.transparent;
      textColor = colorScheme.onSurface;
    }

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: border,
          ),
          alignment: Alignment.center,
          child: Text(
            '$day',
            style: textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: isSelected || isToday
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
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
