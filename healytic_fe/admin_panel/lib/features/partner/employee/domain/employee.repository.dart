import 'package:admin_panel/features/partner/employee/domain/create_employee.request.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_assigned_service.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_status.dart';
import 'package:admin_panel/features/partner/employee/domain/update_employee.request.dart';

/// Repository interface for employee data operations.
///
/// This abstract class defines the contract for all employee-related
/// data operations. Implementations should handle data fetching from
/// remote APIs, local databases, or mock sources.
abstract class EmployeeRepository {
  /// Retrieves a paginated list of employees for table display.
  ///
  /// - [startingAt]: The index to start fetching from (0-based).
  /// - [count]: The number of employees to fetch.
  /// - [sortedBy]: Optional field name to sort by.
  /// - [sortedAsc]: Optional sort direction (true for ascending).
  ///
  /// Returns a list of [EmployeeEntity] objects.
  Future<List<EmployeeEntity>> getEmployees(
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  );

  /// Retrieves all employees for client-side filtering/sorting.
  Future<List<EmployeeEntity>> getAllEmployees({
    String? sortedBy,
    bool? sortedAsc,
  });

  /// Returns the total count of employees in the system.
  Future<int> getTotalRows();

  /// Retrieves a single employee by their unique identifier.
  ///
  /// Throws an exception if the employee is not found.
  Future<EmployeeEntity> getEmployeeById(EmployeeId id);

  /// Creates a new doctor employee.
  ///
  /// Returns the created [EmployeeEntity] with the assigned ID.
  Future<EmployeeEntity> createDoctor(CreateDoctorRequest request);

  /// Creates a new spa therapist employee.
  ///
  /// Returns the created [EmployeeEntity] with the assigned ID.
  Future<EmployeeEntity> createSpaTherapist(CreateSpaTherapistRequest request);

  /// Creates a new massage therapist employee.
  ///
  /// Returns the created [EmployeeEntity] with the assigned ID.
  Future<EmployeeEntity> createMassageTherapist(
    CreateMassageTherapistRequest request,
  );

  /// Updates an existing employee's information.
  ///
  /// Throws an exception if the employee is not found.
  Future<void> updateEmployee(UpdateEmployeeRequest request);

  /// Updates only the employee status.
  Future<void> updateEmployeeStatus(EmployeeId id, EmployeeStatusType status);

  /// Deletes an employee by their unique identifier.
  ///
  /// Throws an exception if the employee is not found.
  Future<void> deleteEmployee(EmployeeId id);

  /// Retrieves a list of employees as entities for selection widgets.
  ///
  /// - [startingAt]: The index to start fetching from.
  /// - [count]: The number of employees to fetch.
  Future<List<EmployeeEntity>> getEmployeesList({
    required int startingAt,
    required int count,
  });

  /// Retrieves employees filtered by role.
  ///
  /// - [role]: The role to filter by (e.g., 'DOCTOR', 'THERAPIST').
  /// - [limit]: Optional maximum number of results to return.
  Future<List<EmployeeEntity>> getEmployeesByRole({
    required String role,
    int? limit,
  });

  /// Retrieves services assigned to an employee.
  Future<List<EmployeeAssignedServiceEntity>> getEmployeeAssignedServices(
    EmployeeId id,
  );

  /// Retrieves available spa skills as key-value pairs.
  ///
  /// Keys are skill identifiers, values are display names.
  Future<Map<String, String>> getSpaSkills();

  /// Retrieves available device proficiency options as key-value pairs.
  ///
  /// Keys are device identifiers, values are display names.
  Future<Map<String, String>> getDeviceProficiency();

  /// Retrieves available massage skills as key-value pairs.
  ///
  /// Keys are skill identifiers, values are display names.
  Future<Map<String, String>> getMassageSkills();

  /// Creates a new massage skill for the partner.
  ///
  /// Returns updated skill map including the new entry.
  Future<Map<String, String>> createMassageSkill(String name);

  /// Creates a new spa skill for the partner.
  ///
  /// Returns updated skill map including the new entry.
  Future<Map<String, String>> createSpaSkill(String name);
}
