import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/service_details.provider.dart';
import 'reviews_section.widget.dart';

/// Async loader for the [ReviewsSection].
///
/// Fetches reviews for [employeeId] via
/// [employeeReviewsProvider], then renders
/// the section with the given [rating].
///
/// Can be dropped into any screen that has a
/// specialist/employee identifier.
class ReviewsSectionLoader extends ConsumerWidget {
  const ReviewsSectionLoader({
    super.key,
    required this.employeeId,
    required this.onViewMoreTap,
    this.rating = 4.9,
  });

  /// Employee whose reviews to fetch.
  final String employeeId;

  /// Opens the full specialist reviews screen.
  final void Function(BuildContext context) onViewMoreTap;

  /// Overall rating shown in the section header.
  final double rating;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncReviews = ref.watch(
      employeeReviewsProvider(employeeId: employeeId),
    );

    return asyncReviews.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (reviews) => ReviewsSection(
        reviews: reviews,
        rating: rating,
        serviceId: employeeId,
        onViewMoreTap: () => onViewMoreTap(context),
      ),
    );
  }
}
