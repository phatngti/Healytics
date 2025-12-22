import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/partner/employee/domain/create_employee.request.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/update_employee.request.dart';
import 'package:admin_openapi/api.dart';
import 'package:flutter/foundation.dart';
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

  EmployeesApi get _employeesApi => apiService.employeesApi;

  @override
  Future<List<EmployeeEntity>> getEmployees(
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  ) async {
    final response = await _employeesApi.employeesControllerFindAll();
    if (response == null) {
      return [];
    }

    // Convert API response to EmployeeEntity list
    final employees = response.map((item) {
      final json = item as Map<String, dynamic>;
      return _mapToEmployeeEntity(json);
    }).toList();
    debugPrint('Employees: $employees');

    // Apply pagination
    final endIndex = (startingAt + count) > employees.length
        ? employees.length
        : startingAt + count;
    if (startingAt >= employees.length) {
      return [];
    }

    return employees.sublist(startingAt, endIndex);
  }

  @override
  Future<int> getTotalRows() async {
    final response = await _employeesApi.employeesControllerFindAll();
    debugPrint('Total rows: ${response?.length}');
    return response?.length ?? 0;
  }

  @override
  Future<EmployeeEntity> getEmployeeById(EmployeeId id) async {
    final response = await _employeesApi.employeesControllerFindOne(
      id.value.toString(),
    );
    if (response == null) {
      throw Exception('Employee not found');
    }
    return _mapToEmployeeEntity(response as Map<String, dynamic>);
  }

  @override
  Future<EmployeeEntity> createEmployee(CreateEmployeeRequest request) async {
    final dto = CreateEmployeeDto(
      employeeCode: request.employeeId,
      fullName: '${request.firstName} ${request.lastName}',
      displayName: '${request.firstName} ${request.lastName}',
      email: request.email,
      phone: request.phone,
      avatarUrl: request.avatar,
      dob: request.dateOfBirth,
      gender: _mapGender(request.gender),
      role: _mapRole(request.jobTitle),
      status: _mapStatus(request.status),
      branchId: request.branch,
    );

    final response = await _employeesApi.employeesControllerCreate(dto);
    if (response == null) {
      throw Exception('Failed to create employee');
    }
    return _mapToEmployeeEntity(response as Map<String, dynamic>);
  }

  @override
  Future<void> updateEmployee(UpdateEmployeeRequest request) async {
    final dto = UpdateEmployeeDto(
      fullName: request.fullName,
      displayName: request.displayName,
      email: request.email,
      phone: request.phone,
      avatarUrl: request.avatar,
      role: _mapUpdateRole(request.role),
      status: _mapUpdateStatus(request.status),
      branchId: request.branch,
    );

    await _employeesApi.employeesControllerUpdate(
      request.id.value.toString(),
      dto,
    );
  }

  @override
  Future<void> deleteEmployee(EmployeeId id) async {
    await _employeesApi.employeesControllerRemove(id.value.toString());
  }

  // Helper method to map API response to EmployeeEntity
  EmployeeEntity _mapToEmployeeEntity(Map<String, dynamic> json) {
    return EmployeeEntity(
      id: EmployeeId(json['id']?.toString() ?? ''),
      fullName: json['fullName']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
      avatar: json['avatarUrl']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      position: json['role']?.toString() ?? '', // Using role as position
      rating: double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? 'ACTIVE',
      branch: json['branchId']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: '', // Not available from API
      city: '', // Not available from API
      state: '', // Not available from API
      country: '', // Not available from API
    );
  }

  // Helper method to map gender string to CreateEmployeeDtoGenderEnum
  CreateEmployeeDtoGenderEnum? _mapGender(String gender) {
    switch (gender.toUpperCase()) {
      case 'MALE':
        return CreateEmployeeDtoGenderEnum.MALE;
      case 'FEMALE':
        return CreateEmployeeDtoGenderEnum.FEMALE;
      case 'OTHER':
        return CreateEmployeeDtoGenderEnum.OTHER;
      default:
        return null;
    }
  }

  // Helper method to map role/job title to CreateEmployeeDtoRoleEnum
  CreateEmployeeDtoRoleEnum _mapRole(String role) {
    switch (role.toUpperCase()) {
      case 'DOCTOR':
        return CreateEmployeeDtoRoleEnum.DOCTOR;
      case 'THERAPIST':
        return CreateEmployeeDtoRoleEnum.THERAPIST;
      case 'RECEPTIONIST':
        return CreateEmployeeDtoRoleEnum.RECEPTIONIST;
      case 'MANAGER':
        return CreateEmployeeDtoRoleEnum.MANAGER;
      default:
        return CreateEmployeeDtoRoleEnum.RECEPTIONIST; // Default fallback
    }
  }

  // Helper method to map status to CreateEmployeeDtoStatusEnum
  CreateEmployeeDtoStatusEnum? _mapStatus(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return CreateEmployeeDtoStatusEnum.ACTIVE;
      case 'INACTIVE':
        return CreateEmployeeDtoStatusEnum.INACTIVE;
      case 'ON_LEAVE':
        return CreateEmployeeDtoStatusEnum.ON_LEAVE;
      default:
        return CreateEmployeeDtoStatusEnum.ACTIVE;
    }
  }

  // Helper method to map role to UpdateEmployeeDtoRoleEnum
  UpdateEmployeeDtoRoleEnum? _mapUpdateRole(String role) {
    switch (role.toUpperCase()) {
      case 'DOCTOR':
        return UpdateEmployeeDtoRoleEnum.DOCTOR;
      case 'THERAPIST':
        return UpdateEmployeeDtoRoleEnum.THERAPIST;
      case 'RECEPTIONIST':
        return UpdateEmployeeDtoRoleEnum.RECEPTIONIST;
      case 'MANAGER':
        return UpdateEmployeeDtoRoleEnum.MANAGER;
      default:
        return null;
    }
  }

  // Helper method to map status to UpdateEmployeeDtoStatusEnum
  UpdateEmployeeDtoStatusEnum? _mapUpdateStatus(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return UpdateEmployeeDtoStatusEnum.ACTIVE;
      case 'INACTIVE':
        return UpdateEmployeeDtoStatusEnum.INACTIVE;
      case 'ON_LEAVE':
        return UpdateEmployeeDtoStatusEnum.ON_LEAVE;
      default:
        return null;
    }
  }
}

@riverpod
EmployeeRemoteDataSource employeeRemoteDataSource(Ref ref) {
  final apiService = ref.read(apiServiceProvider);
  return EmployeeRemoteDataSourceImpl(apiService: apiService);
}
