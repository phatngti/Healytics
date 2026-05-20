import 'package:user_app/features/clinic_info/data/datasources/remote/clinic_info_remote_datasource.dart';
import 'package:user_app/features/clinic_info/domain/entities/clinic_info.entity.dart';
import 'package:user_app/features/clinic_info/domain/entities/clinic_product.entity.dart';
import 'package:user_app/features/clinic_info/domain/entities/clinic_review.entity.dart';
import 'package:user_app/features/clinic_info/domain/repositories/clinic_info.repository.dart';

/// Concrete [ClinicInfoRepository] backed by a remote
/// datasource.
class ClinicInfoRepositoryImpl implements ClinicInfoRepository {
  const ClinicInfoRepositoryImpl(this._datasource);

  final ClinicInfoRemoteDatasource _datasource;

  @override
  Future<ClinicInfoEntity> getClinicInfo(String clinicId) {
    return _datasource.getClinicInfo(clinicId);
  }

  @override
  Future<ClinicProductsData> getClinicProducts(
    String clinicId, {
    String? categoryId,
    ClinicProductSort sort = ClinicProductSort.popular,
    String? search,
    ClinicProductFilters filters = const ClinicProductFilters(),
    int page = 1,
    int limit = 20,
  }) => _datasource.getClinicProducts(
    clinicId,
    categoryId: categoryId,
    sort: sort,
    search: search,
    filters: filters,
    page: page,
    limit: limit,
  );

  @override
  Future<ClinicReviewsData> getClinicReviews(
    String clinicId, {
    int page = 1,
    int limit = 10,
    int? starCount,
    bool? hasMedia,
  }) => _datasource.getClinicReviews(
    clinicId,
    page: page,
    limit: limit,
    starCount: starCount,
    hasMedia: hasMedia,
  );

  @override
  Future<ClinicInfoEntity> setFollowing(String clinicId, bool isFollowing) {
    return _datasource.setFollowing(clinicId, isFollowing);
  }
}
