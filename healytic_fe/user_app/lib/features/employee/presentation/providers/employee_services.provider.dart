import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/booking/data/datasources/'
    'remote/booking_remote_datasource.dart';
import 'package:user_app/features/booking/domain/entities/'
    'booking.entity.dart';

part 'employee_services.provider.g.dart';

/// Fetches services offered by employee [id].
///
/// Reuses [BookingRemoteDatasource.getServicesBySpecialist]
/// which calls the `/user/employees/{id}/services` API.
@riverpod
Future<List<BookingService>> employeeServices(
  Ref ref,
  String id,
) async {
  final datasource = ref.watch(
    bookingRemoteDatasourceProvider,
  );
  return datasource.getServicesBySpecialist(id);
}
