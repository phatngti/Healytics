import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Gray panel displaying clinic location details
/// for a cart item.
class AppointmentDetailsPanel extends StatelessWidget {
  /// Clinic display name.
  final String clinicName;

  /// Full address string.
  final String clinicAddress;

  const AppointmentDetailsPanel({
    super.key,
    required this.clinicName,
    required this.clinicAddress,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(AppDimens.contentPadding(context)),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: AppDimens.radiusMediumSmall,
      ),
      child: Column(
        children: [
          // Clinic name row
          Row(
            children: [
              Icon(
                Symbols.storefront,
                size: AppDimens.iconSm,
                color: colorScheme.primary,
              ),
              SizedBox(width: AppDimens.spaceSm),
              Expanded(
                child: Text(
                  clinicName,
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.spaceSm),
          // Location row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: AppDimens.spaceXxs),
                child: Icon(
                  Symbols.location_on,
                  size: AppDimens.iconSm,
                  color: colorScheme.primary,
                ),
              ),
              SizedBox(width: AppDimens.spaceSm),
              Expanded(
                child: Text(
                  clinicAddress,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
