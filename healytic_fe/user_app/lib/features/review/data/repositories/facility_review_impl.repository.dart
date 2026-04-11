import 'package:user_app/features/review/'
    'data/datasources/remote/'
    'facility_review_remote_datasource.dart';
import 'package:user_app/features/review/domain/'
    'entities/facility_review.entity.dart';
import 'package:user_app/features/review/domain/'
    'repositories/facility_review.repository.dart';

/// Delegates facility review submission to the
/// configured remote data source.
class FacilityReviewRepositoryImpl
    implements FacilityReviewRepository {
  final FacilityReviewRemoteDatasource _datasource;

  FacilityReviewRepositoryImpl(this._datasource);

  @override
  Future<void> submitReview(
    FacilityReviewEntity review,
  ) =>
      _datasource.submitReview(review);
}
