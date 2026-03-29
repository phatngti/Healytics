/// JSON keys for work history entry maps.
///
/// Usage:
/// ```dart
/// {
///   WorkHistoryKey.facility: 'City General Hospital',
///   WorkHistoryKey.position: 'Resident Dermatologist',
///   WorkHistoryKey.period: '2018–2021',
///   WorkHistoryKey.isCurrent: false,
/// }
/// ```
abstract final class WorkHistoryKey {
  static const facility = 'facility';
  static const position = 'position';
  static const period = 'period';
  static const isCurrent = 'isCurrent';
}
