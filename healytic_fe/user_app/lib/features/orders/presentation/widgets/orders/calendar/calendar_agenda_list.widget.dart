import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:user_app/features/orders/presentation/providers/appointment.provider.dart';
import 'package:user_app/features/orders/presentation/widgets/orders/calendar/calendar_agenda_card.widget.dart';

/// Agenda section below the calendar showing
/// appointments for the selected day.
///
/// Displays a formatted date header with
/// appointment count badge, followed by a list
/// of [CalendarAgendaCard] widgets.
class CalendarAgendaList extends ConsumerWidget {
  const CalendarAgendaList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(calendarSelectedDayProvider);
    final asyncAppointments = ref.watch(appointmentsForDayProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DaySpacer(),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.horizontalPadding(context),
            vertical: AppDimens.spaceXl,
          ),
          child: switch (asyncAppointments) {
            AsyncData(:final value) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AgendaHeader(date: selectedDay, count: value.length),
                SizedBox(height: AppDimens.spaceLg),
                if (value.isEmpty)
                  const _EmptyDayState()
                else
                  ...value.map(
                    (apt) => Padding(
                      padding: EdgeInsets.only(bottom: AppDimens.spaceLg),
                      child: CalendarAgendaCard(appointment: apt),
                    ),
                  ),
              ],
            ),
            AsyncError(:final error) => Center(child: Text('Error: $error')),
            _ => const Center(
              child: Padding(
                padding: AppDimens.paddingAllLarge,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          },
        ),
      ],
    );
  }
}

// ─── Divider spacer ────────────────────────────────

/// 8dp gray spacer matching the HTML `h-2 bg-gray`
/// visual separator between calendar and agenda.
class _DaySpacer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
    );
  }
}

// ─── Agenda header ─────────────────────────────────

class _AgendaHeader extends StatelessWidget {
  const _AgendaHeader({required this.date, required this.count});

  final DateTime date;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final formatted = DateFormat('EEEE, MMMM d').format(date);

    return Row(
      children: [
        Expanded(
          child: Text(
            formatted,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (count > 0)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMd,
              vertical: AppDimens.spaceXs,
            ),
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
              borderRadius: AppDimens.radiusPill,
            ),
            child: Text(
              '$count Appointment${count != 1 ? 's' : ''}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colors.onSecondaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Empty day state ───────────────────────────────

class _EmptyDayState extends StatelessWidget {
  const _EmptyDayState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimens.spaceXxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_available_rounded,
              size: 48,
              color: colors.onSurfaceVariant.withValues(alpha: 0.3),
            ),
            AppDimens.verticalSmall,
            Text(
              'No appointments on this day',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
