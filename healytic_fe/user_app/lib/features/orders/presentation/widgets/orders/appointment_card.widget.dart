import 'package:flutter/material.dart';
import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';
import 'package:user_app/router/routes.dart';

/// Card displaying a single appointment with image,
/// status badge, provider info, address, and check-in.
class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key, required this.appointment});

  final AppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => OrderDetailsRoute(
          appointmentId: appointment.id,
        ).push<void>(context),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ImageSection(appointment: appointment),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TitleRow(appointment: appointment),
                    const SizedBox(height: 4),
                    _ProviderInfo(appointment: appointment),
                    const Divider(height: 24),
                    _AddressRow(appointment: appointment),
                    const SizedBox(height: 12),
                    _CheckInRow(appointment: appointment),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Private sub-widgets ───────────────────────────

class _ImageSection extends StatelessWidget {
  const _ImageSection({required this.appointment});
  final AppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 192,
          width: double.infinity,
          child: Image.network(
            appointment.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Center(child: Icon(Icons.image_not_supported)),
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              appointment.duration,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.appointment});
  final AppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            appointment.serviceName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        _StatusBadge(status: appointment.status),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (bgColor, textColor, label) = switch (status) {
      'upcoming' => (colors.primaryContainer, colors.primary, 'Upcoming'),
      'completed' => (colors.tertiaryContainer, colors.tertiary, 'Completed'),
      'canceled' => (colors.errorContainer, colors.error, 'Canceled'),
      _ => (colors.surfaceContainerHighest, colors.onSurfaceVariant, status),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ProviderInfo extends StatelessWidget {
  const _ProviderInfo({required this.appointment});
  final AppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    final dayName = _shortDayName(appointment.date);
    final day = appointment.date.day;

    return Text(
      '$dayName $day • Service by '
      '${appointment.providerName}',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  String _shortDayName(DateTime date) {
    const days = [
      'Mon', 'Tue', 'Wed', 'Thu',
      'Fri', 'Sat', 'Sun', //
    ];
    return days[date.weekday - 1];
  }
}

class _AddressRow extends StatelessWidget {
  const _AddressRow({required this.appointment});
  final AppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            appointment.address,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton.tonal(
          onPressed: () {
            OrderDetailsRoute(
              appointmentId: appointment.id,
            ).push<void>(context);
          },
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          ),
          child: Text('Details', style: theme.textTheme.labelLarge),
        ),
      ],
    );
  }
}

class _CheckInRow extends StatelessWidget {
  const _CheckInRow({required this.appointment});
  final AppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dayName = _shortDayName(appointment.date);
    final day = appointment.date.day;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _DateBadge(dayName: dayName, day: day),
          const SizedBox(width: 12),
          _CalendarIcon(theme: theme),
          const SizedBox(width: 12),
          Text(
            'Check in at ${appointment.checkInTime}',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _shortDayName(DateTime date) {
    const days = [
      'Mon', 'Tue', 'Wed', 'Thu',
      'Fri', 'Sat', 'Sun', //
    ];
    return days[date.weekday - 1];
  }
}

class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.dayName, required this.day});

  final String dayName;
  final int day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dayName,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
          Text(
            '$day',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarIcon extends StatelessWidget {
  const _CalendarIcon({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 40,
      height: 48,
      decoration: BoxDecoration(
        color: colors.tertiaryContainer,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: colors.tertiary.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.calendar_today_rounded,
          size: 18,
          color: colors.tertiary,
        ),
      ),
    );
  }
}
