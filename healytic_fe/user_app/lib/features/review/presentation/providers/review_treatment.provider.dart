import 'dart:developer';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/orders/domain/'
    'entities/appointment.entity.dart';
import 'package:user_app/features/orders/presentation/'
    'providers/appointment.provider.dart';
import 'package:user_app/features/review/'
    'data/provider/treatment_review.provider.dart';
import 'package:user_app/features/review/domain/'
    'entities/treatment_review.entity.dart';

import 'review_rating_defaults.dart';

part 'review_treatment.provider.freezed.dart';
part 'review_treatment.provider.g.dart';

// ─── State ─────────────────────────────────────────

/// UI state for the treatment review form.
@freezed
abstract class ReviewTreatmentState with _$ReviewTreatmentState {
  const factory ReviewTreatmentState({
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

    /// The fetched appointment (populated on
    /// submit success, used for navigation).
    AppointmentEntity? appointment,

    /// Non-null when submission fails.
    String? errorMessage,
  }) = _ReviewTreatmentState;
}

// ─── Notifier ──────────────────────────────────────

/// Manages the treatment review form state and
/// handles submission through the repository.
@riverpod
class ReviewTreatmentNotifier extends _$ReviewTreatmentNotifier {
  @override
  ReviewTreatmentState build() => const ReviewTreatmentState();

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

  /// Submits the review via the repository, then
  /// fetches the appointment for navigation context.
  ///
  /// Sets [isSubmitting] during the call,
  /// [isSubmitted] and [appointment] on success,
  /// or [errorMessage] on failure.
  Future<void> submitReview(String appointmentId) async {
    if (state.isSubmitting) return;

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final entity = TreatmentReviewEntity(
        appointmentId: appointmentId,
        rating: state.rating,
        comment: state.comment,
        tags: state.selectedTags,
        photoPaths: state.photoPaths,
      );

      final repo = ref.read(treatmentReviewRepositoryProvider);
      await repo.submitReview(entity);
      if (!ref.mounted) return;

      // Fetch appointment for navigation context.
      // Silently ignore fetch failures — navigation
      // will use fallback values for specialist name.
      AppointmentEntity? appointment;
      try {
        appointment = await ref.read(
          appointmentByIdProvider(appointmentId).future,
        );
      } catch (_) {
        // Non-critical: navigation still proceeds.
      }
      if (!ref.mounted) return;

      state = state.copyWith(
        isSubmitting: false,
        isSubmitted: true,
        appointment: appointment,
      );
    } catch (e, s) {
      log(
        'Failed to submit treatment review',
        error: e,
        stackTrace: s,
        name: 'ReviewTreatmentNotifier',
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
