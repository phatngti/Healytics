import 'package:admin_panel/features/admin/partner_manager/domain/field_feedback.entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'review_feedback.provider.g.dart';

/// State notifier for managing field-level feedback during partner review
@riverpod
class ReviewFeedback extends _$ReviewFeedback {
  @override
  Map<String, FieldFeedback> build() => {};

  /// Accept a field (mark as approved)
  void acceptField(String fieldId) {
    state = {
      ...state,
      fieldId: FieldFeedback(
        fieldId: fieldId,
        status: FieldFeedbackStatus.accepted,
      ),
    };
  }

  /// Request revision for a field with a note
  void requestRevision(String fieldId, String note) {
    state = {
      ...state,
      fieldId: FieldFeedback(
        fieldId: fieldId,
        status: FieldFeedbackStatus.revisionRequested,
        note: note,
      ),
    };
  }

  /// Clear feedback for a specific field (reset to pending)
  void clearFeedback(String fieldId) {
    final newState = Map<String, FieldFeedback>.from(state);
    newState.remove(fieldId);
    state = newState;
  }

  /// Clear all feedback
  void clearAll() {
    state = {};
  }

  /// Get feedback for a specific field
  FieldFeedback? getFeedback(String fieldId) => state[fieldId];

  /// Get count of fields flagged for revision
  int get flaggedFieldCount => state.values
      .where((f) => f.status == FieldFeedbackStatus.revisionRequested)
      .length;

  /// Get count of accepted fields
  int get acceptedFieldCount => state.values
      .where((f) => f.status == FieldFeedbackStatus.accepted)
      .length;

  /// Check if any fields are flagged for revision
  bool get hasRevisionRequests => flaggedFieldCount > 0;

  /// Get all revision feedback entries for API submission
  List<FieldFeedback> get revisionFeedbackList => state.values
      .where((f) => f.status == FieldFeedbackStatus.revisionRequested)
      .toList();
}
