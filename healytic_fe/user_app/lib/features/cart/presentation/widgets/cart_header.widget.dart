import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Row showing the "My Cart (N)" title.
///
/// Single-service checkout: no "Select All" toggle.
class CartHeader extends StatelessWidget {
  /// Number of items in the cart.
  final int itemCount;

  const CartHeader({
    super.key,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimens.spaceSm,
      ),
      child: Text(
        'My Cart ($itemCount)',
        style: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}
