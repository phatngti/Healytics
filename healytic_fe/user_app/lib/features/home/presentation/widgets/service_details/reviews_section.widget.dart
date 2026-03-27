import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:user_app/features/home/domain/entities/service_details.entity.dart';
import 'package:user_app/router/routes.dart';

import 'review_card.widget.dart';

/// Reviews section with a header row (title + overall rating)
/// and a preview of the first [_previewCount] reviews.
///
/// Always shows a "View More" button that navigates to the
/// full reviews page.
///
/// Renders nothing when [reviews] is empty.
class ReviewsSection extends StatelessWidget {
  const ReviewsSection({
    super.key,
    required this.reviews,
    required this.rating,
    required this.serviceId,
  });

  /// Reviews to display (preview only).
  final List<ReviewEntity> reviews;

  /// Overall service rating shown beside the title.
  final double rating;

  /// Service identifier passed to the reviews route.
  final String serviceId;

  /// Number of review cards shown in the preview.
  static const int _previewCount = 2;

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final visible = reviews.take(_previewCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header row ──
        _SectionHeader(
          rating: rating,
          textTheme: textTheme,
          colorScheme: colorScheme,
        ),
        AppDimens.verticalMedium,

        // ── Preview review cards ──
        ...visible.map(
          (review) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
            child: ReviewCard(review: review),
          ),
        ),

        // ── View More button ──
        _ViewMoreButton(
          totalCount: reviews.length,
          colorScheme: colorScheme,
          textTheme: textTheme,
          onTap: () => ReviewsRoute(serviceId: serviceId).push(context),
        ),
      ],
    );
  }
}

/// Header showing "Reviews" title and the average rating
/// badge.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.rating,
    required this.textTheme,
    required this.colorScheme,
  });

  final double rating;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Reviews',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Text(
              '${rating.toStringAsFixed(1)}/5',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppDimens.horizontalExtraSmall,
            const Icon(
              Icons.star,
              color: Color(0xFFFBBF24),
              size: AppDimens.iconXs,
            ),
          ],
        ),
      ],
    );
  }
}

/// "View More (N)" button that navigates to the full
/// reviews page.
class _ViewMoreButton extends StatelessWidget {
  const _ViewMoreButton({
    required this.totalCount,
    required this.colorScheme,
    required this.textTheme,
    required this.onTap,
  });

  final int totalCount;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(
          Icons.arrow_forward,
          size: AppDimens.iconSm,
          color: colorScheme.primary,
        ),
        label: Text(
          'View More ($totalCount)',
          style: textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
