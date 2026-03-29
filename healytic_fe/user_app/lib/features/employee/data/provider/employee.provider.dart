import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/employee/data/datasources/remote/employee_remote_datasource.dart';
import 'package:user_app/features/employee/data/repositories/employee_impl.repository.dart';
import 'package:user_app/features/employee/domain/repositories/employee.repository.dart';

part 'employee.provider.g.dart';

/// Provides the [EmployeeRepository] implementation
/// wired to the active remote datasource.
@riverpod
EmployeeRepository employeeRepository(Ref ref) {
  final datasource = ref.read(employeeRemoteDatasourceProvider);
  return EmployeeRepositoryImpl(datasource);
}
