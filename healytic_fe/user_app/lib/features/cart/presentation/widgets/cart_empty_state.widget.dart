import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Centered empty state shown when the cart has
/// no items.
///
/// Displays a large icon, title, subtitle, and
/// an "Explore Services" button.
class CartEmptyState extends StatelessWidget {
  /// Callback when "Explore Services" is tapped.
  final VoidCallback onExplore;

  const CartEmptyState({super.key, required this.onExplore});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.horizontalPadding(context),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cart icon
            Container(
              width: AppDimens.adaptive(
                context,
                small: 88,
                medium: 96,
                large: 104,
              ),
              height: AppDimens.adaptive(
                context,
                small: 88,
                medium: 96,
                large: 104,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Symbols.shopping_cart,
                size: AppDimens.adaptive(
                  context,
                  small: 40,
                  medium: 44,
                  large: 48,
                ),
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              ),
            ),
            SizedBox(height: AppDimens.sectionSpacing(context)),
            // Title
            Text(
              'Your cart is empty',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: AppDimens.spaceSm),
            // Subtitle
            Text(
              'Browse services to add items\n'
              'to your cart',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            SizedBox(height: AppDimens.sectionSpacing(context)),
            // CTA button
            OutlinedButton.icon(
              onPressed: onExplore,
              icon: Icon(Symbols.explore, size: AppDimens.iconMd),
              label: const Text('Explore Services'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.primary,
                side: BorderSide(color: colorScheme.primary),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceXxl,
                  vertical: AppDimens.spaceMd,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: AppDimens.radiusMediumSmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
