import 'package:user_app/features/review/'
    'data/datasources/remote/'
    'treatment_review_remote_datasource.dart';
import 'package:user_app/features/review/domain/'
    'entities/treatment_review.entity.dart';
import 'package:user_app/features/review/domain/'
    'repositories/treatment_review.repository.dart';

/// Delegates treatment review submission to the
/// configured remote data source.
class TreatmentReviewRepositoryImpl
    implements TreatmentReviewRepository {
  final TreatmentReviewRemoteDatasource _datasource;

  TreatmentReviewRepositoryImpl(this._datasource);

  @override
  Future<void> submitReview(
    TreatmentReviewEntity review,
  ) =>
      _datasource.submitReview(review);
}
