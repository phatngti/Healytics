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
/// and product grid. Watches the paginated products
/// provider for reactive server-side filtering and
/// sorting.
class ProductTabContent extends ConsumerWidget {
  const ProductTabContent({
    super.key,
    required this.clinicId,
  });

  final String clinicId;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final colorScheme =
        Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final asyncProducts = ref.watch(
      clinicProductsPaginatedProvider(
        clinicId: clinicId,
      ),
    );

    return Column(
      children: [
        // ── Sort / Filter bar ──
        const SortFilterBar(),

        AppDimens.verticalSmall,

        // ── Category chips (hidden when API
        //    returns no categories) ──
        asyncProducts.when(
          data: (data) =>
              data.categories.isEmpty
                  ? const SizedBox.shrink()
                  : Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: AppDimens.spaceSm,
                      ),
                      child: CategoryScroller(
                        categories:
                            data.categories,
                      ),
                    ),
          loading: () => const SizedBox(
            height: AppDimens.ctaButtonMd,
          ),
          error: (_, __) =>
              const SizedBox.shrink(),
        ),

        // ── Product grid ──
        Expanded(
          child: asyncProducts.when(
            data: (data) => ProductGrid(
              products: data.products,
              onProductTap: (id) {
                ServiceDetailsRoute(
                  serviceId: id,
                ).push(context);
              },
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(
                  AppDimens.spaceXxl,
                ),
                child: Text(
                  'Something went wrong.\n'
                  'Please try again.',
                  textAlign: TextAlign.center,
                  style:
                      textTheme.bodyMedium?.copyWith(
                    color:
                        colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
