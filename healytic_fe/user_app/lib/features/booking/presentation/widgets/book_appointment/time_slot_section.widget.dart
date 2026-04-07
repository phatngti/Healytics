import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';

import '../../../domain/entities/time_slot.entity.dart';
import '../../providers/booking.provider.dart';

/// Time slots grouped by period (Morning / Afternoon)
/// displayed in a 3-column grid.
///
/// Fetches real data from the time-slots API for
/// [employeeId] and filters by [selectedDate].
///
/// Each slot can be available, selected, or disabled
/// (busy). Reports the selected index via
/// [onSelected].
class TimeSlotSection extends ConsumerWidget {
  const TimeSlotSection({
    super.key,
    required this.employeeId,
    required this.selectedDate,
    required this.selectedIndex,
    required this.onSelected,
  });

  /// Employee whose schedule to fetch.
  final String employeeId;

  /// Date selected in the date picker row.
  final DateTime selectedDate;

  /// Currently selected slot index (-1 = none).
  final int selectedIndex;

  /// Callback when a slot is tapped.
  /// Reports the slot index and its display label.
  final void Function(int index, String label) onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);

    final timeSlotsAsync = ref.watch(
      employeeTimeSlotsProvider(employeeId, date: dateStr),
    );

    return timeSlotsAsync.when(
      loading: () => _buildLoading(context),
      error: (e, _) => _buildError(context, e),
      data: (entity) {
        final daySlots = _findSlotsForDate(entity, dateStr);

        if (daySlots == null || daySlots.isEmpty) {
          return _buildEmpty(context);
        }

        final morning = <_IndexedSlot>[];
        final afternoon = <_IndexedSlot>[];

        for (var i = 0; i < daySlots.length; i++) {
          final slot = daySlots[i];
          final indexed = _IndexedSlot(slot: slot, index: i);
          if (_isMorning(slot.time)) {
            morning.add(indexed);
          } else {
            afternoon.add(indexed);
          }
        }

        return Column(
          children: [
            if (morning.isNotEmpty)
              _PeriodGroup(
                icon: Symbols.light_mode,
                label: 'Morning',
                slots: morning,
                selectedIndex: selectedIndex,
                onSlotSelected: onSelected,
              ),
            if (morning.isNotEmpty && afternoon.isNotEmpty)
              SizedBox(height: AppDimens.spaceXxl),
            if (afternoon.isNotEmpty)
              _PeriodGroup(
                icon: Symbols.wb_sunny,
                label: 'Afternoon',
                slots: afternoon,
                selectedIndex: selectedIndex,
                onSlotSelected: onSelected,
              ),
          ],
        );
      },
    );
  }

  /// Finds the day schedule matching [dateStr] and
  /// returns its slots. Returns null when the day
  /// is not a working day or is missing.
  List<TimeSlotEntity>? _findSlotsForDate(
    EmployeeTimeSlotsEntity entity,
    String dateStr,
  ) {
    for (final day in entity.schedule) {
      if (day.date == dateStr) {
        if (!day.isWorkingDay) return null;
        return day.slots;
      }
    }
    return null;
  }

  /// Returns true when [time24] (HH:mm) is before
  /// noon.
  bool _isMorning(String time24) {
    final hour = int.tryParse(time24.split(':').first) ?? 0;
    return hour < 12;
  }

  Widget _buildLoading(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    log('TimeSlotSection error: $error');
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimens.spaceLg),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Symbols.error,
              color: colorScheme.error,
              size: AppDimens.iconLg,
            ),
            SizedBox(height: AppDimens.spaceSm),
            Text(
              'Failed to load time slots',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colorScheme.error),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimens.spaceLg),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Symbols.event_busy,
              color: colorScheme.onSurfaceVariant,
              size: AppDimens.iconLg,
            ),
            SizedBox(height: AppDimens.spaceSm),
            Text(
              'No available slots for this date',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pairs a [TimeSlotEntity] with its positional
/// index in the day's slot list.
class _IndexedSlot {
  final TimeSlotEntity slot;
  final int index;

  const _IndexedSlot({required this.slot, required this.index});
}

/// A group of time slots with period icon header.
class _PeriodGroup extends StatelessWidget {
  const _PeriodGroup({
    required this.icon,
    required this.label,
    required this.slots,
    required this.selectedIndex,
    required this.onSlotSelected,
  });

  final IconData icon;
  final String label;
  final List<_IndexedSlot> slots;
  final int selectedIndex;
  final void Function(int index, String label) onSlotSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Period header
        Row(
          children: [
            Icon(icon, size: AppDimens.iconMd, color: colorScheme.primary),
            SizedBox(width: AppDimens.spaceSm),
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimens.spaceMd),

        // 3-column grid
        LayoutBuilder(
          builder: (context, constraints) {
            final spacing = AppDimens.spaceMd;
            final itemWidth = (constraints.maxWidth - spacing * 2) / 3;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: slots.map((indexed) {
                return SizedBox(
                  width: itemWidth,
                  child: _TimeChip(
                    label: indexed.slot.label,
                    isSelected: indexed.index == selectedIndex,
                    isDisabled: !indexed.slot.isAvailable,
                    onTap: indexed.slot.isAvailable
                        ? () => onSlotSelected(
                              indexed.index,
                              indexed.slot.label,
                            )
                        : null,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

/// Individual time slot chip with 3 states.
class _TimeChip extends StatelessWidget {
  const _TimeChip({
    required this.label,
    required this.isSelected,
    required this.isDisabled,
    this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color bgColor;
    final Color textColor;
    final Color borderColor;

    if (isDisabled) {
      bgColor = colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
      textColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.4);
      borderColor = Colors.transparent;
    } else if (isSelected) {
      bgColor = colorScheme.primary;
      textColor = colorScheme.onPrimary;
      borderColor = colorScheme.primary;
    } else {
      bgColor = colorScheme.surface;
      textColor = colorScheme.primary;
      borderColor = colorScheme.primary;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppDimens.radiusMediumSmall,
          border: Border.all(color: borderColor),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: textColor,
              fontWeight: isSelected || !isDisabled
                  ? FontWeight.w600
                  : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
