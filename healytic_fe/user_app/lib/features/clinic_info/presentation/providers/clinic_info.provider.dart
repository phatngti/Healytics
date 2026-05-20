import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:user_app/features/clinic_info/data/provider/clinic_info.provider.dart';
import 'package:user_app/features/clinic_info/domain/entities/clinic_info.entity.dart';

part 'clinic_info.provider.g.dart';

/// Fetches clinic info by [clinicId].
///
/// Uses a family parameter so each clinic ID gets
/// its own cached async state.
@riverpod
Future<ClinicInfoEntity> clinicInfo(Ref ref, {required String clinicId}) async {
  final repo = ref.read(clinicInfoRepositoryProvider);
  return repo.getClinicInfo(clinicId);
}
