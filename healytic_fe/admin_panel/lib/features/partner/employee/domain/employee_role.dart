/// Enum representing the role type for an employee
enum EmployeeRole {
  therapist,
  doctor;

  String get displayName {
    switch (this) {
      case EmployeeRole.therapist:
        return 'Therapist';
      case EmployeeRole.doctor:
        return 'Doctor';
    }
  }

  String get apiValue {
    switch (this) {
      case EmployeeRole.therapist:
        return 'THERAPIST';
      case EmployeeRole.doctor:
        return 'DOCTOR';
    }
  }
}
