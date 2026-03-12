import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/orders/data/provider/service_manual.provider.dart';
import 'package:user_app/features/orders/domain/entities/service_manual.entity.dart';

part 'service_manual.provider.g.dart';

/// Fetches the service manual for a given
/// [appointmentId].
@riverpod
Future<ServiceManualEntity?> serviceManual(
  Ref ref,
  String appointmentId,
) async {
  final repo = ref.read(serviceManualRepositoryProvider);
  return repo.getManualByAppointmentId(appointmentId);
}
