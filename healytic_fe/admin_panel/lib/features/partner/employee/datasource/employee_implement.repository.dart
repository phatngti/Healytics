import 'package:admin_panel/features/partner/employee/datasource/remote_datasource.dart';
import 'package:admin_panel/features/partner/employee/domain/create_doctor.request.dart';
import 'package:admin_panel/features/partner/employee/domain/create_therapist.request.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.repository.dart';
import 'package:admin_panel/features/partner/employee/domain/update_employee.request.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employee_implement.repository.g.dart';

class EmployeeImplementRepository implements EmployeeRepository {
  final EmployeeRemoteDataSource remoteDataSource;

  EmployeeImplementRepository({required this.remoteDataSource});

  @override
  Future<List<DataRow>> getEmployees(
    void Function(LocalKey, bool) setRowSelection,
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  ) async {
    final employees = await remoteDataSource.getEmployees(
      startingAt,
      count,
      sortedBy,
      sortedAsc,
    );
    return employees
        .map(
          (employee) => DataRow(
            key: ValueKey<String>(employee.id.value),
            onSelectChanged: (value) {
              if (value != null) {
                setRowSelection(ValueKey<String>(employee.id.value), value);
              }
            },
            cells: [
              DataCell(
                Center(
                  child: Text(
                    employee.id.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(
                Center(
                  child: ClipOval(
                    child: employee.avatar.isNotEmpty
                        ? Image.network(
                            employee.avatar,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const CircleAvatar(
                                child: Icon(Icons.person),
                              );
                            },
                          )
                        : const CircleAvatar(child: Icon(Icons.person)),
                  ),
                ),
              ),
              DataCell(Center(child: Text(employee.fullName))),
              DataCell(Center(child: Text(employee.position))),
              DataCell(Center(child: Text(employee.rating.toStringAsFixed(1)))),
              DataCell(Center(child: Text(employee.reviewCount.toString()))),
              DataCell(Center(child: Text(employee.status))),
            ],
          ),
        )
        .toList();
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
