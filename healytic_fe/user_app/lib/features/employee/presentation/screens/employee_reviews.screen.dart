import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/employee/presentation/providers/employee_detail.provider.dart';
import 'package:user_app/features/employee/presentation/providers/employee_reviews.provider.dart';
import 'package:user_app/features/service_details/domain/entities/service_details.entity.dart';
import 'package:user_app/features/service_details/presentation/widgets/service_details/review_card.widget.dart';

/// Full-screen employee review feed.
class EmployeeReviewsScreen extends ConsumerWidget {
  const EmployeeReviewsScreen({
    super.key,
    required this.employeeId,
    required this.employeeName,
  });

  final String employeeId;
  final String employeeName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncReviews = ref.watch(employeeReviewsProvider(employeeId));
    final asyncEmployee = ref.watch(employeeDetailProvider(employeeId));
    final rating = switch (asyncEmployee) {
      AsyncData(:final value) => value.rating,
      _ => 0.0,
    };

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _AppBar(employeeName: employeeName),
          asyncReviews.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SliverFillRemaining(child: _ErrorState()),
            data: (reviews) {
              if (reviews.isEmpty) {
                return const SliverFillRemaining(child: _EmptyState());
              }

              return _ReviewsList(reviews: reviews, rating: rating);
            },
          ),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({required this.employeeName});

  final String employeeName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SliverAppBar(
      pinned: true,
      title: Column(
        children: [
          Text(
            'Reviews',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            employeeName,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      centerTitle: true,
      backgroundColor: colorScheme.surface.withValues(alpha: 0.8),
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
        onPressed: () => Navigator.of(context).maybePop(),
      ),
    );
  }
}

class _ReviewsList extends StatelessWidget {
  const _ReviewsList({required this.reviews, required this.rating});

  final List<ReviewEntity> reviews;
  final double rating;

  @override
  Widget build(BuildContext context) {
    final hPad = AppDimens.horizontalPadding(context);

    return SliverPadding(
      padding: EdgeInsets.only(
        left: hPad,
        right: hPad,
        top: AppDimens.spaceLg,
        bottom: AppDimens.bottomScrollPadding(context),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.spaceXl),
              child: _ReviewSummary(
                rating: rating,
                reviewCount: reviews.length,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.spaceXxl),
            child: ReviewCard(review: reviews[index - 1]),
          );
        }, childCount: reviews.length + 1),
      ),
    );
  }
}

class _ReviewSummary extends StatelessWidget {
  const _ReviewSummary({required this.rating, required this.reviewCount});

  final double rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(
          Symbols.star_rate,
          color: colorScheme.primary,
          size: AppDimens.iconLg,
        ),
        SizedBox(width: AppDimens.spaceSm),
        Text(
          rating.toStringAsFixed(1),
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: AppDimens.spaceXs),
        Text(
          '($reviewCount reviews)',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Symbols.star_rate,
            size: AppDimens.iconXxl,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          AppDimens.verticalMedium,
          Text(
            'No reviews yet',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimens.horizontalPadding(context)),
        child: Text(
          'Failed to load reviews',
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
