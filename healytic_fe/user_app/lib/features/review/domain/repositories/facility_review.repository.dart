// Domain repository interface for facility reviews.
//
// Pure Dart — no Flutter or framework imports.

import 'package:user_app/features/review/domain/'
    'entities/facility_review.entity.dart';

/// Contract for submitting facility reviews.
abstract class FacilityReviewRepository {
  /// Submits a facility review to the backend.
  ///
  /// Throws on network or validation errors.
  Future<void> submitReview(
    FacilityReviewEntity review,
  );
}
