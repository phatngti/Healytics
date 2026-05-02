import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/employee_appointment_impl.repository.dart';
import '../../domain/entities/employee_appointment.entity.dart';

part 'appointment_list.provider.g.dart';

final _log = Logger('AppointmentListNotifier');

@riverpod
class AppointmentList extends _$AppointmentList {
  @override
  Future<List<EmployeeAppointmentEntity>> build({
    EmployeeAppointmentStatus? status,
  }) async {
    _log.fine('Loading appointments: status=$status');
    return ref
        .read(employeeAppointmentRepositoryProvider)
        .getAppointments(status: status);
  }

  /// Reloads from the data source.
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
