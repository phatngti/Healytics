import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:user_app/features/clinic_info/domain/entities/clinic_review.entity.dart';
import 'package:user_app/theme/app_theme.dart';

/// Displays the overall rating summary with a large
/// score, filled stars, a quality label, and
/// per-star distribution progress bars.
class ReviewSummaryCard extends StatelessWidget {
  const ReviewSummaryCard({
    super.key,
    required this.summary,
  });

  final ClinicReviewSummary summary;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.horizontalPadding(context),
        vertical: AppDimens.spaceLg,
      ),
      child: Row(
        children: [
          // ── Left: Score + Stars + Label ──
          _RatingScore(summary: summary),
          SizedBox(width: AppDimens.sectionSpacing(context)),
          // ── Right: Star bars ──
          Expanded(
            child: _StarDistribution(
              distribution: summary.starDistribution,
            ),
          ),
        ],
      ),
    );
  }
}

/// Large rating number with filled stars and a
/// quality label underneath.
class _RatingScore extends StatelessWidget {
  const _RatingScore({required this.summary});

  final ClinicReviewSummary summary;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors =
        Theme.of(context).extension<SemanticColors>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Score row: "4.9 out of 5"
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              summary.averageRating.toStringAsFixed(1),
              style: textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: AppDimens.spaceXs),
            Text(
              'out of 5',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.outline,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppDimens.spaceXs),

        // Star row
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            5,
            (_) => Icon(
              Symbols.star,
              size: AppDimens.iconSm,
              color:
                  semanticColors?.warning ??
                  colorScheme.tertiary,
              fill: 1,
            ),
          ),
        ),

        const SizedBox(height: AppDimens.spaceXs),

        // Quality label
        Text(
          summary.ratingLabel,
          style: textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

/// Vertical list of 5 progress bars showing the
/// percentage of reviews per star level.
class _StarDistribution extends StatelessWidget {
  const _StarDistribution({required this.distribution});

  final Map<int, double> distribution;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final star = 5 - index;
        final fraction = distribution[star] ?? 0.0;

        return Padding(
          padding: EdgeInsets.only(
            bottom:
                index < 4 ? AppDimens.spaceXs : 0,
          ),
          child: Row(
            children: [
              SizedBox(
                width: AppDimens.spaceSm,
                child: Text(
                  '$star',
                  style: textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(
                width: AppDimens.spaceSm,
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: AppDimens.radiusPill,
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: AppDimens.spaceXxs + 1,
                    backgroundColor: colorScheme
                        .surfaceContainerHighest,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(
                      colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
