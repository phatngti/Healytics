// Domain repository interface — pure Dart.

import 'package:user_app/features/review/domain/'
    'entities/specialist_review.entity.dart';

/// Contract for submitting specialist reviews.
abstract class SpecialistReviewRepository {
  /// Submits a specialist review to the backend.
  ///
  /// Throws on network or validation errors.
  Future<void> submitReview(
    SpecialistReviewEntity review,
  );
}
