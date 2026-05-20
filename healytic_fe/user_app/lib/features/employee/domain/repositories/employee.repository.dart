import 'package:user_app/features/employee/domain/entities/employee_detail.entity.dart';
import 'package:user_app/features/service_details/domain/entities/service_details.entity.dart';

/// Abstract repository for the employee feature.
abstract class EmployeeRepository {
  /// Fetches all employees, optionally filtered
  /// by [role] (e.g. "DOCTOR", "THERAPIST").
  Future<List<EmployeeDetailEntity>> getEmployees({String? role});

  /// Fetches a single employee detail by [id].
  Future<EmployeeDetailEntity> getEmployeeById(String id);

  /// Fetches public reviews for a single employee.
  Future<List<ReviewEntity>> getEmployeeReviews(String id);
}
