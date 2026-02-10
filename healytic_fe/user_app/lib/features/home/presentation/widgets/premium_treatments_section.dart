import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';

import 'package:user_app/features/home/domain/entities/home.entity.dart';
import 'package:user_app/features/home/presentation/providers/home_provider.dart';

/// Displays a 2-column grid of premium treatment cards
/// fetched from the data layer via [homeProvider].
class PremiumTreatmentsSection extends ConsumerWidget {
  const PremiumTreatmentsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final titleGap = AppDimens.titleGap(context);
    final contentPad = AppDimens.contentPadding(context);
    final homeState = ref.watch(homeProvider);
    final products = homeState.premiumProducts;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                'Premium Treatments',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'See All',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: titleGap),
        if (homeState.isLoading)
          _buildLoadingGrid(context, contentPad)
        else if (products.isEmpty)
          _buildEmptyState(context)
        else
          _buildProductGrid(context, products, contentPad),
      ],
    );
  }

  /// Builds the 2-column grid from live/mock product data.
  Widget _buildProductGrid(
    BuildContext context,
    List<HomeProduct> products,
    double contentPad,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final ratio = constraints.maxWidth < 360
            ? 0.55
            : constraints.maxWidth < 400
            ? 0.58
            : 0.62;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: contentPad,
          crossAxisSpacing: contentPad,
          padding: EdgeInsets.zero,
          childAspectRatio: ratio,
          children: products
              .map(
                (product) => _TreatmentCard(
                  imageUrl: product.imageUrl,
                  category: product.category,
                  title: product.name,
                  duration: product.duration,
                  vendorName: product.vendorName,
                  price: product.price,
                  rating: double.tryParse(product.rating) ?? 4.9,
                ),
              )
              .toList(),
        );
      },
    );
  }

  /// Shimmer-style loading placeholders (2×2 grid).
  Widget _buildLoadingGrid(BuildContext context, double contentPad) {
    final theme = Theme.of(context);
    final cardRad = AppDimens.cardRadius(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final ratio = constraints.maxWidth < 360
            ? 0.55
            : constraints.maxWidth < 400
            ? 0.58
            : 0.62;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: contentPad,
          crossAxisSpacing: contentPad,
          padding: EdgeInsets.zero,
          childAspectRatio: ratio,
          children: List.generate(
            4,
            (_) => Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(cardRad),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.3,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(cardRad),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.all(contentPad),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: AppDimens.spaceLg,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: AppDimens.radiusExtraSmall,
                            ),
                          ),
                          SizedBox(height: AppDimens.spaceSm),
                          Container(
                            height: AppDimens.spaceMd,
                            width: 80,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: AppDimens.radiusExtraSmall,
                            ),
                          ),
                          SizedBox(height: AppDimens.spaceSm),
                          Container(
                            height: AppDimens.spaceMd,
                            width: 60,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: AppDimens.radiusExtraSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Empty-state fallback when no premium products are
  /// available.
  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimens.spaceXxl),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Symbols.spa,
              size: AppDimens.avatarMd,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: AppDimens.spaceSm),
            Text(
              'No premium treatments yet',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Standard product card with image-first layout, floating
/// category chip, and clean content hierarchy.
class _TreatmentCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String title;
  final String duration;
  final String vendorName;
  final String price;
  final double rating;

  const _TreatmentCard({
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.duration,
    required this.vendorName,
    required this.price,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardRad = AppDimens.cardRadius(context);
    final contentPad = AppDimens.contentPadding(context);

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(cardRad),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(cardRad),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cardRad),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: AppDimens.spaceXl,
                offset: Offset(0, AppDimens.spaceXs),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: AppDimens.spaceSmMd,
                offset: Offset(0, AppDimens.spaceXxs),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Image with floating category chip ──
              Expanded(
                flex: 5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(cardRad),
                      ),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Symbols.image,
                            color: colorScheme.onSurfaceVariant,
                            size: AppDimens.iconXxl,
                          ),
                        ),
                      ),
                    ),
                    // Category chip — floating top-left
                    Positioned(
                      top: AppDimens.spaceSm,
                      left: AppDimens.spaceSm,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimens.spaceSmMd,
                          vertical: AppDimens.spaceXs,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withValues(alpha: 0.92),
                          borderRadius: AppDimens.radiusPill,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: AppDimens.spaceXs,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          category,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    // Rating badge — floating top-right
                    Positioned(
                      top: AppDimens.spaceSm,
                      right: AppDimens.spaceSm,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimens.spaceSm,
                          vertical: AppDimens.spaceXs,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: AppDimens.radiusMediumSmall,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Symbols.star,
                              size: AppDimens.iconXs,
                              color: Colors.amber,
                              fill: 1.0,
                            ),
                            SizedBox(width: AppDimens.spaceXs),
                            Text(
                              rating.toString(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Content area ──
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    contentPad,
                    AppDimens.spaceSm,
                    contentPad,
                    AppDimens.spaceSm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Flexible(
                        child: Text(
                          title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(child: SizedBox(height: AppDimens.spaceXxs)),

                      // Duration row
                      Row(
                        children: [
                          Icon(
                            Symbols.schedule,
                            size: AppDimens.iconXs,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: AppDimens.spaceXs),
                          Flexible(
                            child: Text(
                              duration,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      // Vendor name row
                      if (vendorName.isNotEmpty) ...[
                        Flexible(child: SizedBox(height: AppDimens.spaceXxs)),
                        Row(
                          children: [
                            Icon(
                              Symbols.storefront,
                              size: AppDimens.iconXs,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(width: AppDimens.spaceXs),
                            Expanded(
                              child: Text(
                                vendorName,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],

                      Flexible(child: SizedBox(height: AppDimens.spaceXs)),

                      // Price + CTA row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              price,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: AppDimens.ctaButtonSm,
                            width: AppDimens.ctaButtonSm,
                            child: IconButton.filled(
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Symbols.arrow_forward,
                                size: AppDimens.iconSm,
                                color: colorScheme.onPrimary,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                shape: const CircleBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
