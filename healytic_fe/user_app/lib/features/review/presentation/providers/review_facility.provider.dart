import 'dart:developer';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/review/'
    'data/provider/facility_review.provider.dart';
import 'package:user_app/features/review/domain/'
    'entities/facility_review.entity.dart';

import 'review_rating_defaults.dart';

part 'review_facility.provider.freezed.dart';
part 'review_facility.provider.g.dart';

// ─── State ─────────────────────────────────────────

/// UI state for the facility review form.
@freezed
abstract class ReviewFacilityState with _$ReviewFacilityState {
  const factory ReviewFacilityState({
    /// Star rating (1–5).
    @Default(defaultReviewRating) int rating,

    /// Optional free-text comment.
    @Default('') String comment,

    /// Currently selected feedback tags.
    @Default([]) List<String> selectedTags,

    /// Local file paths of selected photos.
    @Default([]) List<String> photoPaths,

    /// True while the review is being submitted.
    @Default(false) bool isSubmitting,

    /// True after a successful submission.
    @Default(false) bool isSubmitted,

    /// Non-null when submission fails.
    String? errorMessage,
  }) = _ReviewFacilityState;
}

// ─── Notifier ──────────────────────────────────────

/// Manages the facility review form state and
/// handles submission through the repository.
@riverpod
class ReviewFacilityNotifier extends _$ReviewFacilityNotifier {
  @override
  ReviewFacilityState build() => const ReviewFacilityState();

  /// Sets the star rating (1–5).
  void setRating(int rating) {
    state = state.copyWith(rating: rating);
  }

  /// Updates the free-text comment.
  void setComment(String comment) {
    state = state.copyWith(comment: comment);
  }

  /// Toggles a feedback tag on or off.
  void toggleTag(String tag) {
    final tags = List<String>.from(state.selectedTags);
    if (tags.contains(tag)) {
      tags.remove(tag);
    } else {
      tags.add(tag);
    }
    state = state.copyWith(selectedTags: tags);
  }

  /// Appends new photo paths to the list.
  void addPhotos(List<String> paths) {
    state = state.copyWith(photoPaths: [...state.photoPaths, ...paths]);
  }

  /// Removes a single photo by its path.
  void removePhoto(String path) {
    final updated = List<String>.from(state.photoPaths)..remove(path);
    state = state.copyWith(photoPaths: updated);
  }

  /// Submits the review via the repository.
  ///
  /// Sets [isSubmitting] during the call,
  /// [isSubmitted] on success,
  /// or [errorMessage] on failure.
  Future<void> submitReview({
    required String appointmentId,
    required String facilityId,
  }) async {
    if (state.isSubmitting) return;

    if (state.rating < 1) {
      state = state.copyWith(
        errorMessage: 'Please select a rating before submitting.',
      );
      return;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final entity = FacilityReviewEntity(
        appointmentId: appointmentId,
        facilityId: facilityId,
        rating: state.rating,
        comment: state.comment,
        tags: state.selectedTags,
        photoPaths: state.photoPaths,
      );

      final repo = ref.read(facilityReviewRepositoryProvider);
      await repo.submitReview(entity);
      if (!ref.mounted) return;

      state = state.copyWith(isSubmitting: false, isSubmitted: true);
    } catch (e, s) {
      log(
        'Failed to submit facility review',
        error: e,
        stackTrace: s,
        name: 'ReviewFacilityNotifier',
      );
      if (!ref.mounted) return;
      state = state.copyWith(
        isSubmitting: false,
        errorMessage:
            'Failed to submit review. '
            'Please try again.',
      );
    }
  }
}
