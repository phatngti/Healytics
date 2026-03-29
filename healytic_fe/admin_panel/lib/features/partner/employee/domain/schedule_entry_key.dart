/// JSON keys for the `WorkScheduleEntryDto` map
/// shape sent to the backend.
///
/// Usage:
/// ```dart
/// {
///   ScheduleEntryKey.day: day.displayName,
///   ScheduleEntryKey.start: '09:00',
///   ScheduleEntryKey.end: '17:00',
///   ScheduleEntryKey.isWorking: true,
/// }
/// ```
abstract final class ScheduleEntryKey {
  static const day = 'day';
  static const start = 'start';
  static const end = 'end';
  static const isWorking = 'isWorking';
}
