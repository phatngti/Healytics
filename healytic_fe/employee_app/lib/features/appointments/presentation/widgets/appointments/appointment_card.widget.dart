import 'package:common/widgets/images/avatar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/employee_appointment.entity.dart';
import 'appointment_status_badge.widget.dart';
import '../../../../../router/routes.dart';

/// Card widget displaying appointment summary in a
/// modern horizontal layout with customer avatar.
///
/// Matches the premium card design with rounded-24
/// corners, subtle shadow, and tap-to-detail
/// navigation.
class AppointmentCard extends StatelessWidget {
  final EmployeeAppointmentEntity appointment;

  const AppointmentCard({
    required this.appointment,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => AppointmentDetailRoute(
        id: appointment.id,
      ).push(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _CardContent(
                appointment: appointment,
                textTheme: tt,
                colorScheme: cs,
              ),
            ),
            const SizedBox(width: 12),
            _TrailingSection(
              appointment: appointment,
              colorScheme: cs,
            ),
          ],
        ),
      ),
    );
  }
}

/// Left-side content: service name, info rows,
/// status badge, and price.
class _CardContent extends StatelessWidget {
  final EmployeeAppointmentEntity appointment;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  const _CardContent({
    required this.appointment,
    required this.textTheme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appointment.serviceName,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        _InfoRow(
          icon: Icons.person_outline,
          text: appointment.customerName,
        ),
        const SizedBox(height: 2),
        _InfoRow(
          icon: Icons.schedule,
          text:
              '${appointment.checkInTime}'
              ' - ${appointment.checkOutTime}',
        ),
        const SizedBox(height: 2),
        _InfoRow(
          icon: Icons.location_on_outlined,
          text: appointment.clinicName,
        ),
        const SizedBox(height: 8),
        _BottomRow(
          appointment: appointment,
          textTheme: textTheme,
          colorScheme: colorScheme,
        ),
      ],
    );
  }
}

/// Status badge + price row at the card bottom.
class _BottomRow extends StatelessWidget {
  final EmployeeAppointmentEntity appointment;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  const _BottomRow({
    required this.appointment,
    required this.textTheme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppointmentStatusBadge(
          status: appointment.status,
        ),
        if (appointment.price != null) ...[
          const SizedBox(width: 12),
          Text(
            NumberFormat.currency(
              locale: 'vi_VN',
              symbol: '₫',
              decimalDigits: 0,
            ).format(appointment.price),
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

/// Right-side: customer avatar + chevron.
class _TrailingSection extends StatelessWidget {
  final EmployeeAppointmentEntity appointment;
  final ColorScheme colorScheme;

  const _TrailingSection({
    required this.appointment,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AvatarImage(
          name: appointment.customerName,
          imageUrl: appointment.imageUrl,
          radius: 24,
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.chevron_right,
          color: colorScheme.outlineVariant,
        ),
      ],
    );
  }
}

/// Compact icon + text row for appointment metadata.
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context)
              .colorScheme
              .onSurfaceVariant,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
