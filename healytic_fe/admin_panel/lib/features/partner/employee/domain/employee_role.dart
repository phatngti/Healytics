/// Enum representing the role type for an employee.
///
/// Each role has specific permissions and responsibilities
/// within the organization.
///
/// Named [EmployeeRoleType] to avoid conflict with the
/// OpenAPI-generated [EmployeeRole] class.
enum EmployeeRoleType {
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
    EmployeeRoleType.therapist => 'Therapist',
    EmployeeRoleType.doctor => 'Doctor',
    EmployeeRoleType.receptionist => 'Receptionist',
    EmployeeRoleType.manager => 'Manager',
  };

  /// Returns the API value used for backend communication.
  String get apiValue => switch (this) {
    EmployeeRoleType.therapist => 'THERAPIST',
    EmployeeRoleType.doctor => 'DOCTOR',
    EmployeeRoleType.receptionist => 'RECEPTIONIST',
    EmployeeRoleType.manager => 'MANAGER',
  };

  /// Returns the [EmployeeRoleType] for the given API [value].
  ///
  /// Returns `null` if no matching role is found.
  static EmployeeRoleType? fromApiValue(String? value) {
    if (value == null) return null;
    return switch (value.toUpperCase()) {
      'THERAPIST' => EmployeeRoleType.therapist,
      'DOCTOR' => EmployeeRoleType.doctor,
      'RECEPTIONIST' => EmployeeRoleType.receptionist,
      'MANAGER' => EmployeeRoleType.manager,
      _ => null,
    };
  }
}
