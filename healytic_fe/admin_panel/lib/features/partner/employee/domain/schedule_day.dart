/// Enum representing days of the week for employee
/// work schedules.
///
/// Provides both the form-field key suffix and the
/// display name sent to the backend.
enum ScheduleDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  /// Form-field key suffix (lowercase).
  String get formKey => name;

  /// Display name sent to the backend API.
  String get displayName => switch (this) {
    ScheduleDay.monday => 'Monday',
    ScheduleDay.tuesday => 'Tuesday',
    ScheduleDay.wednesday => 'Wednesday',
    ScheduleDay.thursday => 'Thursday',
    ScheduleDay.friday => 'Friday',
    ScheduleDay.saturday => 'Saturday',
    ScheduleDay.sunday => 'Sunday',
  };

  /// The full schedule form field key,
  /// e.g. `schedule_monday`.
  String get scheduleFieldKey => 'schedule_$formKey';
}
