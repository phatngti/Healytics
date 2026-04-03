import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:user_app/features/clinic_info/data/datasources/remote/clinic_info_remote_datasource.dart';
import 'package:user_app/features/clinic_info/data/repositories/clinic_info_impl.repository.dart';
import 'package:user_app/features/clinic_info/domain/repositories/clinic_info.repository.dart';

/// Provides the [ClinicInfoRepository] wired to the
/// appropriate datasource (real or mock).
final clinicInfoRepositoryProvider = Provider<ClinicInfoRepository>((ref) {
  final datasource = ref.read(clinicInfoRemoteDatasourceProvider);
  return ClinicInfoRepositoryImpl(datasource);
});
