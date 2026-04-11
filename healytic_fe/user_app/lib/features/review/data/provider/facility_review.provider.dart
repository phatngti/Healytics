import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/review/'
    'data/datasources/remote/'
    'facility_review_remote_datasource.dart';
import 'package:user_app/features/review/'
    'data/repositories/'
    'facility_review_impl.repository.dart';
import 'package:user_app/features/review/domain/'
    'repositories/facility_review.repository.dart';

part 'facility_review.provider.g.dart';

/// Provides [FacilityReviewRepository] backed by
/// the current datasource (real or mock).
@riverpod
FacilityReviewRepository facilityReviewRepository(
  Ref ref,
) {
  final datasource = ref.read(
    facilityReviewRemoteDatasourceProvider,
  );
  return FacilityReviewRepositoryImpl(datasource);
}
