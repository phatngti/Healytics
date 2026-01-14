import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

class ProductDetailsOrganizationCard extends StatelessWidget {
  final Product product;

  const ProductDetailsOrganizationCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            'ORGANIZATION',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 1.0,
            ),
          ),
          AppDimens.verticalMedium,
          _buildInfoItem(
            context,
            'Category',
            Row(
              children: [
                Icon(Icons.spa, size: 18, color: theme.colorScheme.primary),
                AppDimens.horizontalSmall,
                Text(
                  product.category.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: AppDimens.paddingVerticalExtraSmall,
            child: Divider(color: theme.colorScheme.outlineVariant, height: 1),
          ),
          AppDimens.verticalExtraSmall,
          Text(
            'Tags',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppDimens.verticalSmall,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: product.tags
                .map(
                  (tag) => Container(
                    padding:
                        AppDimens.paddingHorizontalSmall +
                        AppDimens.paddingVerticalExtraSmall,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    child: Text(
                      tag,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, Widget content) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppDimens.verticalExtraSmall,
        content,
      ],
    );
  }
}
