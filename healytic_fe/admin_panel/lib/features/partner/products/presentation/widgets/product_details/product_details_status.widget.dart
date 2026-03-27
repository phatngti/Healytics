import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class ProductDetailsStatusCard extends StatelessWidget {
  final Product product;

  const ProductDetailsStatusCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine status color and label (Mock logic based on HTML for now)
    final semanticColors = Theme.of(context).extension<SemanticColors>()!;
    final isDraft = product.status == 'draft';
    final statusColor = isDraft
        ? semanticColors.warning!
        : theme.colorScheme.primary;
    final statusBg = isDraft
        ? semanticColors.warning!.withValues(alpha: 0.15)
        : theme.colorScheme.primaryContainer;
    final statusBorder = isDraft
        ? semanticColors.warning!.withValues(alpha: 0.3)
        : theme.colorScheme.primary.withValues(alpha: 0.1);

    return Container(
      padding: AppDimens.paddingAllMediumLarge,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STATUS',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 1.0,
            ),
          ),
          AppDimens.verticalMedium,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current State',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: AppDimens.radiusPill,
                  border: Border.all(color: statusBorder),
                ),
                child: Text(
                  product.status.substring(0, 1).toUpperCase() +
                      product.status.substring(1),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: AppDimens.paddingVerticalMediumSmall,
            child: Divider(color: theme.colorScheme.outlineVariant, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Visibility',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding:
                    AppDimens.paddingHorizontalSmall +
                    AppDimens.paddingVerticalExtraSmall,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: AppDimens.radiusSmall,
                ),
                child: Row(
                  children: [
                    Icon(
                      product.onlineStore
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    AppDimens.horizontalExtraSmall,
                    Text(
                      product.onlineStore ? 'Visible' : 'Hidden',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
