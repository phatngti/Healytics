import 'package:admin_panel/features/partner/employee/data/employee_impl.repository.dart';
import 'package:admin_panel/features/partner/employee/domain/create_employee.request.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/update_employee.request.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employee.provider.freezed.dart';
part 'employee.provider.g.dart';

/// State for employee management operations.
@freezed
abstract class EmployeeState with _$EmployeeState {
  /// Creates an empty employee state.
  const factory EmployeeState() = _EmployeeState;
}

/// Notifier for managing employee operations.
///
/// Provides methods for CRUD operations on employees including:
/// - Fetching paginated employee lists
/// - Getting employee details by ID
/// - Creating, updating, and deleting employees
/// - Filtering employees by role
@riverpod
class EmployeeNotifier extends _$EmployeeNotifier {
  @override
  FutureOr<EmployeeState> build() async {
    return const EmployeeState();
  }

  /// Returns the total count of employees.
  Future<int> getTotalRows() async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.getTotalRows();
  }

  /// Retrieves a paginated list of employees.
  ///
  /// - [startingAt]: Index to start fetching from.
  /// - [count]: Number of employees to fetch.
  /// - [search]: Optional search/sort field.
  /// - [sortAscending]: Optional sort direction.
  Future<List<EmployeeEntity>> getEmployees({
    required int startingAt,
    required int count,
    String? search,
    bool? sortAscending,
  }) async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.getEmployees(startingAt, count, search, sortAscending);
  }

  /// Deletes an employee by their ID.
  Future<void> deleteEmployee(EmployeeId id) async {
    final repo = ref.read(employeeRepositoryProvider);
    await repo.deleteEmployee(id);
  }

  /// Updates an existing employee's information.
  Future<void> updateEmployee(UpdateEmployeeRequest request) async {
    final repo = ref.read(employeeRepositoryProvider);
    await repo.updateEmployee(request);
  }

  /// Retrieves a single employee by their ID.
  Future<EmployeeEntity> getEmployeeById(EmployeeId id) async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.getEmployeeById(id);
  }

  /// Creates a new doctor employee.
  Future<EmployeeEntity> createDoctor(CreateDoctorRequest request) async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.createDoctor(request);
  }

  /// Creates a new spa therapist employee.
  Future<EmployeeEntity> createSpaTherapist(
    CreateSpaTherapistRequest request,
  ) async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.createSpaTherapist(request);
  }

  /// Creates a new massage therapist employee.
  Future<EmployeeEntity> createMassageTherapist(
    CreateMassageTherapistRequest request,
  ) async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.createMassageTherapist(request);
  }

  /// Retrieves employees filtered by role.
  ///
  /// - [role]: The role to filter by (e.g., 'DOCTOR', 'THERAPIST').
  Future<List<EmployeeEntity>> getEmployeesByRole(String role) async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.getEmployeesByRole(role: role);
  }

  /// Retrieves available spa skills options.
  Future<Map<String, String>> getSpaSkills() async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.getSpaSkills();
  }

  /// Retrieves available device proficiency options.
  Future<Map<String, String>> getDeviceProficiency() async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.getDeviceProficiency();
  }
}
