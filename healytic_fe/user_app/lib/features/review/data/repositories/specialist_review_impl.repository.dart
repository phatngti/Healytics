import 'package:user_app/features/review/'
    'data/datasources/remote/'
    'specialist_review_remote_datasource.dart';
import 'package:user_app/features/review/domain/'
    'entities/specialist_review.entity.dart';
import 'package:user_app/features/review/domain/'
    'repositories/specialist_review.repository.dart';

/// Delegates specialist review submission to the
/// configured remote data source.
class SpecialistReviewRepositoryImpl
    implements SpecialistReviewRepository {
  final SpecialistReviewRemoteDatasource _datasource;

  SpecialistReviewRepositoryImpl(this._datasource);

  @override
  Future<void> submitReview(
    SpecialistReviewEntity review,
  ) =>
      _datasource.submitReview(review);
}
