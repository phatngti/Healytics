import 'package:admin_panel/features/partner/employee/data/employee_impl.repository.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider that fetches a single employee's details by their ID.
///
/// This is a family provider that takes an [EmployeeId] as a parameter
/// and returns the corresponding [EmployeeEntity].
///
/// Example usage:
/// ```dart
/// final employeeAsync = ref.watch(employeeDetailsProvider(EmployeeId('123')));
/// employeeAsync.when(
///   data: (employee) => Text(employee.fullName),
///   loading: () => CircularProgressIndicator(),
///   error: (error, stack) => Text('Error: $error'),
/// );
/// ```
final employeeDetailsProvider =
    FutureProvider.family<EmployeeEntity, EmployeeId>((ref, employeeId) async {
      final repository = ref.read(employeeRepositoryProvider);
      return repository.getEmployeeById(employeeId);
    });
