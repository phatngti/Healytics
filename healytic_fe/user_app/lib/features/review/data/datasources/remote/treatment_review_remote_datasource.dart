import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/review/domain/'
    'entities/treatment_review.entity.dart';
import 'package:user_openapi/api.dart';

// ─── Abstract Interface ────────────────────────────

/// Contract for submitting treatment review data
/// to a remote source.
abstract class TreatmentReviewRemoteDatasource {
  /// Sends the treatment review to the backend.
  Future<void> submitReview(
    TreatmentReviewEntity review,
  );
}

// ─── Real Implementation ───────────────────────────

/// Production implementation backed by the
/// [UserReviewsApi] OpenAPI client.
///
/// Note: [photoPaths] are local file paths. S3
/// upload is handled separately; [photoKeys] is
/// left empty until that flow is integrated.
class TreatmentReviewRemoteDatasourceImpl
    implements TreatmentReviewRemoteDatasource {
  final ApiService _apiService;

  TreatmentReviewRemoteDatasourceImpl(this._apiService);

  @override
  Future<void> submitReview(
    TreatmentReviewEntity review,
  ) async {
    final dto = CreateTreatmentReviewDto(
      appointmentId: review.appointmentId,
      rating: review.rating,
      comment: review.comment.isEmpty ? null : review.comment,
      tags: review.tags,
      photoKeys: const [],
    );

    log(
      'Submitting treatment review: '
      'appointmentId=${review.appointmentId}, '
      'rating=${review.rating}',
      name: 'TreatmentReviewDatasource',
    );

    await _apiService.userReviewsApi
        .userReviewControllerSubmitTreatmentReview(dto);
  }
}

// ─── Mock Implementation ───────────────────────────

/// Simulates a successful review submission after
/// a short network delay.
class TreatmentReviewRemoteDatasourceMock
    implements TreatmentReviewRemoteDatasource {
  @override
  Future<void> submitReview(
    TreatmentReviewEntity review,
  ) async {
    log(
      'Mock submit treatment review: '
      'rating=${review.rating}, '
      'tags=${review.tags}, '
      'photos=${review.photoPaths.length}',
      name: 'TreatmentReviewDatasource',
    );
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
  }
}

// ─── Provider ──────────────────────────────────────

/// Uses [AppEnvironment.useMock] to switch between
/// real and mock implementations at runtime.
final treatmentReviewRemoteDatasourceProvider =
    Provider<TreatmentReviewRemoteDatasource>((ref) {
  final useMock = AppEnvironment.current.useMock;

  if (useMock) {
    return TreatmentReviewRemoteDatasourceMock();
  }

  final apiService = ref.read(apiServiceProvider);
  return TreatmentReviewRemoteDatasourceImpl(apiService);
});
