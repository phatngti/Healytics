import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/home/domain/entities/service_details.entity.dart';
import 'package:user_app/features/home/presentation/providers/service_details.provider.dart';
import 'package:user_app/features/home/presentation/widgets/service_details/review_card.widget.dart';

/// Full-page list of all client reviews for a service.
///
/// Fetches data via [serviceDetailsProvider] using the
/// provided [serviceId].
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
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Reviews'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
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

          return _ReviewsList(
            reviews: reviews,
            rating: rating,
            colorScheme: colorScheme,
            textTheme: textTheme,
          );
        },
      ),
    );
  }
}

/// Scrollable list showing the rating summary and all
/// review cards.
class _ReviewsList extends StatelessWidget {
  const _ReviewsList({
    required this.reviews,
    required this.rating,
    required this.colorScheme,
    required this.textTheme,
  });

  final List<ReviewEntity> reviews;
  final double rating;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final hPad = AppDimens.horizontalPadding(context);

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: hPad,
        vertical: AppDimens.spaceLg,
      ),
      itemCount: reviews.length + 1,
      itemBuilder: (context, index) {
        // ── Rating summary header ──
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
            child: _RatingSummary(
              rating: rating,
              reviewCount: reviews.length,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          );
        }

        // ── Review card ──
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
          child: ReviewCard(review: reviews[index - 1]),
        );
      },
    );
  }
}

/// Compact rating summary shown at the top of the list.
class _RatingSummary extends StatelessWidget {
  const _RatingSummary({
    required this.rating,
    required this.reviewCount,
    required this.colorScheme,
    required this.textTheme,
  });

  final double rating;
  final int reviewCount;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.star,
          color: Color(0xFFFBBF24),
          size: AppDimens.iconMd,
        ),
        AppDimens.horizontalSmall,
        Text(
          '${rating.toStringAsFixed(1)}/5',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        AppDimens.horizontalSmall,
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
