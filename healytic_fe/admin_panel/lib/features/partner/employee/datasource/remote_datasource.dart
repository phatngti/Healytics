import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/partner/employee/domain/create_employee.request.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/update_employee.request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_datasource.g.dart';

abstract class EmployeeRemoteDataSource {
  Future<List<EmployeeEntity>> getEmployees(
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  );

  Future<int> getTotalRows();

  Future<EmployeeEntity> getEmployeeById(EmployeeId id);

  Future<EmployeeEntity> createEmployee(CreateEmployeeRequest request);

  Future<void> updateEmployee(UpdateEmployeeRequest request);

  Future<void> deleteEmployee(EmployeeId id);
}

class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  final ApiService apiService;

  EmployeeRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<EmployeeEntity>> getEmployees(
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  ) {
    // TODO: Implement actual API call
    // return apiService.employeeApi.employeeControllerGetEmployees(
    //   startingAt,
    //   count,
    //   sortedBy,
    //   sortedAsc,
    // );

    final employees = List.generate(
      20,
      (index) => EmployeeEntity(
        id: EmployeeId(index + 1),
        fullName: 'Employee ${index + 1}',
        displayName: 'Emp ${index + 1}',
        avatar: 'https://i.pravatar.cc/150?img=${index + 1}',
        role: index % 3 == 0 ? 'Admin' : (index % 3 == 1 ? 'Manager' : 'Staff'),
        position: index % 4 == 0
            ? 'Doctor'
            : (index % 4 == 1
                  ? 'Nurse'
                  : (index % 4 == 2 ? 'Receptionist' : 'Technician')),
        rating: 3.5 + (index % 3) * 0.5,
        reviewCount: 10 + index * 5,
        status: index % 2 == 0 ? 'Active' : 'Inactive',
        branch: 'Branch ${(index % 5) + 1}',
        email: 'employee${index + 1}@example.com',
        phone: '+84 ${900000000 + index}',
        address: '${100 + index} Main Street',
        city: index % 3 == 0
            ? 'Ho Chi Minh'
            : (index % 3 == 1 ? 'Ha Noi' : 'Da Nang'),
        state: index % 3 == 0
            ? 'District 1'
            : (index % 3 == 1 ? 'Hoan Kiem' : 'Hai Chau'),
        country: 'Vietnam',
      ),
    );

    return Future.delayed(
      const Duration(milliseconds: 500),
      () => employees.sublist(startingAt, startingAt + count),
    );
  }

  @override
  Future<int> getTotalRows() {
    return Future.delayed(const Duration(seconds: 2), () => 20);
  }

  @override
  Future<EmployeeEntity> getEmployeeById(EmployeeId id) {
    return Future.delayed(
      const Duration(seconds: 1),
      () => EmployeeEntity(
        id: id,
        fullName: 'Employee ${id.value}',
        displayName: 'Emp ${id.value}',
        avatar: 'https://i.pravatar.cc/150?img=${id.value}',
        role: id.value % 3 == 0
            ? 'Admin'
            : (id.value % 3 == 1 ? 'Manager' : 'Staff'),
        position: id.value % 4 == 0
            ? 'Doctor'
            : (id.value % 4 == 1
                  ? 'Nurse'
                  : (id.value % 4 == 2 ? 'Receptionist' : 'Technician')),
        rating: 3.5 + (id.value % 3) * 0.5,
        reviewCount: 10 + id.value * 5,
        status: id.value % 2 == 0 ? 'Active' : 'Inactive',
        branch: 'Branch ${(id.value % 5) + 1}',
        email: 'employee${id.value}@example.com',
        phone: '+84 ${900000000 + id.value}',
        address: '${100 + id.value} Main Street',
        city: id.value % 3 == 0
            ? 'Ho Chi Minh'
            : (id.value % 3 == 1 ? 'Ha Noi' : 'Da Nang'),
        state: id.value % 3 == 0
            ? 'District 1'
            : (id.value % 3 == 1 ? 'Hoan Kiem' : 'Hai Chau'),
        country: 'Vietnam',
      ),
    );
  }

  @override
  Future<EmployeeEntity> createEmployee(CreateEmployeeRequest request) {
    // TODO: Implement actual API call
    final id = EmployeeId(DateTime.now().millisecondsSinceEpoch);
    return Future.delayed(
      const Duration(seconds: 1),
      () => EmployeeEntity(
        id: id,
        fullName: request.name,
        displayName: request.name,
        avatar: 'https://i.pravatar.cc/150?img=${id.value % 70}',
        role: 'Staff',
        position: 'Staff',
        rating: 0.0,
        reviewCount: 0,
        status: 'Active',
        branch: 'Branch 1',
        email: request.email,
        phone: '',
        address: '',
        city: '',
        state: '',
        country: 'Vietnam',
      ),
    );
  }

  @override
  Future<void> updateEmployee(UpdateEmployeeRequest request) {
    // TODO: Implement actual API call
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> deleteEmployee(EmployeeId id) {
    // TODO: Implement actual API call
    return Future.delayed(const Duration(seconds: 1));
  }
}

@riverpod
EmployeeRemoteDataSource employeeRemoteDataSource(Ref ref) {
  final apiService = ref.read(apiServiceProvider);
  return EmployeeRemoteDataSourceImpl(apiService: apiService);
}
