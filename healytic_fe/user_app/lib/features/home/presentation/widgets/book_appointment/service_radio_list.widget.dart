import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';

import '../../../domain/entities/booking.entity.dart';

/// Vertical list of radio-style service cards.
///
/// Accepts a [services] list from the data layer.
/// Each card shows a service image, title,
/// duration + price, clinic info, and a trailing
/// radio indicator.
/// Reports the selected index via [onSelected].
class ServiceRadioList extends StatelessWidget {
  const ServiceRadioList({
    super.key,
    required this.services,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<BookingService> services;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(services.length, (i) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: i < services.length - 1 ? AppDimens.spaceMd : 0,
          ),
          child: _ServiceRadioCard(
            service: services[i],
            isSelected: i == selectedIndex,
            onTap: () => onSelected(i),
          ),
        );
      }),
    );
  }
}

class _ServiceRadioCard extends StatelessWidget {
  const _ServiceRadioCard({
    required this.service,
    required this.isSelected,
    required this.onTap,
  });

  final BookingService service;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer.withValues(alpha: 0.3)
              : colorScheme.surface,
          borderRadius: AppDimens.radiusMedium,
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant,
            width: isSelected
                ? AppDimens.borderWidthThick
                : AppDimens.borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Header: image + info + radio ──
            _CardHeader(service: service, isSelected: isSelected),

            // ── Clinic info section ──
            if (service.clinicName != null || service.clinicAddress != null)
              _ClinicInfo(service: service),
          ],
        ),
      ),
    );
  }
}

/// Top section: service image, name, price, radio.
class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.service, required this.isSelected});

  final BookingService service;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.all(AppDimens.spaceLg),
      child: Row(
        children: [
          // Service image / placeholder
          _ServiceImage(imageUrl: service.imageUrl),
          SizedBox(width: AppDimens.spaceMd),

          // Title + duration • price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.title,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppDimens.spaceXxs),
                Row(
                  children: [
                    Icon(
                      Symbols.schedule,
                      size: AppDimens.iconSm,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: AppDimens.spaceXxs),
                    Text(
                      service.duration,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: AppDimens.spaceSm),
                    Text(
                      service.price,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Radio indicator
          _RadioDot(isSelected: isSelected),
        ],
      ),
    );
  }
}

/// Rounded service image or fallback icon.
class _ServiceImage extends StatelessWidget {
  const _ServiceImage({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    const size = 56.0;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.spaceSmMd),
        child: Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _Placeholder(size: size),
        ),
      );
    }

    return _Placeholder(size: size);
  }
}

/// Fallback placeholder when no image is available.
class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppDimens.spaceSmMd),
      ),
      child: Icon(
        Symbols.health_and_safety,
        size: AppDimens.iconLg,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}

/// Bottom section: clinic name + address + distance.
class _ClinicInfo extends StatelessWidget {
  const _ClinicInfo({required this.service});

  final BookingService service;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppDimens.spaceLg,
        0,
        AppDimens.spaceLg,
        AppDimens.spaceMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            height: 1,
          ),
          SizedBox(height: AppDimens.spaceSm),

          // Clinic name
          if (service.clinicName != null)
            Row(
              children: [
                Icon(
                  Symbols.local_hospital,
                  size: AppDimens.iconSm,
                  color: colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: AppDimens.spaceXxs),
                Expanded(
                  child: Text(
                    service.clinicName!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

          // Address + distance
          if (service.clinicAddress != null) ...[
            SizedBox(height: AppDimens.spaceXxs),
            Row(
              children: [
                Icon(
                  Symbols.location_on,
                  size: AppDimens.iconSm,
                  color: colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: AppDimens.spaceXxs),
                Expanded(
                  child: Text(
                    service.clinicAddress!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (service.distance != null) ...[
                  SizedBox(width: AppDimens.spaceSm),
                  _DistanceBadge(distance: service.distance!),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Small colored badge showing distance.
class _DistanceBadge extends StatelessWidget {
  const _DistanceBadge({required this.distance});

  final String distance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSm,
        vertical: AppDimens.spaceXxs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: AppDimens.radiusPill,
      ),
      child: Text(
        distance,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}

/// Custom radio indicator dot.
class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: AppDimens.iconLg,
      height: AppDimens.iconLg,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
          width: 2,
        ),
        color: isSelected ? colorScheme.primary : Colors.transparent,
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: AppDimens.spaceSmMd,
                height: AppDimens.spaceSmMd,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.onPrimary,
                ),
              ),
            )
          : null,
    );
  }
}
