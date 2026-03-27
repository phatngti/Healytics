import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';

import 'package:user_app/features/home/domain/entities/'
    'home.entity.dart';
import 'package:user_app/features/home/presentation/'
    'providers/home.provider.dart';

/// Displays a horizontally-scrollable list of recommended
/// services fetched via [productsProvider].
class RecommendSection extends ConsumerWidget {
  const RecommendSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final productsAsync = ref.watch(recommendedProductsProvider);
    final titleGap = AppDimens.titleGap(context);

    // Proportional card width: ~65 % of screen so
    // 1.3–1.5 cards are visible, hinting at scroll.
    final cardWidth = AppDimens.widthFraction(context);

    // Proportional list height scales with card width.
    final listHeight = AppDimens.heightRatio(cardWidth, ratio: 1.08);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                'Recommend For You',
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
        SizedBox(
          height: listHeight,
          child: productsAsync.when(
            loading: () => _LoadingList(cardWidth: cardWidth),
            error: (_, __) => const _EmptyState(),
            data: (products) {
              if (products.isEmpty) {
                return const _EmptyState();
              }
              return _ProductList(products: products, cardWidth: cardWidth);
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Horizontal product list
// ─────────────────────────────────────────────────────────

class _ProductList extends StatelessWidget {
  final List<HomeProduct> products;
  final double cardWidth;

  const _ProductList({required this.products, required this.cardWidth});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      itemCount: products.length,
      separatorBuilder: (_, __) => SizedBox(width: AppDimens.spaceLg),
      itemBuilder: (_, index) {
        final product = products[index];
        return _RecommendCard(
          width: cardWidth,
          title: product.name,
          imageUrl: product.imageUrl,
          rating: product.rating,
          duration: product.duration,
          category: product.category,
          price: product.price,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────
// Loading placeholders
// ─────────────────────────────────────────────────────────

class _LoadingList extends StatelessWidget {
  final double cardWidth;

  const _LoadingList({required this.cardWidth});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardRad = AppDimens.cardRadius(context);
    final imageHeight = AppDimens.heightRatio(cardWidth);

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      itemCount: 2,
      separatorBuilder: (_, __) => SizedBox(width: AppDimens.spaceLg),
      itemBuilder: (_, __) => Container(
        width: cardWidth,
        padding: EdgeInsets.all(AppDimens.spaceMd),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(cardRad),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: imageHeight,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(
                  cardRad - AppDimens.spaceXs,
                ),
              ),
            ),
            SizedBox(height: AppDimens.spaceMd),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.spaceXs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: AppDimens.spaceLg,
                    width: cardWidth * 0.6,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: AppDimens.radiusExtraSmall,
                    ),
                  ),
                  SizedBox(height: AppDimens.spaceSm),
                  Container(
                    height: AppDimens.spaceMd,
                    width: cardWidth * 0.45,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: AppDimens.radiusExtraSmall,
                    ),
                  ),
                  SizedBox(height: AppDimens.spaceMd),
                  Container(
                    height: AppDimens.spaceMdLg,
                    width: cardWidth * 0.38,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: AppDimens.radiusExtraSmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Symbols.search_off,
            size: AppDimens.avatarMd,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: AppDimens.spaceSm),
          Text(
            'No recommendations yet',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Individual recommend card
// ─────────────────────────────────────────────────────────

class _RecommendCard extends StatelessWidget {
  final double width;
  final String title;
  final String imageUrl;
  final String rating;
  final String duration;
  final String category;
  final String price;

  const _RecommendCard({
    required this.width,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.duration,
    required this.category,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardRad = AppDimens.cardRadius(context);

    // Proportional image height based on card width.
    final imageHeight = AppDimens.heightRatio(width);

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(cardRad),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: AppDimens.spaceXl,
            offset: Offset(0, AppDimens.spaceXs),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: imageHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    cardRad - AppDimens.spaceXs,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: AppDimens.spaceMd,
                right: AppDimens.spaceMd,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.spaceSm,
                    vertical: AppDimens.spaceXs,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.9),
                    borderRadius: AppDimens.radiusPill,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Symbols.star,
                        size: AppDimens.iconXs,
                        color: theme.colorScheme.primary,
                      ),
                      SizedBox(width: AppDimens.spaceXs),
                      Text(
                        rating,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.spaceMd),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.spaceXs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimens.adaptive(
                      context,
                      small: AppDimens.spaceLg,
                      medium: AppDimens.spaceXl - 2,
                      large: AppDimens.spaceXl - 2,
                    ),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppDimens.spaceXs),
                Row(
                  children: [
                    Icon(
                      Symbols.schedule,
                      size: AppDimens.iconSm,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: AppDimens.spaceXs),
                    Text(
                      duration,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (category.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimens.spaceXs,
                        ),
                        child: Text(
                          '•',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          category,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: AppDimens.spaceMd),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        price,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: AppDimens.avatarSm,
                      width: AppDimens.avatarSm,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.secondary.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: AppDimens.spaceLg - 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        Symbols.add,
                        color: theme.colorScheme.onSecondary,
                        size: AppDimens.iconMd,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
