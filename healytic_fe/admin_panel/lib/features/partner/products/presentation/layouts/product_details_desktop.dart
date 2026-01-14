import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_details/product_details_about.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_details/product_details_media_gallery.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_details/product_details_operations.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_details/product_details_organization.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_details/product_details_performance.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_details/product_details_pricing.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_details/product_details_status.widget.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

class ProductDetailsDesktop extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onBack;

  const ProductDetailsDesktop({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    // Breadcrumbs mock based on HTML
    // Dashboard > Products > Rejuvenating Night Cream Service

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(
            left: AppDimens.paddingAllMedium.left,
            right: AppDimens.paddingAllMedium.right,
            bottom: AppDimens.paddingAllMedium.bottom,
            top: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit Service'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      padding: AppDimens.paddingHorizontalMediumLarge.add(
                        AppDimens.paddingVerticalSmall,
                      ),
                    ),
                  ),
                ],
              ),
              AppDimens.verticalLargeExtra,

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column (Main) - Flex 2
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        ProductDetailsMediaGalleryCard(product: product),
                        AppDimens.verticalLarge,
                        ProductDetailsAboutCard(product: product),
                        AppDimens.verticalLarge,
                        ProductDetailsPricingCard(product: product),
                        AppDimens.verticalLarge,
                        ProductDetailsPerformanceCard(product: product),
                      ],
                    ),
                  ),
                  AppDimens.horizontalLargeExtra,
                  // Right Column (Sidebar) - Flex 1
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        ProductDetailsStatusCard(product: product),
                        AppDimens.verticalLarge,
                        ProductDetailsOrganizationCard(product: product),
                        AppDimens.verticalLarge,
                        ProductDetailsOperationsCard(product: product),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
