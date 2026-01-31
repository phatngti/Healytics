import 'package:freezed_annotation/freezed_annotation.dart';

part 'field_feedback.entity.freezed.dart';

/// Status of admin feedback for a specific field
enum FieldFeedbackStatus {
  /// Field has not been reviewed yet
  pending,

  /// Field has been accepted/approved
  accepted,

  /// Field requires revision with feedback note
  revisionRequested,
}

/// Represents admin feedback for a single field during verification review
@freezed
abstract class FieldFeedback with _$FieldFeedback {
  const factory FieldFeedback({
    /// Unique identifier for the field (e.g., 'business.brandName')
    required String fieldId,

    /// Current feedback status
    @Default(FieldFeedbackStatus.pending) FieldFeedbackStatus status,

    /// Optional revision note when status is revisionRequested
    String? note,
  }) = _FieldFeedback;
}
