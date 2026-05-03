import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_analytics/product_detail_analytics.widget.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class ProductDetailsPerformanceCard extends StatelessWidget {
  final Product product;

  const ProductDetailsPerformanceCard({super.key, required this.product});

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
          // Header
          Padding(
            padding: AppDimens.paddingAllMediumLarge,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.query_stats,
                      color: Theme.of(
                        context,
                      ).extension<SemanticColors>()!.success,
                    ), // accent-green
                    AppDimens.horizontalSmall,
                    Text(
                      'Performance Insights',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: AppDimens.radiusSmall,
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      Text('Last 30 Days', style: theme.textTheme.labelSmall),
                      AppDimens.horizontalExtraSmall,
                      Icon(
                        Icons.arrow_drop_down,
                        size: 16,
                        color: theme.colorScheme.onSurface,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.colorScheme.outlineVariant),

          Padding(
            padding: AppDimens.paddingAllMediumLarge,
            child: ProductDetailAnalyticsSection(product: product),
          ),
        ],
      ),
    );
  }
}
