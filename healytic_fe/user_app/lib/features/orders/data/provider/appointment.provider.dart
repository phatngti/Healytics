import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/orders/data/datasources/remote/appointment_remote_datasource.dart';
import 'package:user_app/features/orders/data/repositories/appointment_impl.repository.dart';
import 'package:user_app/features/orders/domain/repositories/appointment.repository.dart';

part 'appointment.provider.g.dart';

/// Provides the [AppointmentRepository] implementation
/// wired to the active remote datasource.
@riverpod
AppointmentRepository appointmentRepository(Ref ref) {
  final datasource = ref.read(appointmentRemoteDatasourceProvider);
  return AppointmentRepositoryImpl(datasource);
}
