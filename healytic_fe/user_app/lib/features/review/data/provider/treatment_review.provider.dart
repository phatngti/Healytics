import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/review/'
    'data/datasources/remote/'
    'treatment_review_remote_datasource.dart';
import 'package:user_app/features/review/'
    'data/repositories/'
    'treatment_review_impl.repository.dart';
import 'package:user_app/features/review/domain/'
    'repositories/treatment_review.repository.dart';

part 'treatment_review.provider.g.dart';

/// Provides [TreatmentReviewRepository] backed by
/// the current datasource (real or mock).
@riverpod
TreatmentReviewRepository treatmentReviewRepository(
  Ref ref,
) {
  final datasource = ref.read(
    treatmentReviewRemoteDatasourceProvider,
  );
  return TreatmentReviewRepositoryImpl(datasource);
}
