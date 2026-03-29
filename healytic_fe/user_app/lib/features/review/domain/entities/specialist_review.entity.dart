import 'package:freezed_annotation/freezed_annotation.dart';

part 'specialist_review.entity.freezed.dart';

/// Represents a user's review of a specialist
/// after a completed appointment session.
@freezed
abstract class SpecialistReviewEntity
    with _$SpecialistReviewEntity {
  const factory SpecialistReviewEntity({
    /// The appointment this review belongs to.
    required String appointmentId,

    /// The specialist being reviewed.
    required String specialistId,

    /// Star rating from 1 to 5.
    required int rating,

    /// Optional free-text feedback.
    @Default('') String comment,

    /// Selected feedback tags (e.g. Professional).
    @Default([]) List<String> tags,

    /// Whether the user would recommend this
    /// specialist to others.
    @Default(true) bool wouldRecommend,
  }) = _SpecialistReviewEntity;
}
