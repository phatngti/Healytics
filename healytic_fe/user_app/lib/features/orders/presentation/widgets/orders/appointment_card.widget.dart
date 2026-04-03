import 'package:common/utils/demensions.dart';
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
      borderRadius: AppDimens.radiusMedium,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: AppDimens.radiusMedium,
        onTap: () => OrderDetailsRoute(
          appointmentId: appointment.id,
        ).push<void>(context),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppDimens.radiusMedium,
            border: Border.all(color: colors.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ImageSection(appointment: appointment),
              Padding(
                padding: AppDimens.paddingAllMedium,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TitleRow(appointment: appointment),
                    AppDimens.verticalExtraSmall,
                    _ProviderInfo(appointment: appointment),
                    Divider(height: AppDimens.spaceXxl),
                    _AddressRow(appointment: appointment),
                    AppDimens.verticalMediumSmall,
                    _CheckInRow(appointment: appointment),
                    if (appointment.status == 'completed') ...[
                      AppDimens.verticalMediumSmall,
                      _ReviewAction(appointment: appointment),
                    ],
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
          top: AppDimens.spaceLg,
          left: AppDimens.spaceLg,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMd,
              vertical: AppDimens.spaceXs,
            ),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 0.9),
              borderRadius: AppDimens.radiusMediumLarge,
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
        AppDimens.horizontalSmall,
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
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSm,
        vertical: AppDimens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.5),
        borderRadius: AppDimens.radiusExtraSmall,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
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
      '${appointment.specialistName}',
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
    final colors = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.address,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              if (appointment.distanceKm! > 0) ...[
                // 6dp — contextual visual spacing
                const SizedBox(height: 6),
                _DistanceChip(distanceKm: appointment.distanceKm!),
              ],
            ],
          ),
        ),
        AppDimens.horizontalMediumSmall,
        FilledButton(
          onPressed: () {
            OrderDetailsRoute(
              appointmentId: appointment.id,
            ).push<void>(context);
          },
          style: FilledButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.spaceXxl,
              vertical: AppDimens.spaceSm,
            ),
          ),
          child: Text(
            'Details',
            style: theme.textTheme.labelLarge?.copyWith(
              color: colors.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Compact chip showing distance to the clinic.
class _DistanceChip extends StatelessWidget {
  const _DistanceChip({required this.distanceKm});
  final double distanceKm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final label = distanceKm < 10
        ? '${distanceKm.toStringAsFixed(1)} km'
        : '${distanceKm.round()} km';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.spaceSm, vertical: 3),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_outlined,
            size: AppDimens.iconXs,
            color: colors.primary,
          ),
          AppDimens.horizontalExtraSmall,
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
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
      padding: AppDimens.paddingAllSmall,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: AppDimens.radiusMediumSmall,
      ),
      child: Row(
        children: [
          _DateBadge(dayName: dayName, day: day),
          AppDimens.horizontalMediumSmall,
          _CalendarIcon(),
          AppDimens.horizontalMediumSmall,
          Text(
            'Check in at '
            '${appointment.checkInTime}',
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
      width: AppDimens.touchTarget,
      height: AppDimens.avatarLg,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: AppDimens.radiusSmall,
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
  const _CalendarIcon();

  @override
  Widget build(BuildContext context) {
    const double doorWidth = AppDimens.touchTarget;
    const double doorHeight = AppDimens.avatarLg;
    return SizedBox(
      width: doorWidth,
      height: doorHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. The Base Frame (Creates the outer border and the darker bottom lip)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(
                  0xFFFBBF24,
                ), // Darker orange/yellow for bottom lip
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFFFCD34D), // Outer yellow border
                  width: AppDimens.borderWidthThick,
                ),
              ),
            ),
          ),

          // 2. The Inner Light Panel
          // We inset the top/left/right by the border width, but inset the bottom
          // much more to expose the dark orange base layer as a "3D lip".
          Positioned(
            top: AppDimens.borderWidthThick * 1.5,
            left: AppDimens.borderWidthThick * 1.2,
            right: AppDimens.borderWidthThick * 1.2,
            bottom:
                8.0, // Adjust this to make the bottom lip thicker or thinner
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFFDE68A), // Light yellow inner panel
                // Slightly tighter border radius so it fits nicely inside the parent
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                  bottom: Radius.circular(4),
                ),
              ),
            ),
          ),

          // 3. The Doorknob
          Positioned(
            left: doorWidth * 0.65, // Distance from the right edge
            top:
                doorHeight *
                0.35, // Offset slightly to account for the bottom lip
            child: Center(
              child: SizedBox(
                width: 10.0, // Knob size
                height: 10.0,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Color(0xFFD97706), // Brownish knob color
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Conditionally renders either a "Write a Review"
/// button or a "Reviewed ✓" chip depending on
/// whether the user has already reviewed.
class _ReviewAction extends StatelessWidget {
  const _ReviewAction({required this.appointment});
  final AppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    if (appointment.isReviewed) {
      return SizedBox.shrink();
    }
    return _WriteReviewButton(appointment: appointment);
  }
}

/// Tonal button that navigates to the review
/// treatment screen.
class _WriteReviewButton extends StatelessWidget {
  const _WriteReviewButton({required this.appointment});

  final AppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.tonal(
        onPressed: () => ReviewTreatmentRoute(
          appointmentId: appointment.id,
          serviceName: appointment.serviceName,
          vendorName: appointment.healthPartnerName,
        ).push<void>(context),
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary.withValues(alpha: 0.8),
          foregroundColor: colors.onPrimary,
          padding: EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimens.radiusMediumSmall,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: AppDimens.iconSm,
              color: colors.onPrimary,
            ),
            AppDimens.horizontalSmall,
            Text(
              'Write a Review',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Subtle chip indicating the appointment has
/// already been reviewed.
class _ReviewedChip extends StatelessWidget {
  const _ReviewedChip();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: AppDimens.radiusMediumSmall,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: AppDimens.iconSm,
            color: colors.tertiary,
          ),
          AppDimens.horizontalSmall,
          Text(
            'Reviewed',
            style: theme.textTheme.labelLarge?.copyWith(
              color: colors.tertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
