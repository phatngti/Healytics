import 'package:common/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/core/widgets/directions_route_sheet.widget.dart';
import 'package:user_app/core/widgets/map_preview.widget.dart';

/// Card showing the booking location / partner
/// details with a map placeholder thumbnail.
///
/// Employee-booking-specific clone — not shared
/// with the standard booking flow.
class LocationDetailsCard extends StatelessWidget {
  const LocationDetailsCard({
    super.key,
    this.partnerName = 'Healytics Spa Retreat',
    this.address = 'District 1, Ho Chi Minh City',
    this.latitude,
    this.longitude,
  });

  /// Name of the partner / venue.
  final String partnerName;

  /// Full address string.
  final String address;

  /// Optional map latitude.
  final double? latitude;

  /// Optional map longitude.
  final double? longitude;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardPad = AppDimens.cardPadding(context);

    return Container(
      padding: EdgeInsets.all(cardPad),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimens.cardRadius(context)),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(icon: Symbols.location_on, label: 'Location Details'),
          SizedBox(height: AppDimens.spaceMd),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      partnerName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: AppDimens.spaceXs),
                    Text(
                      address,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppDimens.spaceLg),
              MapPreviewWidget(
                latitude: latitude,
                longitude: longitude,
                width: 86,
                height: 86,
                onTap: () => _openDirections(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openDirections(BuildContext context) {
    final destinationLatitude = latitude;
    final destinationLongitude = longitude;
    if (destinationLatitude == null || destinationLongitude == null) {
      AppToast.warning(
        context,
        'Directions are unavailable for this location.',
      );
      return;
    }

    DirectionsRouteSheet.show(
      context,
      destinationLatitude: destinationLatitude,
      destinationLongitude: destinationLongitude,
      destinationName: partnerName,
      destinationAddress: address,
    );
  }
}

/// Uppercase section header with icon.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, size: AppDimens.iconMd, color: colorScheme.onSurfaceVariant),
        SizedBox(width: AppDimens.spaceSm),
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
