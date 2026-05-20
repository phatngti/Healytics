import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/review/'
    'data/datasources/remote/'
    'specialist_review_remote_datasource.dart';
import 'package:user_app/features/review/'
    'data/repositories/'
    'specialist_review_impl.repository.dart';
import 'package:user_app/features/review/domain/'
    'entities/specialist_review.entity.dart';
import 'package:user_app/features/review/domain/'
    'repositories/specialist_review.repository.dart';

import 'review_rating_defaults.dart';

part 'review_specialist.provider.freezed.dart';
part 'review_specialist.provider.g.dart';

// ─── Repository Provider ───────────────────────────

/// Provides [SpecialistReviewRepository] backed by
/// the current datasource (real or mock).
@riverpod
SpecialistReviewRepository specialistReviewRepository(Ref ref) {
  final datasource = ref.read(specialistReviewRemoteDatasourceProvider);
  return SpecialistReviewRepositoryImpl(datasource);
}

// ─── Form State ────────────────────────────────────

/// UI state for the specialist review form.
@freezed
abstract class ReviewSpecialistState with _$ReviewSpecialistState {
  const factory ReviewSpecialistState({
    /// Star rating (1–5).
    @Default(defaultReviewRating) int rating,

    /// Optional free-text comment.
    @Default('') String comment,

    /// Currently selected feedback tags.
    @Default([]) List<String> selectedTags,

    /// Whether user would recommend the specialist.
    @Default(true) bool wouldRecommend,

    /// True while the review is being submitted.
    @Default(false) bool isSubmitting,

    /// True after a successful submission.
    @Default(false) bool isSubmitted,
  }) = _ReviewSpecialistState;
}

// ─── Form Notifier ─────────────────────────────────

/// Manages the specialist review form state and
/// handles submission through the repository.
@riverpod
class ReviewSpecialistNotifier extends _$ReviewSpecialistNotifier {
  @override
  ReviewSpecialistState build() => const ReviewSpecialistState();

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

  /// Toggles the "would recommend" preference.
  void toggleRecommend() {
    state = state.copyWith(wouldRecommend: !state.wouldRecommend);
  }

  /// Submits the review via the repository.
  ///
  /// Sets [isSubmitting] during the call and
  /// [isSubmitted] on success.
  Future<void> submitReview({
    required String appointmentId,
    required String specialistId,
  }) async {
    state = state.copyWith(isSubmitting: true);

    try {
      final entity = SpecialistReviewEntity(
        appointmentId: appointmentId,
        specialistId: specialistId,
        rating: state.rating,
        comment: state.comment,
        tags: state.selectedTags,
        wouldRecommend: state.wouldRecommend,
      );

      final repo = ref.read(specialistReviewRepositoryProvider);
      await repo.submitReview(entity);

      if (!ref.mounted) return;

      state = state.copyWith(isSubmitting: false, isSubmitted: true);
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(isSubmitting: false);
      rethrow;
    }
  }
}
