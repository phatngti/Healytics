/// Enum representing the employment status of an employee.
///
/// Used to track whether an employee is currently active,
/// inactive, or on leave.
///
/// Named [EmployeeStatusType] to avoid conflict with the
/// OpenAPI-generated [EmployeeStatus] class.
enum EmployeeStatusType {
  /// Currently working and available.
  active,

  /// Not currently employed or available.
  inactive,

  /// Temporarily away from work.
  onLeave;

  /// Returns the user-friendly display name.
  String get displayName => switch (this) {
    EmployeeStatusType.active => 'Active',
    EmployeeStatusType.inactive => 'Inactive',
    EmployeeStatusType.onLeave => 'On Leave',
  };

  /// Returns the API value for backend communication.
  String get apiValue => switch (this) {
    EmployeeStatusType.active => 'ACTIVE',
    EmployeeStatusType.inactive => 'INACTIVE',
    EmployeeStatusType.onLeave => 'ON_LEAVE',
  };

  /// Returns the [EmployeeStatusType] for the given API [value].
  ///
  /// Returns `null` if no matching status is found.
  static EmployeeStatusType? fromApiValue(String? value) {
    if (value == null) return null;
    return switch (value.toUpperCase()) {
      'ACTIVE' => EmployeeStatusType.active,
      'INACTIVE' => EmployeeStatusType.inactive,
      'ON_LEAVE' => EmployeeStatusType.onLeave,
      _ => null,
    };
  }
}
