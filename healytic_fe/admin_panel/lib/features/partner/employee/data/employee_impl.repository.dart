import 'package:admin_panel/features/partner/employee/data/employee_remote.datasource.dart';
import 'package:admin_panel/features/partner/employee/domain/create_employee.request.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.repository.dart';
import 'package:admin_panel/features/partner/employee/domain/update_employee.request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employee_impl.repository.g.dart';

/// Implementation of [EmployeeRepository] that delegates to remote data source.
///
/// This class acts as the repository layer, coordinating data operations
/// between the domain layer and the data source layer.
class EmployeeRepositoryImpl implements EmployeeRepository {
  /// Creates an instance with the required [remoteDataSource].
  EmployeeRepositoryImpl({required this.remoteDataSource});

  /// The remote data source for employee operations.
  final EmployeeRemoteDataSource remoteDataSource;

  @override
  Future<List<EmployeeEntity>> getEmployees(
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  ) async {
    return remoteDataSource.getEmployees(
      startingAt,
      count,
      sortedBy,
      sortedAsc,
    );
  }

  @override
  Future<int> getTotalRows() {
    return remoteDataSource.getTotalRows();
  }

  @override
  Future<EmployeeEntity> getEmployeeById(EmployeeId id) {
    return remoteDataSource.getEmployeeById(id);
  }

  @override
  Future<EmployeeEntity> createDoctor(CreateDoctorRequest request) {
    return remoteDataSource.createDoctor(request);
  }

  @override
  Future<EmployeeEntity> createSpaTherapist(
    CreateSpaTherapistRequest request,
  ) {
    return remoteDataSource.createSpaTherapist(request);
  }

  @override
  Future<EmployeeEntity> createMassageTherapist(
    CreateMassageTherapistRequest request,
  ) {
    return remoteDataSource.createMassageTherapist(request);
  }

  @override
  Future<void> updateEmployee(UpdateEmployeeRequest request) {
    return remoteDataSource.updateEmployee(request);
  }

  @override
  Future<void> deleteEmployee(EmployeeId id) {
    return remoteDataSource.deleteEmployee(id);
  }

  @override
  Future<List<EmployeeEntity>> getEmployeesList({
    required int startingAt,
    required int count,
  }) {
    return remoteDataSource.getEmployees(startingAt, count, null, null);
  }

  @override
  Future<List<EmployeeEntity>> getEmployeesByRole({
    required String role,
    int? limit,
  }) {
    return remoteDataSource.getEmployeesByRole(role: role, limit: limit);
  }

  @override
  Future<Map<String, String>> getSpaSkills() {
    return remoteDataSource.getSpaSkills();
  }

  @override
  Future<Map<String, String>> getDeviceProficiency() {
    return remoteDataSource.getDeviceProficiency();
  }
}

/// Provider for [EmployeeRepository].
///
/// Injects the remote data source and creates the repository implementation.
@riverpod
EmployeeRepository employeeRepository(Ref ref) {
  final remoteDataSource = ref.read(employeeRemoteDataSourceProvider);
  return EmployeeRepositoryImpl(remoteDataSource: remoteDataSource);
}
