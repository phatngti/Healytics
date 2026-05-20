import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/network_image_auto.dart';

import 'package:user_app/features/home/domain/entities/'
    'home.entity.dart';
import 'package:user_app/router/routes.dart';

/// Product card with image-first layout, floating category
/// chip, rating badge, and clean content hierarchy.
///
/// Accepts a [HomeProduct] entity directly from the domain
/// layer — avoids spreading entity fields across many params.
class TreatmentCard extends StatelessWidget {
  /// The product entity to display.
  final HomeProduct product;

  const TreatmentCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardRad = AppDimens.cardRadius(context);
    final contentPad = AppDimens.contentPadding(context);

    return Semantics(
      button: true,
      label: '${product.name}, ${product.category}',
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(cardRad),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => ServiceDetailsRoute(serviceId: product.id).push(context),
          borderRadius: BorderRadius.circular(cardRad),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(cardRad),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.05),
                  blurRadius: AppDimens.spaceXl,
                  offset: Offset(0, AppDimens.spaceXs),
                ),
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.03),
                  blurRadius: AppDimens.spaceSmMd,
                  offset: Offset(0, AppDimens.spaceXxs),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _CardImageSection(product: product),
                _CardContentSection(product: product, contentPad: contentPad),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Image section with category chip & rating badge
// ─────────────────────────────────────────────────────────

class _CardImageSection extends StatelessWidget {
  final HomeProduct product;

  const _CardImageSection({required this.product});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardRad = AppDimens.cardRadius(context);

    return AspectRatio(
      aspectRatio: 16 / 10,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(cardRad)),
            child: NetworkImageAuto(
              imageUrl: product.imageUrl,
              fit: BoxFit.cover,
              errorWidget: (_) => Container(
                color: colorScheme.surface,
                child: Icon(
                  Symbols.image,
                  color: colorScheme.onSurfaceVariant,
                  size: AppDimens.iconXxl,
                ),
              ),
            ),
          ),
          Positioned(
            top: AppDimens.spaceSm,
            left: AppDimens.spaceSm,
            right: AppDimens.spaceSm,
            child: _CategoryChip(label: product.category),
          ),
          Positioned(
            bottom: AppDimens.spaceSm,
            right: AppDimens.spaceSm,
            child: _RatingBadge(
              rating: double.tryParse(product.rating)! > 0
                  ? double.tryParse(product.rating)!
                  : 5.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Floating category chip
// ─────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  final String label;

  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSmMd,
        vertical: AppDimens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: AppDimens.radiusPill,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: AppDimens.spaceXs,
            offset: Offset(0, AppDimens.spaceXxs),
          ),
        ],
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          letterSpacing: 0.2,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Floating rating badge
// ─────────────────────────────────────────────────────────

class _RatingBadge extends StatelessWidget {
  final double rating;

  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSm,
        vertical: AppDimens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.scrim.withValues(alpha: 0.6),
        borderRadius: AppDimens.radiusMediumSmall,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Symbols.star,
            size: AppDimens.iconXs,
            color: colorScheme.tertiary,
            fill: 1.0,
          ),
          SizedBox(width: AppDimens.spaceXs),
          Text(
            rating.toString(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onInverseSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Content section: name, info rows, price + CTA
// ─────────────────────────────────────────────────────────

class _CardContentSection extends StatelessWidget {
  final HomeProduct product;
  final double contentPad;

  const _CardContentSection({required this.product, required this.contentPad});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardColor = theme.cardTheme;

    return Container(
      decoration: BoxDecoration(color: cardColor.surfaceTintColor),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          contentPad,
          AppDimens.spaceSm,
          contentPad,
          AppDimens.spaceSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              product.name,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: AppDimens.spaceXxs),

            // Duration
            _InfoRow(icon: Symbols.schedule, text: product.duration),

            // Location
            if (product.location.isNotEmpty) ...[
              SizedBox(height: AppDimens.spaceXxs),
              _InfoRow(icon: Symbols.location_on, text: product.location),
            ],

            // Vendor name
            if (product.vendorName.isNotEmpty) ...[
              SizedBox(height: AppDimens.spaceXxs),
              _InfoRow(icon: Symbols.storefront, text: product.vendorName),
            ],

            SizedBox(height: AppDimens.spaceSm),

            // Price + CTA
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    product.price,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: AppDimens.ctaButtonSm,
                  width: AppDimens.ctaButtonSm,
                  child: IconButton.filled(
                    onPressed: () =>
                        ServiceDetailsRoute(serviceId: product.id).go(context),
                    tooltip: 'View details',
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Symbols.arrow_forward,
                      size: AppDimens.iconSm,
                      color: colorScheme.onPrimary,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      shape: const CircleBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Reusable icon + text info row
// ─────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, size: AppDimens.iconXs, color: colorScheme.onSurfaceVariant),
        SizedBox(width: AppDimens.spaceXs),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
