import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/service_details/domain/entities/service_details.entity.dart';
import 'package:user_app/features/service_details/presentation/providers/service_details.provider.dart';
import 'package:user_app/features/service_details/presentation/widgets/service_details/review_card.widget.dart';

/// Full-page review summary and feed for a service.
///
/// Reproduces an Airbnb-style layout: hero rating
/// badge, stats grid, count header, and review list.
class ReviewsScreen extends ConsumerWidget {
  const ReviewsScreen({super.key, required this.serviceId});

  /// Identifier used to fetch the service's reviews.
  final String serviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncReviews = ref.watch(
      serviceReviewsProvider(serviceId: serviceId),
    );
    final asyncDetails = ref.watch(
      serviceDetailsProvider(serviceId: serviceId),
    );
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: asyncReviews.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Failed to load reviews: $error')),
        data: (reviews) {
          if (reviews.isEmpty) {
            return Center(
              child: Text(
                'No reviews yet',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }

          final rating = asyncDetails.value?.rating ?? 0.0;

          return _ReviewsBody(reviews: reviews, rating: rating);
        },
      ),
    );
  }
}

/// Main scrollable body combining the hero section,
/// stats grid, count header, and the review feed.
class _ReviewsBody extends StatelessWidget {
  const _ReviewsBody({required this.reviews, required this.rating});

  final List<ReviewEntity> reviews;
  final double rating;

  @override
  Widget build(BuildContext context) {
    final hPad = AppDimens.horizontalPadding(context);

    return ListView.builder(
      padding: EdgeInsets.only(
        left: hPad,
        right: hPad,
        bottom: AppDimens.bottomScrollPadding(context),
      ),
      itemCount: reviews.length + 3,
      itemBuilder: (context, index) {
        // ── Hero section ──
        if (index == 0) {
          return _HeroRatingSection(rating: rating);
        }

        // ── Stats grid ──
        if (index == 1) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.spaceXl),
            child: _StatsGrid(reviews: reviews, rating: rating),
          );
        }

        // ── Count header ──
        if (index == 2) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
            child: _ReviewCountHeader(reviewCount: reviews.length),
          );
        }

        // ── Review cards ──
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.spaceXxl),
          child: ReviewCard(review: reviews[index - 3]),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════
// Hero Rating Section
// ═══════════════════════════════════════════════════════

/// Centered rating badge with laurel icons, title,
/// and description.
class _HeroRatingSection extends StatelessWidget {
  const _HeroRatingSection({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(
        top: AppDimens.spaceSm,
        bottom: AppDimens.spaceXxl,
      ),
      child: Column(
        children: [
          // ── Rating number with laurels ──
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events, size: 40, color: colorScheme.primary),
              AppDimens.horizontalMedium,
              Text(
                rating.toStringAsFixed(2),
                style: textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -2,
                  height: 1,
                ),
              ),
              AppDimens.horizontalMedium,
              Icon(Icons.emoji_events, size: 40, color: colorScheme.primary),
            ],
          ),
          AppDimens.verticalSmall,

          // ── "Guest favorite" title ──
          Text(
            'Guest favorite',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppDimens.verticalMediumSmall,

          // ── Description ──
          SizedBox(
            width: 320,
            child: Text.rich(
              TextSpan(
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: 'This doctor or therapist is '),
                  TextSpan(
                    text: 'top 5%',
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const TextSpan(
                    text:
                        ' of eligible listings based '
                        'on ratings, reviews, and '
                        'reliability',
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// Stats Grid (Rating Bars + Category Ratings)
// ═══════════════════════════════════════════════════════

/// Two-column grid: left = distribution bars,
/// right = category scores.
class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.reviews, required this.rating});

  final List<ReviewEntity> reviews;
  final double rating;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left column — rating bars
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: AppDimens.spaceMd),
              child: _RatingBarsColumn(reviews: reviews),
            ),
          ),

          // Vertical divider
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),

          // Right column — category ratings
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: AppDimens.spaceMd),
              child: _CategoryRatingsColumn(rating: rating),
            ),
          ),
        ],
      ),
    );
  }
}

/// 5→1 star distribution bars computed from reviews.
class _RatingBarsColumn extends StatelessWidget {
  const _RatingBarsColumn({required this.reviews});

  final List<ReviewEntity> reviews;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Compute distribution
    final counts = List.filled(5, 0);
    for (final r in reviews) {
      final idx = r.rating.clamp(1, 5) - 1;
      counts[idx]++;
    }
    final total = reviews.isEmpty ? 1 : reviews.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overall rating',
          style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        AppDimens.verticalMediumSmall,
        for (int star = 5; star >= 1; star--)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.spaceXs),
            child: _RatingBar(
              star: star,
              fraction: counts[star - 1] / total,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          ),
      ],
    );
  }
}

/// Single horizontal progress bar for one star
/// level.
class _RatingBar extends StatelessWidget {
  const _RatingBar({
    required this.star,
    required this.fraction,
    required this.colorScheme,
    required this.textTheme,
  });

  final int star;
  final double fraction;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      child: Row(
        children: [
          SizedBox(
            width: 10,
            child: Text(
              '$star',
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          AppDimens.horizontalSmall,
          Expanded(
            child: ClipRRect(
              borderRadius: AppDimens.radiusPill,
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 6,
                backgroundColor: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                valueColor: AlwaysStoppedAnimation<Color>(
                  colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Category rating scores derived from overall
/// rating with slight variation.
class _CategoryRatingsColumn extends StatelessWidget {
  const _CategoryRatingsColumn({required this.rating});

  final double rating;

  static const _categories = [
    'Personalized\nCare',
    'Ambiance &\nComfort',
    'Staff\nProfessionalism',
    'Safety &\nCompliance',
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        for (int i = 0; i < _categories.length; i++)
          _CategoryRow(
            label: _categories[i],
            score: (rating - 0.1 * (i % 2)).clamp(0.0, 5.0),
            showDivider: i < _categories.length - 1,
            textTheme: textTheme,
            colorScheme: colorScheme,
          ),
      ],
    );
  }
}

/// One category metric row with label + score.
class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.label,
    required this.score,
    required this.showDivider,
    required this.textTheme,
    required this.colorScheme,
  });

  final String label;
  final double score;
  final bool showDivider;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
      decoration: showDivider
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
          Text(
            score.toStringAsFixed(1),
            style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// Review Count Header
// ═══════════════════════════════════════════════════════

/// "N reviews" title + "Most relevant" sort button.
class _ReviewCountHeader extends StatelessWidget {
  const _ReviewCountHeader({required this.reviewCount});

  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$reviewCount reviews',
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        AppDimens.verticalExtraSmall,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Learn how reviews work',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                decoration: TextDecoration.underline,
                decorationColor: colorScheme.onSurfaceVariant,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
                vertical: AppDimens.spaceXs,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outlineVariant),
                borderRadius: AppDimens.radiusSmall,
                color: colorScheme.surface,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Most relevant',
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppDimens.horizontalExtraSmall,
                  Icon(
                    Icons.expand_more,
                    size: AppDimens.iconSm,
                    color: colorScheme.onSurface,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
