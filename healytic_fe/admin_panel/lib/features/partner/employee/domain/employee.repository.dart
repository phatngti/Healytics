import 'package:admin_panel/features/partner/employee/domain/create_employee.request.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/update_employee.request.dart';
import 'package:flutter/material.dart';

abstract class EmployeeRepository {
  /// Get paginated list of employees for table display
  Future<List<DataRow>> getEmployees(
    void Function(LocalKey, bool) setRowSelection,
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  );

  /// Get total count of employees
  Future<int> getTotalRows();

  /// Get a single employee by ID
  Future<EmployeeEntity> getEmployeeById(EmployeeId id);

  /// Create a new employee
  Future<EmployeeEntity> createEmployee(CreateEmployeeRequest request);

  /// Update an existing employee
  Future<void> updateEmployee(UpdateEmployeeRequest request);

  /// Delete an employee by ID
  Future<void> deleteEmployee(EmployeeId id);
}
