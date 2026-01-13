/// Enum representing the role type for an employee
enum EmployeeRole {
  therapist,
  doctor,
  receptionist,
  manager;

  String get displayName {
    switch (this) {
      case EmployeeRole.therapist:
        return 'Therapist';
      case EmployeeRole.doctor:
        return 'Doctor';
      case EmployeeRole.receptionist:
        return 'Receptionist';
      case EmployeeRole.manager:
        return 'Manager';
    }
  }

  String get apiValue {
    switch (this) {
      case EmployeeRole.therapist:
        return 'THERAPIST';
      case EmployeeRole.doctor:
        return 'DOCTOR';
      case EmployeeRole.receptionist:
        return 'RECEPTIONIST';
      case EmployeeRole.manager:
        return 'MANAGER';
    }
  }
}
