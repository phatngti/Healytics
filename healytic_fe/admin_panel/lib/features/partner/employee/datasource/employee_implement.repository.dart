import 'package:admin_panel/features/partner/employee/datasource/remote_datasource.dart';
import 'package:admin_panel/features/partner/employee/domain/create_doctor.request.dart';
import 'package:admin_panel/features/partner/employee/domain/create_therapist.request.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.repository.dart';
import 'package:admin_panel/features/partner/employee/domain/update_employee.request.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employee_implement.repository.g.dart';

class EmployeeImplementRepository implements EmployeeRepository {
  final EmployeeRemoteDataSource remoteDataSource;

  EmployeeImplementRepository({required this.remoteDataSource});

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
  Future<EmployeeEntity> createTherapist(CreateTherapistRequest request) {
    return remoteDataSource.createTherapist(request);
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
}

@riverpod
EmployeeRepository employeeRepository(Ref ref) {
  final remoteDataSource = ref.read(employeeRemoteDataSourceProvider);
  return EmployeeImplementRepository(remoteDataSource: remoteDataSource);
}
