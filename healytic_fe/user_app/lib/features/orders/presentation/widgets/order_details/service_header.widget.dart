import 'package:flutter/material.dart';
import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';

/// Displays the service name and vendor name
/// as the primary heading on the details page.
class ServiceHeader extends StatelessWidget {
  const ServiceHeader({super.key, required this.appointment});

  /// The appointment whose service info is shown.
  final AppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appointment.serviceName,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          appointment.vendorName,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
