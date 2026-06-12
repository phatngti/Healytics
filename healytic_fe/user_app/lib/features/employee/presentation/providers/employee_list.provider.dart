import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/employee/data/provider/employee.provider.dart';
import 'package:user_app/features/employee/domain/entities/employee_detail.entity.dart';
import 'package:user_app/features/home/presentation/providers/list_filter.provider.dart';

part 'employee_list.provider.g.dart';

/// Fetches all employees, optionally filtered
/// by [role] (e.g. "DOCTOR", "THERAPIST").
@riverpod
Future<List<EmployeeDetailEntity>> employeeList(Ref ref, {String? role}) async {
  final repo = ref.watch(employeeRepositoryProvider);
  final filter = ref.watch(specialistListFilterProvider);
  return repo.getEmployees(role: role, filter: filter);
}
