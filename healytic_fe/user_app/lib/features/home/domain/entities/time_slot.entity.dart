// Domain entities for employee time slots.
//
// Pure Dart — no Flutter or framework imports.

/// A single bookable time slot.
class TimeSlotEntity {
  /// Human-readable label (e.g. "09:00 AM").
  final String label;

  /// Slot start time in HH:mm (24h) format.
  final String time;

  /// Whether the slot is already occupied.
  final bool isBusy;

  const TimeSlotEntity({
    required this.label,
    required this.time,
    required this.isBusy,
  });
}

/// One day's schedule containing its time slots.
class DayScheduleEntity {
  /// Date in YYYY-MM-DD format.
  final String date;

  /// Day of the week (e.g. "Monday").
  final String dayOfWeek;

  /// Whether the employee works on this day.
  final bool isWorkingDay;

  /// Available time slots (empty when not
  /// a working day).
  final List<TimeSlotEntity> slots;

  const DayScheduleEntity({
    required this.date,
    required this.dayOfWeek,
    required this.isWorkingDay,
    this.slots = const [],
  });
}

/// Full time-slot response for an employee.
class EmployeeTimeSlotsEntity {
  /// Employee identifier.
  final String employeeId;

  /// Employee display name.
  final String employeeName;

  /// Duration per slot in minutes.
  final int slotDurationMinutes;

  /// Day-by-day schedule with time slots.
  final List<DayScheduleEntity> schedule;

  /// Start of the returned schedule range
  /// (YYYY-MM-DD).
  final String rangeStart;

  /// End of the returned schedule range
  /// (YYYY-MM-DD).
  final String rangeEnd;

  const EmployeeTimeSlotsEntity({
    required this.employeeId,
    required this.employeeName,
    required this.slotDurationMinutes,
    this.schedule = const [],
    required this.rangeStart,
    required this.rangeEnd,
  });
}
