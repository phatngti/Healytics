import 'package:user_app/features/employee/domain/entities/employee_detail.entity.dart';

/// Abstract repository for the employee feature.
abstract class EmployeeRepository {
  /// Fetches all employees, optionally filtered
  /// by [role] (e.g. "DOCTOR", "THERAPIST").
  Future<List<EmployeeDetailEntity>> getEmployees({
    String? role,
  });

  /// Fetches a single employee detail by [id].
  Future<EmployeeDetailEntity> getEmployeeById(String id);
}
