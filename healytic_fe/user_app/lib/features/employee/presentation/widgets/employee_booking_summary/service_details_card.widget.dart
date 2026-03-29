import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';

/// Displays the selected service details:
/// service name and duration.
///
/// Shown on the employee booking summary screen
/// below the specialist card.
class ServiceDetailsCard extends StatelessWidget {
  const ServiceDetailsCard({
    super.key,
    required this.serviceName,
    required this.duration,
  });

  /// Service name (e.g. "Full Body Massage").
  final String serviceName;

  /// Formatted duration (e.g. "60 min").
  final String duration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardPad = AppDimens.cardPadding(context);

    return Container(
      padding: EdgeInsets.all(cardPad),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(
          AppDimens.cardRadius(context),
        ),
        border: Border.all(
          color: colorScheme.outlineVariant
              .withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow
                .withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(colorScheme: colorScheme),
          SizedBox(height: AppDimens.spaceMd),
          _ServiceRow(
            serviceName: serviceName,
            duration: duration,
          ),
        ],
      ),
    );
  }
}

/// Header label row for the service details card.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          Symbols.medical_services,
          size: AppDimens.iconSm,
          color: colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: AppDimens.spaceSm),
        Text(
          'SERVICE DETAILS',
          style: theme.textTheme.labelSmall
              ?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

/// Row showing service name and duration chip.
class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.serviceName,
    required this.duration,
  });

  final String serviceName;
  final String duration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            serviceName,
            style: theme.textTheme.titleSmall
                ?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: AppDimens.spaceMd),
        _DurationChip(duration: duration),
      ],
    );
  }
}

/// Pill chip displaying the service duration.
class _DurationChip extends StatelessWidget {
  const _DurationChip({required this.duration});

  final String duration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Symbols.timer,
            size: AppDimens.iconXs,
            color: colorScheme.primary,
          ),
          SizedBox(width: AppDimens.spaceXxs),
          Text(
            duration,
            style: theme.textTheme.labelSmall
                ?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
