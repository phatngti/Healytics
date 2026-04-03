import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:user_app/features/clinic_info/presentation/providers/clinic_products.provider.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_products/category_scroller.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_products/product_grid.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_products/sort_filter_bar.widget.dart';
import 'package:user_app/router/routes.dart';

/// Content body for the "Product" tab inside
/// [ClinicInfoScreen].
///
/// Orchestrates the sort bar, category scroller,
/// and product grid. Watches filtered products
/// provider for reactive updates.
class ProductTabContent extends ConsumerWidget {
  const ProductTabContent({super.key, required this.clinicId});

  final String clinicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(
      filteredClinicProductsProvider(clinicId: clinicId),
    );
    final asyncData = ref.watch(clinicProductsProvider(clinicId: clinicId));

    return Column(
      children: [
        // ── Sort / Filter bar ──
        const SortFilterBar(),

        AppDimens.verticalSmall,

        // ── Category chips ──
        asyncData.when(
          data: (data) => CategoryScroller(categories: data.categories),
          loading: () => const SizedBox(height: 40),
          error: (_, __) => const SizedBox.shrink(),
        ),

        AppDimens.verticalSmall,

        // ── Product grid ──
        Expanded(
          child: asyncProducts.when(
            data: (products) => ProductGrid(
              products: products,
              onProductTap: (id) {
                ServiceDetailsRoute(serviceId: id).push(context);
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ),
      ],
    );
  }
}
