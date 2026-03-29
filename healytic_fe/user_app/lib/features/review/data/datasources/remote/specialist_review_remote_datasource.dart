import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/review/domain/'
    'entities/specialist_review.entity.dart';
import 'package:user_openapi/api.dart';

// ─── Abstract Interface ────────────────────────────

/// Contract for submitting specialist review data
/// to a remote source.
abstract class SpecialistReviewRemoteDatasource {
  /// Sends the specialist review to the backend.
  Future<void> submitReview(
    SpecialistReviewEntity review,
  );
}

// ─── Real Implementation ───────────────────────────

/// Production implementation backed by the
/// [UserReviewsApi] OpenAPI client.
class SpecialistReviewRemoteDatasourceImpl
    implements SpecialistReviewRemoteDatasource {
  final ApiService _apiService;

  SpecialistReviewRemoteDatasourceImpl(this._apiService);

  @override
  Future<void> submitReview(
    SpecialistReviewEntity review,
  ) async {
    final dto = CreateSpecialistReviewDto(
      appointmentId: review.appointmentId,
      specialistId: review.specialistId,
      rating: review.rating,
      comment: review.comment.isEmpty ? null : review.comment,
      tags: review.tags,
      wouldRecommend: review.wouldRecommend,
    );

    log(
      'Submitting specialist review: '
      'appointmentId=${review.appointmentId}, '
      'specialistId=${review.specialistId}, '
      'rating=${review.rating}',
      name: 'SpecialistReviewDatasource',
    );

    await _apiService.userReviewsApi
        .userReviewControllerSubmitSpecialistReview(dto);
  }
}

// ─── Mock Implementation ───────────────────────────

/// Simulates a successful review submission after
/// a short network delay.
class SpecialistReviewRemoteDatasourceMock
    implements SpecialistReviewRemoteDatasource {
  @override
  Future<void> submitReview(
    SpecialistReviewEntity review,
  ) async {
    log(
      'Mock submit specialist review: '
      'rating=${review.rating}, '
      'tags=${review.tags}, '
      'wouldRecommend=${review.wouldRecommend}',
      name: 'SpecialistReviewDatasource',
    );
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
  }
}

// ─── Provider ──────────────────────────────────────

/// Uses [AppEnvironment.useMock] to switch between
/// real and mock implementations at runtime.
final specialistReviewRemoteDatasourceProvider =
    Provider<SpecialistReviewRemoteDatasource>((ref) {
  final useMock = AppEnvironment.current.useMock;

  if (useMock) {
    return SpecialistReviewRemoteDatasourceMock();
  }

  final apiService = ref.read(apiServiceProvider);
  return SpecialistReviewRemoteDatasourceImpl(apiService);
});
