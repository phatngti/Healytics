import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../datasources/remote/employee_appointment_remote_datasource.dart';
import '../../domain/entities/employee_appointment.entity.dart';
import '../../domain/repositories/employee_appointment.repository.dart';

part 'employee_appointment_impl.repository.g.dart';

class EmployeeAppointmentRepositoryImpl
    implements EmployeeAppointmentRepository {
  final EmployeeAppointmentRemoteDatasource _ds;

  EmployeeAppointmentRepositoryImpl({
    required EmployeeAppointmentRemoteDatasource ds,
  }) : _ds = ds;

  @override
  Future<List<EmployeeAppointmentEntity>> getAppointments({
    EmployeeAppointmentStatus? status,
  }) => _ds.getAppointments(status: status);

  @override
  Future<EmployeeAppointmentEntity?> getById(String id) => _ds.getById(id);

  @override
  Future<bool> startService(String id) => _ds.startService(id);

  @override
  Future<bool> completeService(String id) => _ds.completeService(id);

  @override
  Future<bool> cancelAppointment(
    String id, {
    String? reason,
  }) =>
      _ds.cancelAppointment(id, reason: reason);
}

@Riverpod(keepAlive: true)
EmployeeAppointmentRepository employeeAppointmentRepository(Ref ref) {
  final ds = ref.watch(employeeAppointmentRemoteDatasourceProvider);
  return EmployeeAppointmentRepositoryImpl(ds: ds);
}
