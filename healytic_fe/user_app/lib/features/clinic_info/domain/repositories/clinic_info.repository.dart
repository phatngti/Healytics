import '../entities/clinic_info.entity.dart';
import '../entities/clinic_product.entity.dart';

/// Contract for fetching detailed clinic information.
abstract class ClinicInfoRepository {
  /// Fetches the full clinic profile by partner/clinic
  /// [clinicId].
  Future<ClinicInfoEntity> getClinicInfo(String clinicId);

  /// Fetches all products and categories for a clinic.
  Future<ClinicProductsData> getClinicProducts(String clinicId);
}
