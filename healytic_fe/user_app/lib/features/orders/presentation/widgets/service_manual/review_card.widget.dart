import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/orders/domain/entities/service_manual.entity.dart';
import 'package:user_app/features/orders/presentation/widgets/service_manual/manual_section_card.widget.dart';
import 'package:user_app/theme/app_theme.dart';

/// Displays the "Đánh giá" section with average
/// rating and a featured review quote.
class ManualReviewCard extends StatelessWidget {
  const ManualReviewCard({super.key, required this.review});

  /// Review data to display.
  final ManualReviewEntity review;

  @override
  Widget build(BuildContext context) {
    return ManualSectionCard(
      icon: Symbols.star,
      title: 'Đánh giá',
      trailing: _RatingBadge(rating: review.averageRating),
      child: _ReviewQuote(review: review),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          rating.toStringAsFixed(1),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        SizedBox(width: AppDimens.spaceXxs),
        Text(
          '/ 5',
          style: theme.textTheme.labelSmall?.copyWith(color: colors.outline),
        ),
      ],
    );
  }
}

class _ReviewQuote extends StatelessWidget {
  const _ReviewQuote({required this.review});

  final ManualReviewEntity review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final semanticColors = theme.extension<SemanticColors>();

    return Container(
      padding: AppDimens.paddingAllMedium,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Star icons
              ...List.generate(
                review.starCount,
                (_) => Icon(
                  Symbols.star_rate,
                  size: AppDimens.iconSm,
                  color: semanticColors?.warning ?? colors.tertiary,
                  fill: 1,
                ),
              ),
              AppDimens.horizontalSmall,
              Text(
                review.reviewerName,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
          AppDimens.verticalSmall,
          Text(
            '"${review.reviewText}"',
            style: theme.textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
