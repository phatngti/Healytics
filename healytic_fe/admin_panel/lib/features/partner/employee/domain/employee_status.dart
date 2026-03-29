/// Enum representing the employment status of an employee.
///
/// Used to track whether an employee is currently active,
/// inactive, or on leave.
enum EmployeeStatus {
  /// Currently working and available.
  active,

  /// Not currently employed or available.
  inactive,

  /// Temporarily away from work.
  onLeave;

  /// Returns the user-friendly display name.
  String get displayName => switch (this) {
    EmployeeStatus.active => 'Active',
    EmployeeStatus.inactive => 'Inactive',
    EmployeeStatus.onLeave => 'On Leave',
  };

  /// Returns the API value for backend communication.
  String get apiValue => switch (this) {
    EmployeeStatus.active => 'ACTIVE',
    EmployeeStatus.inactive => 'INACTIVE',
    EmployeeStatus.onLeave => 'ON_LEAVE',
  };

  /// Returns the [EmployeeStatus] for the given API [value].
  ///
  /// Returns `null` if no matching status is found.
  static EmployeeStatus? fromApiValue(String? value) {
    if (value == null) return null;
    return switch (value.toUpperCase()) {
      'ACTIVE' => EmployeeStatus.active,
      'INACTIVE' => EmployeeStatus.inactive,
      'ON_LEAVE' => EmployeeStatus.onLeave,
      _ => null,
    };
  }
}
