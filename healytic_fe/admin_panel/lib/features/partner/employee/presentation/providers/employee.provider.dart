import 'package:admin_panel/features/partner/employee/datasource/employee_implement.repository.dart';
import 'package:admin_panel/features/partner/employee/domain/create_employee.request.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/update_employee.request.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employee.provider.freezed.dart';
part 'employee.provider.g.dart';

@freezed
abstract class EmployeeState with _$EmployeeState {
  const factory EmployeeState() = _EmployeeState;
}

@riverpod
class EmployeeNotifier extends _$EmployeeNotifier {
  @override
  FutureOr<EmployeeState> build() async {
    return EmployeeState();
  }

  Future<int> getTotalRows() async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.getTotalRows();
  }

  Future<List<EmployeeEntity>> getEmployees({
    required int startingAt,
    required int count,
    String? search,
    bool? sortAscending,
  }) async {
    final repo = ref.read(employeeRepositoryProvider);
    final result = await repo.getEmployees(
      startingAt,
      count,
      search,
      sortAscending,
    );

    return result;
  }

  Future<void> deleteEmployee(EmployeeId id) async {
    final repo = ref.read(employeeRepositoryProvider);
    await repo.deleteEmployee(id);
  }

  Future<void> updateEmployee(UpdateEmployeeRequest request) async {
    final repo = ref.read(employeeRepositoryProvider);
    await repo.updateEmployee(request);
  }

  Future<EmployeeEntity> getEmployeeById(EmployeeId id) async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.getEmployeeById(id);
  }

  Future<EmployeeEntity> createDoctor(CreateDoctorRequest request) async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.createDoctor(request);
  }

  Future<EmployeeEntity> createSpaTherapist(
    CreateSpaTherapistRequest request,
  ) async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.createSpaTherapist(request);
  }

  Future<EmployeeEntity> createMassageTherapist(
    CreateMassageTherapistRequest request,
  ) async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.createMassageTherapist(request);
  }

  Future<List<EmployeeEntity>> getEmployeesByRole(String role) async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.getEmployeesByRole(role: role);
  }

  Future<Map<String, String>> getSpaSkills() async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.getSpaSkills();
  }

  Future<Map<String, String>> getDeviceProficiency() async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.getDeviceProficiency();
  }
}
