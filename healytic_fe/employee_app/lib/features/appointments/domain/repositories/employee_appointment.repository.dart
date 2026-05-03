import '../entities/employee_appointment.entity.dart';

/// Domain contract for employee appointment
/// operations.
abstract class EmployeeAppointmentRepository {
  /// Fetches appointments, optionally filtered
  /// by [status].
  Future<List<EmployeeAppointmentEntity>> getAppointments({
    EmployeeAppointmentStatus? status,
  });

  /// Fetches a single appointment by [id].
  Future<EmployeeAppointmentEntity?> getById(String id);

  /// Transitions an upcoming appointment to
  /// in-progress (employee starts service).
  Future<bool> startService(String id);

  /// Transitions an in-progress appointment to
  /// completed.
  Future<bool> completeService(String id);

  /// Cancels an upcoming appointment.
  Future<bool> cancelAppointment(String id);
}
