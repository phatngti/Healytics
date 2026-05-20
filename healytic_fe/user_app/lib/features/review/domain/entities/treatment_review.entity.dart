// Domain entity for the treatment review.
//
// Pure Dart — no Flutter or framework imports.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'treatment_review.entity.freezed.dart';

/// Represents a user's review of a completed
/// treatment appointment session.
@freezed
abstract class TreatmentReviewEntity
    with _$TreatmentReviewEntity {
  const factory TreatmentReviewEntity({
    /// The appointment this review belongs to.
    required String appointmentId,

    /// Star rating from 1 to 5.
    required int rating,

    /// Optional free-text feedback.
    @Default('') String comment,

    /// Selected feedback tags
    /// (e.g. 'On-time', 'Relaxing').
    @Default([]) List<String> tags,

    /// Local file paths of attached photos.
    @Default([]) List<String> photoPaths,
  }) = _TreatmentReviewEntity;
}
