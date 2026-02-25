import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class ProductDetailsPricingCard extends StatelessWidget {
  final Product product;

  const ProductDetailsPricingCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: AppDimens.paddingAllMediumLarge,
            decoration: BoxDecoration(
              borderRadius: AppDimens.radiusMediumSmall,
              border: Border(
                bottom: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            child: Text(
              'Pricing & Inventory',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: AppDimens.paddingAllMediumLarge,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BASE PRICE',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      AppDimens.verticalSmall,
                      Text(
                        '\$${product.basePrice.toStringAsFixed(2)}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Could add Stock/SKU here if available
              ],
            ),
          ),
        ],
      ),
    );
  }
}
