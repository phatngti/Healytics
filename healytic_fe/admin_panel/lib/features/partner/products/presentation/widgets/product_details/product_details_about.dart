import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

class ProductDetailsAboutCard extends StatelessWidget {
  final Product product;

  const ProductDetailsAboutCard({super.key, required this.product});

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
              border: Border(
                bottom: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            child: Text(
              'About Service',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: AppDimens.paddingAllMediumLarge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.description.isEmpty
                      ? 'Experience the ultimate in skin restoration with our Rejuvenating Night Cream Service. This luxurious treatment is designed to deeply hydrate and repair your skin while you relax. Formulated with a potent blend of ceramides, peptides, and antioxidants, it works overnight to smooth fine lines, improve texture, and restore a youthful radiance.'
                      : product.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    height: 1.5,
                  ),
                ),
                AppDimens.verticalMedium,

                // Mock Bullet Points from Design
                _buildBulletPoint(context, 'Deep hydration for 24 hours'),
                _buildBulletPoint(context, 'Reduces appearance of fine lines'),
                _buildBulletPoint(context, 'Dermatologist tested'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant,
                shape: BoxShape.circle,
              ),
            ),
          ),
          AppDimens.horizontalMediumSmall,
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
