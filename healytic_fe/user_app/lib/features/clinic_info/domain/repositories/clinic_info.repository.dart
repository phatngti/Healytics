import '../entities/clinic_info.entity.dart';
import '../entities/clinic_product.entity.dart';
import '../entities/clinic_review.entity.dart';

/// Contract for fetching detailed clinic information.
abstract class ClinicInfoRepository {
  /// Fetches the full clinic profile by partner/clinic
  /// [clinicId].
  Future<ClinicInfoEntity> getClinicInfo(String clinicId);

  /// Fetches products for a clinic with server-side
  /// filtering, sorting, and pagination.
  Future<ClinicProductsData> getClinicProducts(
    String clinicId, {
    String? categoryId,
    ClinicProductSort sort = ClinicProductSort.popular,
    String? search,
    ClinicProductFilters filters = const ClinicProductFilters(),
    int page = 1,
    int limit = 20,
  });

  /// Fetches paginated reviews for a clinic with
  /// server-side filters.
  ///
  /// [page] is 1-indexed. [limit] controls page size.
  /// [starCount] filters to a specific star rating.
  /// [hasMedia] filters to reviews with photos.
  Future<ClinicReviewsData> getClinicReviews(
    String clinicId, {
    int page = 1,
    int limit = 10,
    int? starCount,
    bool? hasMedia,
  });

  Future<ClinicInfoEntity> setFollowing(String clinicId, bool isFollowing);
}
