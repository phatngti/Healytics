import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

import '../../domain/dashboard_review.entity.dart';
import 'dashboard_constants.dart';
import 'dashboard_section_header.widget.dart';

/// Scrollable list of recent customer reviews.
class RecentReviewsWidget extends StatelessWidget {
  const RecentReviewsWidget({super.key, required this.reviews});

  final List<DashboardReview> reviews;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimens.radiusMediumSmall,
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: AppDimens.paddingAllMediumLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardSectionHeader(
              title: 'Recent Reviews',
              icon: Icons.rate_review_rounded,
              actionLabel: 'View All',
              onAction: () {},
            ),
            ...reviews.map((r) => _ReviewItem(review: r)),
          ],
        ),
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  const _ReviewItem({required this.review});

  final DashboardReview review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: AppDimens.paddingVerticalSmall,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: AppDimens.iconSmMd,
            backgroundColor: colorScheme.primaryContainer,
            child: Text(
              review.reviewerName.substring(0, 1).toUpperCase(),
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: AppDimens.fontWeightSemiBold,
              ),
            ),
          ),
          AppDimens.horizontalMediumSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review.reviewerName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: AppDimens.fontWeightSemiBold,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (i) {
                        return Icon(
                          i < review.rating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: AppDimens.iconXs,
                          color: i < review.rating
                              ? DashboardColors.starRating
                              : colorScheme.outlineVariant,
                        );
                      }),
                    ),
                  ],
                ),
                AppDimens.verticalExtraSmall,
                Text(
                  review.text,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
