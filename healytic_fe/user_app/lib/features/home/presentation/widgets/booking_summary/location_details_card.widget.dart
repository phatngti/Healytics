import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';

/// Card showing the booking location / partner
/// details with a map placeholder thumbnail.
///
/// Uses static placeholder data until real
/// partner data is wired through the booking flow.
class LocationDetailsCard extends StatelessWidget {
  const LocationDetailsCard({
    super.key,
    this.partnerName = 'Healytics Spa Retreat',
    this.address =
        'District 1, Ho Chi Minh City',
  });

  /// Name of the partner / venue.
  final String partnerName;

  /// Full address string.
  final String address;

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
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Symbols.location_on,
            label: 'Location Details',
          ),
          SizedBox(height: AppDimens.spaceMd),
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      partnerName,
                      style: theme
                          .textTheme.titleSmall
                          ?.copyWith(
                        fontWeight: FontWeight.w600,
                        color:
                            colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(
                      height: AppDimens.spaceXs,
                    ),
                    Text(
                      address,
                      style: theme
                          .textTheme.bodySmall
                          ?.copyWith(
                        color: colorScheme
                            .onSurfaceVariant,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow:
                          TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppDimens.spaceLg),
              _MapPlaceholder(),
            ],
          ),
        ],
      ),
    );
  }
}

/// Placeholder square representing a map
/// thumbnail.
class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;
    const size = 72.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: AppDimens.radiusMediumSmall,
      ),
      child: Icon(
        Symbols.map,
        size: AppDimens.iconXxl,
        color: colorScheme.onSurfaceVariant
            .withValues(alpha: 0.4),
      ),
    );
  }
}

/// Uppercase section header with icon.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          size: AppDimens.iconMd,
          color: colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: AppDimens.spaceSm),
        Text(
          label.toUpperCase(),
          style:
              theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
