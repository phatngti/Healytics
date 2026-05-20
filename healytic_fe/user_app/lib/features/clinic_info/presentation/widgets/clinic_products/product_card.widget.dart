import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/network_image_auto.dart';
import 'package:flutter/material.dart';

import 'package:user_app/features/clinic_info/domain/entities/clinic_product.entity.dart';

/// Single product card matching the HTML design.
///
/// Displays an aspect-square image with optional
/// discount/badge overlay, title (line-clamp-2),
/// duration + specialist chips, and price row.
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.onTap});

  static const contentHeight = 128.0;

  final ClinicProductEntity product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      button: onTap != null,
      label: product.title,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: AppDimens.radiusMediumSmall,
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.05),
                blurRadius: AppDimens.spaceSm,
                offset: const Offset(0, AppDimens.spaceXxs),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: _ProductImage(product: product),
              ),
              SizedBox(
                height: contentHeight,
                child: _ProductContent(product: product),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Product image with optional badge overlay.
class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.product});

  final ClinicProductEntity product;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (product.imageUrl != null)
          NetworkImageAuto(imageUrl: product.imageUrl!, fit: BoxFit.cover)
        else
          Container(color: colorScheme.surfaceContainerHighest),

        // Discount badge (error color)
        if (product.discountLabel != null)
          Positioned(
            top: AppDimens.spaceXs + AppDimens.spaceXxs,
            left: AppDimens.spaceXs + AppDimens.spaceXxs,
            child: _Badge(
              text: product.discountLabel!,
              backgroundColor: colorScheme.error,
              textColor: colorScheme.onError,
            ),
          ),

        // HOT / special badge (primary)
        if (product.badgeLabel != null && product.discountLabel == null)
          Positioned(
            top: AppDimens.spaceXs + AppDimens.spaceXxs,
            left: AppDimens.spaceXs + AppDimens.spaceXxs,
            child: _Badge(
              text: product.badgeLabel!,
              backgroundColor: colorScheme.primary,
              textColor: colorScheme.onPrimary,
            ),
          ),
      ],
    );
  }
}

/// Product content: title, chips, and price.
class _ProductContent extends StatelessWidget {
  const _ProductContent({required this.product});

  final ClinicProductEntity product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(AppDimens.spaceSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title (uppercase, line-clamp-2)
          Text(
            product.title.toUpperCase(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: AppDimens.letterSpacingSmall * 0.6,
              height: 1.2,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXs),

          // Duration + specialist chips (shrinkable)
          Flexible(child: _ChipRow(product: product)),

          const Spacer(),

          // Price row
          _PriceRow(product: product),
        ],
      ),
    );
  }
}

/// Duration and specialist chips.
class _ChipRow extends StatelessWidget {
  const _ChipRow({required this.product});

  final ClinicProductEntity product;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final chipStyle = textTheme.labelSmall?.copyWith(
      fontWeight: FontWeight.w500,
    );

    return Wrap(
      spacing: AppDimens.spaceXs,
      runSpacing: AppDimens.spaceXs,
      children: [
        if (product.durationLabel != null)
          _InfoChip(
            text: product.durationLabel!,
            backgroundColor: colorScheme.surfaceContainerHighest,
            textColor: colorScheme.onSurfaceVariant,
            style: chipStyle,
          ),
        if (product.specialistLabel != null)
          _InfoChip(
            text: product.specialistLabel!,
            backgroundColor: colorScheme.primaryContainer,
            textColor: colorScheme.onPrimaryContainer,
            style: chipStyle,
          ),
      ],
    );
  }
}

/// Price row with optional strikethrough.
class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.product});

  final ClinicProductEntity product;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (product.hasDiscount)
          Text(
            product.originalPrice!,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              decoration: TextDecoration.lineThrough,
            ),
          ),
        Text(
          product.price,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

/// Small overlay badge (discount or special label).
class _Badge extends StatelessWidget {
  const _Badge({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  final String text;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceXs + AppDimens.spaceXxs,
        vertical: AppDimens.spaceXxs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppDimens.radiusExtraSmall,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}

/// Small info chip (duration, specialist label).
class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.style,
  });

  final String text;
  final Color backgroundColor;
  final Color textColor;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceXs + AppDimens.spaceXxs,
        vertical: AppDimens.spaceXxs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppDimens.radiusExtraSmall,
      ),
      child: Text(text, style: style?.copyWith(color: textColor)),
    );
  }
}
