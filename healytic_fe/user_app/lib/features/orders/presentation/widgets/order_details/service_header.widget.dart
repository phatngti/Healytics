import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';

/// Displays the service name, vendor name, and
/// distance as the primary heading on the details
/// page.
class ServiceHeader extends StatelessWidget {
  const ServiceHeader({super.key, required this.appointment});

  /// The appointment whose service info is shown.
  final AppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appointment.serviceName,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        AppDimens.verticalExtraSmall,
        Text(
          appointment.healthPartnerName,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (appointment.distanceKm! > 0) ...[
          AppDimens.verticalSmall,
          _DistanceInfo(distanceKm: appointment.distanceKm!),
        ],
      ],
    );
  }
}

/// Inline distance indicator with a location icon.
class _DistanceInfo extends StatelessWidget {
  const _DistanceInfo({required this.distanceKm});
  final double distanceKm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final label = distanceKm < 10
        ? '${distanceKm.toStringAsFixed(1)} km'
        : '${distanceKm.round()} km';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.location_on_outlined,
          size: AppDimens.iconSm,
          color: colors.onSurfaceVariant,
        ),
        AppDimens.horizontalExtraSmall,
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
