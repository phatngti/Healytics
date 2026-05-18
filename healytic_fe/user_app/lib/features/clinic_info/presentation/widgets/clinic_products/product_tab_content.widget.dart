import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:user_app/features/clinic_info/presentation/providers/clinic_products.provider.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_products/category_scroller.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_products/product_card.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_products/sort_filter_bar.widget.dart';
import 'package:user_app/router/routes.dart';

/// Content body for the "Product" tab inside
/// [ClinicInfoScreen].
///
/// Uses [CustomScrollView] with slivers so the
/// parent [NestedScrollView] can properly coordinate
/// inner scrolling. A Column + Expanded + GridView
/// pattern breaks NestedScrollView's scroll
/// coordination.
class ProductTabContent extends ConsumerWidget {
  const ProductTabContent({
    super.key,
    required this.clinicId,
  });

  final String clinicId;

  /// Fixed content height below the image area
  /// (title + chips + price).
  static const _kContentHeight = 120.0;

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

    return CustomScrollView(
      slivers: [
        // ── Sort / Filter bar ──
        const SliverToBoxAdapter(
          child: SortFilterBar(),
        ),

        SliverToBoxAdapter(
          child: AppDimens.verticalSmall,
        ),

        // ── Category chips ──
        asyncProducts.when(
          data: (data) => data.categories.isEmpty
              ? const SliverToBoxAdapter(
                  child: SizedBox.shrink(),
                )
              : SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppDimens.spaceSm,
                    ),
                    child: CategoryScroller(
                      categories:
                          data.categories,
                    ),
                  ),
                ),
          loading: () =>
              const SliverToBoxAdapter(
            child: SizedBox(
              height: AppDimens.ctaButtonMd,
            ),
          ),
          error: (_, __) =>
              const SliverToBoxAdapter(
            child: SizedBox.shrink(),
          ),
        ),

        // ── Product grid ──
        asyncProducts.when(
          data: (data) =>
              _buildProductGrid(context, data),
          loading: () =>
              const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          error: (err, _) => SliverFillRemaining(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(
                  AppDimens.spaceXxl,
                ),
                child: Text(
                  'Something went wrong.\n'
                  'Please try again.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium
                      ?.copyWith(
                    color: colorScheme
                        .onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the product sliver grid or an
  /// empty-state message.
  Widget _buildProductGrid(
    BuildContext context,
    ClinicProductsAccumulated data,
  ) {
    if (data.products.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(
              AppDimens.spaceXxl,
            ),
            child: Text(
              'No products found',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
    }

    final hPad =
        AppDimens.horizontalPadding(context);
    final screenWidth =
        MediaQuery.sizeOf(context).width;
    final crossAxisCount =
        screenWidth < 400 ? 2 : 3;
    final totalPadding = hPad * 2 +
        AppDimens.spaceSm * (crossAxisCount - 1);
    final itemWidth =
        (screenWidth - totalPadding) /
            crossAxisCount;
    final itemHeight =
        itemWidth + _kContentHeight;

    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: hPad,
        vertical: AppDimens.spaceSm,
      ),
      sliver: SliverGrid(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: AppDimens.spaceSm,
          crossAxisSpacing: AppDimens.spaceSm,
          childAspectRatio:
              itemWidth / itemHeight,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product =
                data.products[index];
            return ProductCard(
              product: product,
              onTap: () =>
                  ServiceDetailsRoute(
                    serviceId: product.id,
                  ).push(context),
            );
          },
          childCount: data.products.length,
        ),
      ),
    );
  }
}
