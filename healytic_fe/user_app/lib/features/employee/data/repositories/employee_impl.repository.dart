import 'package:user_app/features/employee/data/datasources/remote/employee_remote_datasource.dart';
import 'package:user_app/features/employee/domain/entities/employee_detail.entity.dart';
import 'package:user_app/features/employee/domain/repositories/employee.repository.dart';
import 'package:user_app/features/service_details/domain/entities/service_details.entity.dart';

/// Concrete [EmployeeRepository] backed by a remote
/// datasource.
class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDatasource _datasource;

  EmployeeRepositoryImpl(this._datasource);

  @override
  Future<List<EmployeeDetailEntity>> getEmployees({String? role}) =>
      _datasource.getEmployees(role: role);

  @override
  Future<EmployeeDetailEntity> getEmployeeById(String id) =>
      _datasource.getEmployeeById(id);

  @override
  Future<List<ReviewEntity>> getEmployeeReviews(String id) =>
      _datasource.getEmployeeReviews(id);
}
