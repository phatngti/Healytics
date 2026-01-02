import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/partner/employee/domain/create_doctor.request.dart';
import 'package:admin_panel/features/partner/employee/domain/create_therapist.request.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/update_employee.request.dart';
import 'package:admin_openapi/api.dart';
import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
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

  Future<EmployeeEntity> createDoctor(CreateDoctorRequest request);

  Future<EmployeeEntity> createTherapist(CreateTherapistRequest request);

  Future<void> updateEmployee(UpdateEmployeeRequest request);

  Future<void> deleteEmployee(EmployeeId id);

  Future<List<EmployeeEntity>> getEmployeesByRole({
    required String role,
    int? limit,
  });
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

  @override
  Future<EmployeeEntity> createDoctor(CreateDoctorRequest request) async {
    final profile = DoctorProfileDto(
      title: request.title,
      medicalLicense: request.medicalLicense,
      experienceYears: request.experienceYears,
      consultationFee: request.consultationFee,
      specializations: request.specializations,
      education: request.education,
      certifications: request.certifications,
    );

    final dto = CreateDoctorDto(
      employeeCode: request.employeeCode,
      fullName: request.fullName,
      displayName: request.displayName,
      email: request.email,
      phone: request.phone,
      avatarUrl: request.avatarUrl,
      dob: request.dob,
      gender: _mapDoctorGender(request.gender),
      status: CreateDoctorDtoStatusEnum.ACTIVE,
      branchId: request.branchId,
      profile: profile,
    );

    final response = await _employeesApi.employeesControllerCreateDoctor(dto);
    if (response == null) {
      throw Exception('Failed to create doctor');
    }
    return _mapToEmployeeEntity(response as Map<String, dynamic>);
  }

  @override
  Future<EmployeeEntity> createTherapist(CreateTherapistRequest request) async {
    final profile = TherapistProfileDto(
      level: _mapTherapistLevel(request.level),
      type: request.type,
      strengthLevel: _mapStrengthLevel(request.strengthLevel),
      commissionRate: request.commissionRate,
      healthCheckDate: request.healthCheckDate,
      skills: request.skills,
    );

    final dto = CreateTherapistDto(
      employeeCode: request.employeeCode,
      fullName: request.fullName,
      displayName: request.displayName,
      email: request.email,
      phone: request.phone,
      avatarUrl: request.avatarUrl,
      dob: request.dob,
      gender: _mapTherapistGender(request.gender),
      status: CreateTherapistDtoStatusEnum.ACTIVE,
      branchId: request.branchId,
      profile: profile,
    );

    final response = await _employeesApi.employeesControllerCreateTherapist(
      dto,
    );
    if (response == null) {
      throw Exception('Failed to create therapist');
    }
    return _mapToEmployeeEntity(response as Map<String, dynamic>);
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
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: '', // Not available from API
      city: '', // Not available from API
      state: '', // Not available from API
      country: '', // Not available from API
      licenseUrl: json['licenseUrl']?.toString(),
      idCardUrl: json['idCardUrl']?.toString(),
      documents:
          (json['documents'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  @override
  Future<List<EmployeeEntity>> getEmployeesByRole({
    required String role,
    int? limit,
  }) async {
    // Since API doesn't support filtering by role yet, we fetch all and filter locally
    final allEmployees = await getEmployees(0, 1000, null, null);

    final filtered = allEmployees.where((e) {
      return e.role.toUpperCase() == role.toUpperCase();
    }).toList();

    if (limit != null && filtered.length > limit) {
      return filtered.sublist(0, limit);
    }

    return filtered;
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

  // Helper method to map gender for Doctor DTO
  CreateDoctorDtoGenderEnum? _mapDoctorGender(String? gender) {
    if (gender == null) return null;
    switch (gender.toUpperCase()) {
      case 'MALE':
        return CreateDoctorDtoGenderEnum.MALE;
      case 'FEMALE':
        return CreateDoctorDtoGenderEnum.FEMALE;
      case 'OTHER':
        return CreateDoctorDtoGenderEnum.OTHER;
      default:
        return null;
    }
  }

  // Helper method to map gender for Therapist DTO
  CreateTherapistDtoGenderEnum? _mapTherapistGender(String? gender) {
    if (gender == null) return null;
    switch (gender.toUpperCase()) {
      case 'MALE':
        return CreateTherapistDtoGenderEnum.MALE;
      case 'FEMALE':
        return CreateTherapistDtoGenderEnum.FEMALE;
      case 'OTHER':
        return CreateTherapistDtoGenderEnum.OTHER;
      default:
        return null;
    }
  }

  // Helper method to map therapist level
  TherapistProfileDtoLevelEnum? _mapTherapistLevel(String? level) {
    if (level == null) return null;
    switch (level.toUpperCase()) {
      case 'JUNIOR':
        return TherapistProfileDtoLevelEnum.JUNIOR;
      case 'SENIOR':
        return TherapistProfileDtoLevelEnum.SENIOR;
      case 'MASTER':
        return TherapistProfileDtoLevelEnum.MASTER;
      default:
        return null;
    }
  }

  // Helper method to map strength level
  TherapistProfileDtoStrengthLevelEnum? _mapStrengthLevel(
    String? strengthLevel,
  ) {
    if (strengthLevel == null) return null;
    switch (strengthLevel.toUpperCase()) {
      case 'SOFT':
        return TherapistProfileDtoStrengthLevelEnum.SOFT;
      case 'MEDIUM':
        return TherapistProfileDtoStrengthLevelEnum.MEDIUM;
      case 'STRONG':
        return TherapistProfileDtoStrengthLevelEnum.STRONG;
      default:
        return null;
    }
  }
}

class EmployeeRemoteDataSourceMock implements EmployeeRemoteDataSource {
  @override
  Future<List<EmployeeEntity>> getEmployees(
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(
      count,
      (index) => EmployeeEntity(
        id: EmployeeId('mock-id-${startingAt + index}'),
        fullName: 'Mock Employee ${startingAt + index}',
        displayName: 'MockEmp ${startingAt + index}',
        avatar: 'https://i.pravatar.cc/150?u=${startingAt + index}',
        role: index % 2 == 0 ? 'DOCTOR' : 'THERAPIST',
        position: index % 2 == 0 ? 'Doctor' : 'Therapist',
        rating: 4.5,
        reviewCount: 10 + index,
        status: 'ACTIVE',
        email: 'mock${startingAt + index}@example.com',
        phone: '1234567890',
        address: '123 Mock St',
        city: 'Mock City',
        state: 'Mock State',
        country: 'Mock Country',
        licenseUrl:
            'https://pub-58a545087a6b4221b1b0dab10d8d3517.r2.dev/main%20(3).pdf',
      ),
    );
  }

  @override
  Future<int> getTotalRows() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 100;
  }

  @override
  Future<EmployeeEntity> getEmployeeById(EmployeeId id) async {
    await Future.delayed(const Duration(seconds: 1));
    return EmployeeEntity(
      id: id,
      fullName: 'Mock Employee ${id.value}',
      displayName: 'MockEmp ${id.value}',
      avatar: 'https://i.pravatar.cc/150?u=${id.value}',
      role: 'DOCTOR',
      position: 'Doctor',
      rating: 4.8,
      reviewCount: 50,
      status: 'ACTIVE',
      email: 'mock${id.value}@example.com',
      phone: '1234567890',
      address: '123 Mock St',
      city: 'Mock City',
      state: 'Mock State',
      country: 'Mock Country',
      licenseUrl:
          'https://pub-58a545087a6b4221b1b0dab10d8d3517.r2.dev/main%20(3).pdf',
      idCardUrl:
          'https://pub-58a545087a6b4221b1b0dab10d8d3517.r2.dev/main%20(3).pdf',
      documents: [
        'https://pub-58a545087a6b4221b1b0dab10d8d3517.r2.dev/main%20(3).pdf',
      ],
    );
  }

  @override
  Future<EmployeeEntity> createDoctor(CreateDoctorRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    return EmployeeEntity(
      id: EmployeeId('new-doctor-id'),
      fullName: request.fullName,
      displayName: request.displayName!,
      avatar: request.avatarUrl ?? '',
      role: 'DOCTOR',
      position: 'Doctor',
      rating: 0.0,
      reviewCount: 0,
      status: 'ACTIVE',
      email: request.email,
      phone: request.phone ?? '',
      address: '',
      city: '',
      state: '',
      country: '',
    );
  }

  @override
  Future<EmployeeEntity> createTherapist(CreateTherapistRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    return EmployeeEntity(
      id: EmployeeId('new-therapist-id'),
      fullName: request.fullName,
      displayName: request.displayName!,
      avatar: request.avatarUrl ?? '',
      role: 'THERAPIST',
      position: 'Therapist',
      rating: 0.0,
      reviewCount: 0,
      status: 'ACTIVE',
      email: request.email,
      phone: request.phone ?? '',
      address: '',
      city: '',
      state: '',
      country: '',
    );
  }

  @override
  Future<void> updateEmployee(UpdateEmployeeRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('Mock update employee: ${request.id}');
  }

  @override
  Future<void> deleteEmployee(EmployeeId id) async {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('Mock delete employee: $id');
  }

  @override
  Future<List<EmployeeEntity>> getEmployeesByRole({
    required String role,
    int? limit,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    final count = limit ?? 10;
    return List.generate(
      count,
      (index) => EmployeeEntity(
        id: EmployeeId('mock-$role-$index'),
        fullName: 'Mock $role $index',
        displayName: 'Mock$role $index',
        avatar: 'https://i.pravatar.cc/150?u=$role$index',
        role: role,
        position: role,
        rating: 4.5,
        reviewCount: 10 + index,
        status: 'ACTIVE',
        email: 'mock$role$index@example.com',
        phone: '1234567890',
        address: '123 Mock St',
        city: 'Mock City',
        state: 'Mock State',
        country: 'Mock Country',
      ),
    );
  }
}

@riverpod
EmployeeRemoteDataSource employeeRemoteDataSource(Ref ref) {
  final isMock = Store.get(StoreKey.mockFlag, false);
  if (isMock) {
    return EmployeeRemoteDataSourceMock();
  }
  final apiService = ref.read(apiServiceProvider);
  return EmployeeRemoteDataSourceImpl(apiService: apiService);
}
