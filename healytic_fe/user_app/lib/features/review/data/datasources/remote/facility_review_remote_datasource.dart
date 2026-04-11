import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/review/domain/'
    'entities/facility_review.entity.dart';

// ─── Abstract Interface ────────────────────────────

/// Contract for submitting facility review data
/// to a remote source.
abstract class FacilityReviewRemoteDatasource {
  /// Sends the facility review to the backend.
  Future<void> submitReview(
    FacilityReviewEntity review,
  );
}

// ─── Real Implementation ───────────────────────────

/// Production implementation backed by the
/// [UserReviewsApi] OpenAPI client.
///
/// Note: [photoPaths] are local file paths. S3
/// upload is handled separately; [photoKeys] is
/// left empty until that flow is integrated.
///
/// TODO: Wire to backend once
/// `POST /v1/user/reviews/facility` is available.
class FacilityReviewRemoteDatasourceImpl
    implements FacilityReviewRemoteDatasource {
  final ApiService _apiService;

  FacilityReviewRemoteDatasourceImpl(this._apiService);

  @override
  Future<void> submitReview(
    FacilityReviewEntity review,
  ) async {
    // Placeholder until backend endpoint exists.
    // Once the OpenAPI spec is regenerated with the
    // facility review endpoint, replace with:
    //
    // final dto = CreateFacilityReviewDto(
    //   appointmentId: review.appointmentId,
    //   facilityId: review.facilityId,
    //   rating: review.rating,
    //   comment: review.comment.isEmpty
    //       ? null : review.comment,
    //   tags: review.tags,
    //   photoKeys: const [],
    // );
    // await _apiService.userReviewsApi
    //   .userReviewControllerSubmitFacilityReview(dto);

    log(
      'Submitting facility review: '
      'appointmentId=${review.appointmentId}, '
      'facilityId=${review.facilityId}, '
      'rating=${review.rating}',
      name: 'FacilityReviewDatasource',
    );

    throw UnimplementedError(
      'Backend facility review endpoint '
      'not yet available.',
    );
  }
}

// ─── Mock Implementation ───────────────────────────

/// Simulates a successful review submission after
/// a short network delay.
class FacilityReviewRemoteDatasourceMock
    implements FacilityReviewRemoteDatasource {
  @override
  Future<void> submitReview(
    FacilityReviewEntity review,
  ) async {
    log(
      'Mock submit facility review: '
      'rating=${review.rating}, '
      'tags=${review.tags}, '
      'photos=${review.photoPaths.length}',
      name: 'FacilityReviewDatasource',
    );
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
  }
}

// ─── Provider ──────────────────────────────────────

/// Uses [AppEnvironment.useMock] to switch between
/// real and mock implementations at runtime.
final facilityReviewRemoteDatasourceProvider =
    Provider<FacilityReviewRemoteDatasource>((ref) {
  final useMock = AppEnvironment.current.useMock;

  if (useMock) {
    return FacilityReviewRemoteDatasourceMock();
  }

  final apiService = ref.read(apiServiceProvider);
  return FacilityReviewRemoteDatasourceImpl(apiService);
});
