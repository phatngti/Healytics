import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';

/// Quick stats bento grid — 3 equal columns showing
/// Orders, Wishlist, and Points.
///
/// Each cell has an icon on a secondary-container
/// background, a label, and a bold numeric value.
class ProfileQuickStats extends StatelessWidget {
  const ProfileQuickStats({
    super.key,
    this.ordersCount = 0,
    this.wishlistCount = 0,
    this.points = '0',
    this.onOrdersTap,
    this.onWishlistTap,
    this.onPointsTap,
  });

  /// Total completed order count.
  final int ordersCount;

  /// Total wishlist items.
  final int wishlistCount;

  /// Points display string (e.g. "2.4k").
  final String points;

  /// Tap handlers for each stat cell.
  final VoidCallback? onOrdersTap;
  final VoidCallback? onWishlistTap;
  final VoidCallback? onPointsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCell(
            icon: Icons.shopping_bag_outlined,
            label: 'Orders',
            value: '$ordersCount',
            onTap: onOrdersTap,
          ),
        ),
        SizedBox(width: AppDimens.spaceLg),
        Expanded(
          child: _StatCell(
            icon: Icons.favorite_outline,
            label: 'Wishlist',
            value: '$wishlistCount',
            onTap: onWishlistTap,
          ),
        ),
        SizedBox(width: AppDimens.spaceLg),
        Expanded(
          child: _StatCell(
            icon: Icons.star_outline,
            label: 'Points',
            value: points,
            onTap: onPointsTap,
          ),
        ),
      ],
    );
  }
}

// ─── Single Stat Cell ───────────────────────────

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final cardPad = AppDimens.cardPadding(context);

    return Material(
      color: colorScheme.surface,
      borderRadius: AppDimens.radiusMedium,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDimens.radiusMedium,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: cardPad,
            horizontal: AppDimens.spaceSm,
          ),
          decoration: BoxDecoration(
            borderRadius: AppDimens.radiusMedium,
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.04),
                blurRadius: 24,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon container
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: AppDimens.iconLg,
                  color: colorScheme.onPrimary,
                ),
              ),
              SizedBox(height: AppDimens.spaceMd),
              // Label
              Text(
                label.toUpperCase(),
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: colorScheme.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppDimens.spaceXs),
              // Value
              Text(
                value,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
