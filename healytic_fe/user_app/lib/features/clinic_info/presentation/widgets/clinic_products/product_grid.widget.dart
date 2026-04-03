import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

import 'package:user_app/features/clinic_info/domain/entities/clinic_product.entity.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_products/product_card.widget.dart';

/// 2-column grid of [ProductCard] items.
///
/// Uses [GridView.builder] with a dynamically
/// calculated [childAspectRatio] based on screen width.
class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key, required this.products, this.onProductTap});

  final List<ClinicProductEntity> products;
  final void Function(String id)? onProductTap;

  /// Fixed content height below the image area
  /// (title + chips + price).
  static const _kContentHeight = 120.0;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceXxl),
          child: Text(
            'No products found',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final hPad = AppDimens.horizontalPadding(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final totalPadding = hPad * 2 + 8; // + crossSpacing
    final itemWidth = (screenWidth - totalPadding) / 2;
    final itemHeight = itemWidth + _kContentHeight;

    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: hPad,
        vertical: AppDimens.spaceSm,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: itemWidth / itemHeight,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () => onProductTap?.call(product.id),
        );
      },
    );
  }
}
