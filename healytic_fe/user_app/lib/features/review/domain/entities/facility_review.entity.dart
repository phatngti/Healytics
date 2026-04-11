// Domain entity for the facility/clinic review.
//
// Pure Dart — no Flutter or framework imports.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'facility_review.entity.freezed.dart';

/// Represents a user's review of a clinic facility
/// after a completed appointment session.
@freezed
abstract class FacilityReviewEntity
    with _$FacilityReviewEntity {
  const factory FacilityReviewEntity({
    /// The appointment this review belongs to.
    required String appointmentId,

    /// The facility/clinic being reviewed
    /// (partner ID).
    required String facilityId,

    /// Star rating from 1 to 5.
    required int rating,

    /// Optional free-text feedback.
    @Default('') String comment,

    /// Selected feedback tags
    /// (e.g. 'Clean', 'Comfortable').
    @Default([]) List<String> tags,

    /// Local file paths of attached photos.
    @Default([]) List<String> photoPaths,
  }) = _FacilityReviewEntity;
}
