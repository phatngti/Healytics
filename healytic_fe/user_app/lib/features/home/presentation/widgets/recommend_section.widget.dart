import 'package:common/widgets/images/network_image_auto.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';

import 'package:user_app/features/home/domain/entities/'
    'ai_recommendation.entity.dart';
import 'package:user_app/features/home/presentation/'
    'providers/home.provider.dart';
import 'package:user_app/features/home/presentation/widgets/'
    'home_section_header.widget.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/router/routes.dart';

/// Displays a horizontally-scrollable list of
/// AI-recommended services fetched via
/// [recommendedProductsProvider].
class RecommendSection extends ConsumerWidget {
  const RecommendSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiAsync = ref.watch(recommendedProductsProvider);
    final titleGap = AppDimens.titleGap(context);

    // Proportional card width: ~65 % of screen so
    // 1.3–1.5 cards are visible, hinting at scroll.
    final cardWidth = AppDimens.widthFraction(context);

    // Proportional list height scales with card width.
    final listHeight = AppDimens.heightRatio(cardWidth, ratio: 1.08);

    return Column(
      children: [
        HomeSectionHeader(
          title: 'Recommend For You',
          actionKey: keys.homePage.recommendationsViewAll,
          onViewAll: () {
            const HomeRecommendationsRoute().push(context);
          },
        ),
        SizedBox(height: titleGap),
        SizedBox(
          height: listHeight,
          child: aiAsync.when(
            loading: () => _LoadingList(cardWidth: cardWidth),
            error: (_, __) => const _EmptyState(),
            data: (items) {
              if (items.isEmpty) {
                return const _EmptyState();
              }
              return _RecommendList(items: items, cardWidth: cardWidth);
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Horizontal recommendation list
// ─────────────────────────────────────────────────────────

class _RecommendList extends StatelessWidget {
  final List<AiRecommendation> items;
  final double cardWidth;

  const _RecommendList({required this.items, required this.cardWidth});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(width: AppDimens.spaceLg),
      itemBuilder: (_, index) {
        return _RecommendCard(width: cardWidth, item: items[index]);
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
  final AiRecommendation item;

  const _RecommendCard({required this.width, required this.item});

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
          _CardImage(
            imageUrl: item.imageUrl,
            rating: item.rating,
            totalReviews: item.totalReviews,
            badge: item.badge,
            height: imageHeight,
            cardRadius: cardRad,
          ),
          SizedBox(height: AppDimens.spaceMd),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.spaceXs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CardTitle(name: item.name, width: width),
                if (item.staffName != null) ...[
                  SizedBox(height: AppDimens.spaceXxs),
                  _CardStaff(staffName: item.staffName!),
                ],
                SizedBox(height: AppDimens.spaceXs),
                _CardMeta(
                  location: item.location,
                  bookedCount: item.bookedCount,
                ),
                SizedBox(height: AppDimens.spaceMd),
                _CardFooter(price: item.price, currency: item.currency),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Card sub-widgets
// ─────────────────────────────────────────────────────────

class _CardImage extends StatelessWidget {
  final String imageUrl;
  final double rating;
  final int totalReviews;
  final String? badge;
  final double height;
  final double cardRadius;

  const _CardImage({
    required this.imageUrl,
    required this.rating,
    required this.totalReviews,
    this.badge,
    required this.height,
    required this.cardRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final innerRadius = cardRadius - AppDimens.spaceXs;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(innerRadius),
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: NetworkImageAuto(imageUrl: imageUrl, fit: BoxFit.cover),
          ),
        ),
        // Rating badge with review count
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
                  rating.toStringAsFixed(1),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (totalReviews > 0) ...[
                  SizedBox(width: AppDimens.spaceXxs),
                  Text(
                    '($totalReviews)',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        // Optional badge (e.g. "Popular")
        if (badge != null)
          Positioned(
            top: AppDimens.spaceMd,
            left: AppDimens.spaceMd,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.spaceSm,
                vertical: AppDimens.spaceXs,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: AppDimens.radiusPill,
              ),
              child: Text(
                badge!,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CardTitle extends StatelessWidget {
  final String name;
  final double width;

  const _CardTitle({required this.name, required this.width});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      name,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: AppDimens.adaptive(
          context,
          small: AppDimens.spaceLg,
          medium: AppDimens.iconSmMd,
          large: AppDimens.iconSmMd,
        ),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Shows the staff/specialist name when the DTO
/// provides it via [ServiceDetail.staffName].
class _CardStaff extends StatelessWidget {
  final String staffName;

  const _CardStaff({required this.staffName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          Symbols.person,
          size: AppDimens.iconXs,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: AppDimens.spaceXs),
        Flexible(
          child: Text(
            staffName,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _CardMeta extends StatelessWidget {
  final String location;
  final int bookedCount;

  const _CardMeta({required this.location, required this.bookedCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final metaStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Row(
      children: [
        Icon(
          Symbols.location_on,
          size: AppDimens.iconSm,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: AppDimens.spaceXs),
        Flexible(
          child: Text(
            location,
            style: metaStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (bookedCount > 0) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.spaceXs),
            child: Text('•', style: metaStyle),
          ),
          Text('$bookedCount booked', style: metaStyle),
        ],
      ],
    );
  }
}

class _CardFooter extends StatelessWidget {
  final String price;
  final String currency;

  const _CardFooter({required this.price, required this.currency});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
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
                color: theme.colorScheme.secondary.withValues(alpha: 0.3),
                blurRadius: AppDimens.spaceMdLg,
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
    );
  }
}
