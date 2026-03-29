// Domain repository interface for treatment reviews.
//
// Pure Dart — no Flutter or framework imports.

import 'package:user_app/features/review/domain/'
    'entities/treatment_review.entity.dart';

/// Contract for submitting treatment reviews.
abstract class TreatmentReviewRepository {
  /// Submits a treatment review to the backend.
  ///
  /// Throws on network or validation errors.
  Future<void> submitReview(
    TreatmentReviewEntity review,
  );
}
