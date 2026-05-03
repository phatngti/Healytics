import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_schedule.entity.freezed.dart';

/// A staff member's schedule entry for the calendar grid.
@freezed
abstract class StaffScheduleEntry with _$StaffScheduleEntry {
  const factory StaffScheduleEntry({
    required String employeeId,
    required String employeeName,
    required String role,
    required DateTime startTime,
    required DateTime endTime,
    required String serviceName,
    String? patientName,
  }) = _StaffScheduleEntry;
}
