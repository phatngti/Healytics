import 'package:flutter/material.dart';
import '../../../domain/entities/employee_appointment.entity.dart';
import '../../../../../theme/app_theme.dart';

/// Color-coded status badge for appointments.
class AppointmentStatusBadge extends StatelessWidget {
  final EmployeeAppointmentStatus status;

  const AppointmentStatusBadge({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    final (color, bgColor) = _statusColors(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayLabel,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (Color, Color) _statusColors(BuildContext context) {
    final semantics = Theme.of(context).extension<SemanticColors>();
    final scheme = Theme.of(context).colorScheme;

    return switch (status) {
      EmployeeAppointmentStatus.upcoming => (
        scheme.primary,
        scheme.primary.withValues(alpha: 0.12),
      ),
      EmployeeAppointmentStatus.inProgress => (
        semantics?.info ?? Colors.blue,
        (semantics?.info ?? Colors.blue).withValues(alpha: 0.12),
      ),
      EmployeeAppointmentStatus.completed => (
        semantics?.success ?? Colors.green,
        (semantics?.success ?? Colors.green).withValues(alpha: 0.12),
      ),
      EmployeeAppointmentStatus.canceled => (
        scheme.error,
        scheme.error.withValues(alpha: 0.12),
      ),
    };
  }
}
