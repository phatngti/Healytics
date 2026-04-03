import 'package:user_app/features/clinic_info/data/datasources/remote/clinic_info_remote_datasource.dart';
import 'package:user_app/features/clinic_info/domain/entities/clinic_info.entity.dart';
import 'package:user_app/features/clinic_info/domain/entities/clinic_product.entity.dart';
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
  Future<ClinicProductsData> getClinicProducts(String clinicId) =>
      _datasource.getClinicProducts(clinicId);
}
