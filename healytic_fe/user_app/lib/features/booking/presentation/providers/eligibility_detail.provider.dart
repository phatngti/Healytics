import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/'
    'remote/booking_remote_datasource.dart';
import '../../domain/entities/'
    'eligibility_detail.entity.dart';

part 'eligibility_detail.provider.g.dart';

/// Fetches the eligibility detail for the
/// given [eligibilityId].
///
/// The [eligibilityId] is the surrogate PK from
/// the `product_employee_eligibility` table,
/// carried by [BookingSpecialist.eligibilityId].
@riverpod
Future<EligibilityDetailEntity> eligibilityDetail(
  Ref ref,
  String eligibilityId,
) async {
  final datasource = ref.watch(
    bookingRemoteDatasourceProvider,
  );
  return datasource.getEligibilityDetail(
    eligibilityId,
  );
}
