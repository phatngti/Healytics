import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';
import 'package:user_app/features/orders/presentation/providers/appointment.provider.dart';
import 'package:user_app/features/orders/presentation/widgets/orders/calendar/calendar_day_cell.widget.dart';
import 'package:user_app/features/orders/presentation/widgets/orders/calendar/calendar_marker.widget.dart';

/// Monthly calendar showing appointment density
/// per day with custom day cells and event markers.
///
/// Uses [TableCalendar] with [CalendarBuilders]
/// for full design customisation. The built-in
/// header is hidden; a custom [_CalendarHeader]
/// renders month title + chevron navigation.
class AppointmentCalendar extends ConsumerWidget {
  const AppointmentCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focused = ref.watch(calendarFocusedDayProvider);
    final selected = ref.watch(calendarSelectedDayProvider);
    final asyncMap = ref.watch(appointmentsByDateMapProvider);

    final dateMap = switch (asyncMap) {
      AsyncData(:final value) => value,
      _ => <DateTime, List<AppointmentEntity>>{},
    };

    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.horizontalPadding(context),
        vertical: AppDimens.spaceXl,
      ),
      child: Column(
        children: [
          _CalendarHeader(focused: focused, ref: ref),
          SizedBox(height: AppDimens.spaceXxl),
          TableCalendar<AppointmentEntity>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2035, 12, 31),
            focusedDay: focused,
            selectedDayPredicate: (day) => isSameDay(selected, day),
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            headerVisible: false,
            daysOfWeekHeight: 32,
            rowHeight: 56,
            eventLoader: (day) {
              final key = DateUtils.dateOnly(day);
              return dateMap[key] ?? [];
            },
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
              cellMargin: EdgeInsets.zero,
              cellPadding: EdgeInsets.zero,
              markerSize: 0,
              markersMaxCount: 0,
            ),
            calendarBuilders: CalendarBuilders(
              dowBuilder: _buildDow,
              defaultBuilder: (ctx, day, _) =>
                  CalendarDayCellBuilder.defaultCell(ctx, day),
              selectedBuilder: (ctx, day, _) =>
                  CalendarDayCellBuilder.selectedCell(ctx, day),
              todayBuilder: (ctx, day, _) =>
                  CalendarDayCellBuilder.todayCell(ctx, day),
              markerBuilder: (ctx, day, events) =>
                  CalendarMarkerBuilder.build(ctx, day, events),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              ref
                  .read(calendarSelectedDayProvider.notifier)
                  .select(selectedDay);
              ref.read(calendarFocusedDayProvider.notifier).update(focusedDay);
            },
            onPageChanged: (focusedDay) {
              ref.read(calendarFocusedDayProvider.notifier).update(focusedDay);
            },
          ),
        ],
      ),
    );
  }

  /// Day-of-week header: single uppercase letter.
  Widget? _buildDow(BuildContext context, DateTime day) {
    final theme = Theme.of(context);
    final label = DateFormat.E().format(day)[0];

    return Center(
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.outline,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

// ─── Custom calendar header ────────────────────────

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({required this.focused, required this.ref});

  final DateTime focused;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final title = DateFormat.yMMMM().format(focused);

    return Row(
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        _ChevronButton(
          icon: Icons.chevron_left,
          onTap: () => _navigateMonth(-1),
          colors: colors,
        ),
        SizedBox(width: AppDimens.spaceLg),
        _ChevronButton(
          icon: Icons.chevron_right,
          onTap: () => _navigateMonth(1),
          colors: colors,
        ),
      ],
    );
  }

  void _navigateMonth(int delta) {
    final newMonth = DateTime(focused.year, focused.month + delta);
    ref.read(calendarFocusedDayProvider.notifier).update(newMonth);
  }
}

// ─── Chevron navigation button ─────────────────────

class _ChevronButton extends StatelessWidget {
  const _ChevronButton({
    required this.icon,
    required this.onTap,
    required this.colors,
  });

  final IconData icon;
  final VoidCallback onTap;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppDimens.radiusSmall,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: AppDimens.radiusSmall,
            border: Border.all(color: colors.outlineVariant),
          ),
          child: Icon(
            icon,
            color: colors.onSurfaceVariant,
            size: AppDimens.iconMd,
          ),
        ),
      ),
    );
  }
}
