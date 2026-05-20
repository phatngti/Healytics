import 'package:freezed_annotation/freezed_annotation.dart';

part 'upcoming_appointment.entity.freezed.dart';

/// Domain entity for an upcoming patient appointment.
///
/// Used to display the "Upcoming Appointments" table
/// on the partner dashboard.
@freezed
abstract class UpcomingAppointment with _$UpcomingAppointment {
  const factory UpcomingAppointment({
    required String id,
    required String patientName,
    required String serviceName,
    required String employeeName,
    required DateTime scheduledAt,

    /// e.g., 'confirmed', 'pending', 'cancelled'
    required String status,
  }) = _UpcomingAppointment;
}
