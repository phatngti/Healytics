import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/employee/data/provider/employee.provider.dart';
import 'package:user_app/features/employee/domain/entities/employee_detail.entity.dart';

part 'employee_list.provider.g.dart';

/// Fetches all employees, optionally filtered
/// by [role] (e.g. "DOCTOR", "THERAPIST").
@riverpod
Future<List<EmployeeDetailEntity>> employeeList(
  Ref ref, {
  String? role,
}) async {
  final repo = ref.watch(employeeRepositoryProvider);
  return repo.getEmployees(role: role);
}
