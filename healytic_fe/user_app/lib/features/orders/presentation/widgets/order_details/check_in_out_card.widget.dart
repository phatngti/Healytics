import 'package:flutter/material.dart';
import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';

/// Card displaying check-in and check-out times
/// side-by-side with a vertical divider.
class CheckInOutCard extends StatelessWidget {
  const CheckInOutCard({super.key, required this.appointment});

  /// The appointment whose times are displayed.
  final AppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final dateLabel = _formatDate(appointment.date);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TimeColumn(
              label: 'Check-in',
              date: dateLabel,
              time: appointment.checkInTime,
            ),
          ),
          Container(width: 1, height: 56, color: colors.outlineVariant),
          Expanded(
            child: _TimeColumn(
              label: 'Check-out',
              date: dateLabel,
              time: appointment.checkOutTime,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const days = [
      'Mon', 'Tue', 'Wed', 'Thu',
      'Fri', 'Sat', 'Sun', //
    ];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr',
      'May', 'Jun', 'Jul', 'Aug',
      'Sep', 'Oct', 'Nov', 'Dec', //
    ];
    final day = days[date.weekday - 1];
    final month = months[date.month - 1];
    return '$day, $month ${date.day}';
  }
}

// ─── Time column ───────────────────────────────────

class _TimeColumn extends StatelessWidget {
  const _TimeColumn({
    required this.label,
    required this.date,
    required this.time,
  });

  final String label;
  final String date;
  final String time;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          date,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          time,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
