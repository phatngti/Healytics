/// Enum representing the role type for an employee.
///
/// Each role has specific permissions and responsibilities
/// within the organization.
enum EmployeeRole {
  /// Therapist role for spa and massage services.
  therapist,

  /// Doctor role for medical consultations and treatments.
  doctor,

  /// Receptionist role for front desk and customer service.
  receptionist,

  /// Manager role for administrative and supervisory tasks.
  manager;

  /// Returns the user-friendly display name for the role.
  String get displayName => switch (this) {
    EmployeeRole.therapist => 'Therapist',
    EmployeeRole.doctor => 'Doctor',
    EmployeeRole.receptionist => 'Receptionist',
    EmployeeRole.manager => 'Manager',
  };

  /// Returns the API value used for backend communication.
  String get apiValue => switch (this) {
    EmployeeRole.therapist => 'THERAPIST',
    EmployeeRole.doctor => 'DOCTOR',
    EmployeeRole.receptionist => 'RECEPTIONIST',
    EmployeeRole.manager => 'MANAGER',
  };

  /// Returns the [EmployeeRole] for the given API [value].
  ///
  /// Returns `null` if no matching role is found.
  static EmployeeRole? fromApiValue(String? value) {
    if (value == null) return null;
    return switch (value.toUpperCase()) {
      'THERAPIST' => EmployeeRole.therapist,
      'DOCTOR' => EmployeeRole.doctor,
      'RECEPTIONIST' => EmployeeRole.receptionist,
      'MANAGER' => EmployeeRole.manager,
      _ => null,
    };
  }
}
