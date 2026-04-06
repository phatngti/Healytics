import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:user_app/features/clinic_info/presentation/providers/clinic_reviews.provider.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_reviews/review_card.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_reviews/review_filter_pills.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_reviews/review_summary_card.widget.dart';

/// Content body for the "Reviews" tab inside
/// [ClinicInfoScreen].
///
/// Orchestrates the rating summary, filter pills,
/// and paginated review feed. Watches the
/// [clinicReviewsPaginatedProvider] for reactive
/// updates.
class ReviewTabContent extends ConsumerWidget {
  const ReviewTabContent({
    super.key,
    required this.clinicId,
  });

  final String clinicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final asyncReviews = ref.watch(
      clinicReviewsPaginatedProvider(
        clinicId: clinicId,
      ),
    );

    return asyncReviews.when(
      data: (data) => _ReviewContentLoaded(
        data: data,
        clinicId: clinicId,
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (err, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(
            AppDimens.spaceXxl,
          ),
          child: Text(
            'Something went wrong.\n'
            'Please try again.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

/// Loaded state: summary card + filter pills +
/// scrollable review feed with pagination.
class _ReviewContentLoaded extends ConsumerWidget {
  const _ReviewContentLoaded({
    required this.data,
    required this.clinicId,
  });

  final ClinicReviewsAccumulated data;
  final String clinicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    // Total items: summary(1) + pills(1) + reviews(N)
    // + optional "load more" footer(1).
    final reviewCount = data.reviews.length;
    final hasFooter =
        data.hasMore || data.isLoadingMore;
    final itemCount =
        2 + reviewCount + (hasFooter ? 1 : 0);

    return ListView.separated(
      padding: EdgeInsets.only(
        bottom:
            AppDimens.bottomScrollPadding(context),
      ),
      itemCount: itemCount,
      separatorBuilder: (_, index) {
        // Thin gap between review cards and sections.
        return SizedBox(
          height: AppDimens.spaceXxs,
          child: ColoredBox(
            color: colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.3),
          ),
        );
      },
      itemBuilder: (context, index) {
        // Slot 0 → Summary card
        if (index == 0) {
          return ReviewSummaryCard(
            summary: data.summary,
          );
        }

        // Slot 1 → Filter pills
        if (index == 1) {
          return ReviewFilterPills(
            filters: data.filters,
          );
        }

        // Slot 2..(n+1) → Review cards
        final reviewIndex = index - 2;
        if (reviewIndex < reviewCount) {
          return ReviewCard(
            review: data.reviews[reviewIndex],
          );
        }

        // Footer → Load More / Loading indicator
        return _LoadMoreFooter(
          isLoading: data.isLoadingMore,
          onLoadMore: () => ref
              .read(
                clinicReviewsPaginatedProvider(
                  clinicId: clinicId,
                ).notifier,
              )
              .loadMore(),
        );
      },
    );
  }
}

/// Footer widget that shows a "Load More" button
/// or a loading spinner.
class _LoadMoreFooter extends StatelessWidget {
  const _LoadMoreFooter({
    required this.isLoading,
    required this.onLoadMore,
  });

  final bool isLoading;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppDimens.spaceLg,
      ),
      child: Center(
        child: isLoading
            ? SizedBox(
                width: AppDimens.iconLg,
                height: AppDimens.iconLg,
                child: CircularProgressIndicator(
                  strokeWidth:
                      AppDimens.borderWidthThick,
                ),
              )
            : TextButton(
                onPressed: onLoadMore,
                child: Text(
                  'Load more reviews',
                  style:
                      textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
      ),
    );
  }
}
