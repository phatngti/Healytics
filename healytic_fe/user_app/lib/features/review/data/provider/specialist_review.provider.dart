import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/review/'
    'data/datasources/remote/'
    'specialist_review_remote_datasource.dart';
import 'package:user_app/features/review/'
    'data/repositories/'
    'specialist_review_impl.repository.dart';
import 'package:user_app/features/review/domain/'
    'repositories/specialist_review.repository.dart';

part 'specialist_review.provider.g.dart';

/// Provides [SpecialistReviewRepository] backed by
/// the current datasource (real or mock).
@riverpod
SpecialistReviewRepository specialistReviewDataRepository(
  Ref ref,
) {
  final datasource = ref.read(
    specialistReviewRemoteDatasourceProvider,
  );
  return SpecialistReviewRepositoryImpl(datasource);
}
