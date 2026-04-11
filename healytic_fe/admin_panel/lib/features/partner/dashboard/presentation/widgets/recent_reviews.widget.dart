import 'package:admin_panel/features/partner/dashboard/domain/dashboard_review.entity.dart';
import 'package:admin_panel/features/partner/dashboard/presentation/widgets/dashboard_section_header.widget.dart';
import 'package:flutter/material.dart';

/// Scrollable list of recent customer reviews.
class RecentReviewsWidget extends StatelessWidget {
  const RecentReviewsWidget({
    super.key,
    required this.reviews,
  });

  final List<DashboardReview> reviews;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant
              .withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            DashboardSectionHeader(
              title: 'Recent Reviews',
              icon: Icons.rate_review_rounded,
              actionLabel: 'View All',
              onAction: () {},
            ),
            ...reviews.map(
              (r) => _ReviewItem(review: r),
            ),
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
      padding:
          const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor:
                colorScheme.primaryContainer,
            child: Text(
              review.reviewerName
                  .substring(0, 1)
                  .toUpperCase(),
              style: theme.textTheme.labelMedium
                  ?.copyWith(
                    color:
                        colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review.reviewerName,
                      style: theme
                          .textTheme.bodyMedium
                          ?.copyWith(
                            fontWeight:
                                FontWeight.w600,
                          ),
                    ),
                    Row(
                      children: List.generate(5, (i) {
                        return Icon(
                          i < review.rating
                              ? Icons.star_rounded
                              : Icons
                                  .star_outline_rounded,
                          size: 14,
                          color: i < review.rating
                              ? const Color(
                                  0xFFFBBF24,
                                )
                              : colorScheme
                                  .outlineVariant,
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  review.text,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(
                        color: colorScheme
                            .onSurfaceVariant,
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
