import 'package:admin_panel/features/partner/employee/datasource/employee_implement.repository.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider that fetches a single employee's details by their ID.
///
/// Usage:
/// ```dart
/// final employeeAsync = ref.watch(employeeDetailsProvider(EmployeeId('123')));
/// ```
final employeeDetailsProvider =
    FutureProvider.family<EmployeeEntity, EmployeeId>((ref, employeeId) async {
      final repository = ref.read(employeeRepositoryProvider);
      return repository.getEmployeeById(employeeId);
    });
