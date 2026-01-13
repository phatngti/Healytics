import 'package:admin_panel/features/partner/employee/domain/create_employee.request.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/update_employee.request.dart';

abstract class EmployeeRepository {
  /// Get paginated list of employees for table display
  Future<List<EmployeeEntity>> getEmployees(
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  );

  /// Get total count of employees
  Future<int> getTotalRows();

  /// Get a single employee by ID
  Future<EmployeeEntity> getEmployeeById(EmployeeId id);

  /// Create a new doctor employee
  Future<EmployeeEntity> createDoctor(CreateDoctorRequest request);

  /// Create a new spa therapist employee
  Future<EmployeeEntity> createSpaTherapist(CreateSpaTherapistRequest request);

  /// Create a new massage therapist employee
  Future<EmployeeEntity> createMassageTherapist(
    CreateMassageTherapistRequest request,
  );

  /// Update an existing employee
  Future<void> updateEmployee(UpdateEmployeeRequest request);

  /// Delete an employee by ID
  Future<void> deleteEmployee(EmployeeId id);

  /// Get list of employees as entities (for selection widgets)
  Future<List<EmployeeEntity>> getEmployeesList({
    required int startingAt,
    required int count,
  });

  /// Get employees filtered by role (e.g., DOCTOR, THERAPIST)
  Future<List<EmployeeEntity>> getEmployeesByRole({
    required String role,
    int? limit,
  });

  /// Get spa skills
  Future<Map<String, String>> getSpaSkills();

  /// Get device proficiency
  Future<Map<String, String>> getDeviceProficiency();
}
