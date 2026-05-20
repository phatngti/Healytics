import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

import 'package:user_app/features/clinic_info/domain/entities/clinic_product.entity.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_products/product_card.widget.dart';

/// Responsive grid of [ProductCard] items.
///
/// Uses [LayoutBuilder] so item width and height stay
/// aligned with the two-column services layout.
/// The [childAspectRatio] is dynamically calculated
/// from available width and a fixed content height.
class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key, required this.products, this.onProductTap});

  final List<ClinicProductEntity> products;
  final void Function(String id)? onProductTap;

  static const _kCrossAxisCount = 2;

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

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalPadding =
            hPad * 2 + AppDimens.spaceSm * (_kCrossAxisCount - 1);
        final itemWidth =
            (constraints.maxWidth - totalPadding) / _kCrossAxisCount;
        final itemHeight = itemWidth + ProductCard.contentHeight;

        return GridView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: hPad,
            vertical: AppDimens.spaceSm,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _kCrossAxisCount,
            mainAxisSpacing: AppDimens.spaceSm,
            crossAxisSpacing: AppDimens.spaceSm,
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
      },
    );
  }
}
