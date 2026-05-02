import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/employee_appointment.entity.dart';
import 'appointment_status_badge.widget.dart';
import '../../../../../router/routes.dart';

/// Card widget displaying appointment summary.
class AppointmentCard extends StatelessWidget {
  final EmployeeAppointmentEntity appointment;

  const AppointmentCard({required this.appointment, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          AppointmentDetailRoute(id: appointment.id).push(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      appointment.serviceName,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  AppointmentStatusBadge(status: appointment.status),
                ],
              ),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.person_outline,
                text: appointment.customerName,
              ),
              const SizedBox(height: 4),
              _InfoRow(
                icon: Icons.calendar_today_outlined,
                text: DateFormat('EEE, MMM d').format(appointment.date),
              ),
              const SizedBox(height: 4),
              _InfoRow(
                icon: Icons.access_time,
                text:
                    '${appointment.checkInTime} – '
                    '${appointment.checkOutTime} '
                    '(${appointment.duration})',
              ),
              const SizedBox(height: 4),
              _InfoRow(
                icon: Icons.location_on_outlined,
                text: appointment.clinicName,
              ),
              if (appointment.price != null) ...[
                const SizedBox(height: 8),
                Text(
                  NumberFormat.currency(
                    locale: 'vi_VN',
                    symbol: '₫',
                    decimalDigits: 0,
                  ).format(appointment.price),
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
