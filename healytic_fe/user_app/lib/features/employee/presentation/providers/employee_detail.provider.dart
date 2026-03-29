import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/employee/data/provider/employee.provider.dart';
import 'package:user_app/features/employee/domain/entities/employee_detail.entity.dart';

part 'employee_detail.provider.g.dart';

/// Fetches a single employee detail by [id].
@riverpod
Future<EmployeeDetailEntity> employeeDetail(Ref ref, String id) async {
  final repo = ref.watch(employeeRepositoryProvider);
  return repo.getEmployeeById(id);
}
