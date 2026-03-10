import 'dart:developer' as developer;

import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/partner/employee/data/employee_mock_data.dart';
import 'package:admin_panel/features/partner/employee/domain/create_employee.request.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/update_employee.request.dart';
import 'package:admin_openapi/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employee_remote.datasource.g.dart';

// ============================================================================
// 1. ABSTRACT INTERFACE
// ============================================================================

/// Abstract interface for employee remote data operations.
///
/// Defines the contract for fetching, creating, updating, and deleting
/// employee data from remote sources.
abstract class EmployeeRemoteDataSource {
  /// Retrieves a paginated list of employees.
  ///
  /// - [startingAt]: The index to start fetching from.
  /// - [count]: The number of employees to fetch.
  /// - [sortedBy]: Optional field name to sort by.
  /// - [sortedAsc]: Optional sort direction (true for ascending).
  Future<List<EmployeeEntity>> getEmployees(
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  );

  /// Returns the total count of employees.
  Future<int> getTotalRows();

  /// Retrieves a single employee by their unique identifier.
  Future<EmployeeEntity> getEmployeeById(EmployeeId id);

  /// Creates a new doctor employee.
  Future<EmployeeEntity> createDoctor(CreateDoctorRequest request);

  /// Creates a new spa therapist employee.
  Future<EmployeeEntity> createSpaTherapist(CreateSpaTherapistRequest request);

  /// Creates a new massage therapist employee.
  Future<EmployeeEntity> createMassageTherapist(
    CreateMassageTherapistRequest request,
  );

  /// Updates an existing employee's information.
  Future<void> updateEmployee(UpdateEmployeeRequest request);

  /// Deletes an employee by their unique identifier.
  Future<void> deleteEmployee(EmployeeId id);

  /// Retrieves employees filtered by role.
  ///
  /// - [role]: The role to filter by (e.g., 'DOCTOR', 'THERAPIST').
  /// - [limit]: Optional maximum number of results to return.
  Future<List<EmployeeEntity>> getEmployeesByRole({
    required String role,
    int? limit,
  });

  /// Retrieves available spa skills options.
  Future<Map<String, String>> getSpaSkills();

  /// Retrieves available device proficiency options.
  Future<Map<String, String>> getDeviceProficiency();
}

// ============================================================================
// 2. IMPLEMENTATION (Real API)
// ============================================================================

/// Real implementation of [EmployeeRemoteDataSource] using API service.
class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  /// Creates an instance with the required [ApiService].
  EmployeeRemoteDataSourceImpl({required this.apiService});

  /// The API service for making network requests.
  final ApiService apiService;

  PartnerEmployeesApi get _employeesApi => apiService.employeesApi;

  @override
  Future<List<EmployeeEntity>> getEmployees(
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  ) async {
    final response = await _employeesApi.partnerEmployeesControllerFindAll();
    if (response == null) {
      return [];
    }

    developer.log(
      'Fetched ${response.length} employees',
      name: 'EmployeeRemoteDataSource',
    );

    final employees = response.map(_mapToEmployeeEntity).toList();

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
    final response = await _employeesApi.partnerEmployeesControllerFindAll();
    final count = response?.length ?? 0;

    developer.log(
      'Total employee rows: $count',
      name: 'EmployeeRemoteDataSource',
    );

    return count;
  }

  @override
  Future<EmployeeEntity> getEmployeeById(EmployeeId id) async {
    final response = await _employeesApi.partnerEmployeesControllerFindOne(
      id.value.toString(),
    );
    if (response == null) {
      throw EmployeeNotFoundException(id);
    }
    return _mapToEmployeeEntity(response);
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

    await _employeesApi.partnerEmployeesControllerUpdate(
      request.id.value.toString(),
      dto,
    );

    developer.log(
      'Updated employee: ${request.id}',
      name: 'EmployeeRemoteDataSource',
    );
  }

  @override
  Future<void> deleteEmployee(EmployeeId id) async {
    await _employeesApi.partnerEmployeesControllerRemove(id.value.toString());

    developer.log('Deleted employee: $id', name: 'EmployeeRemoteDataSource');
  }

  @override
  Future<EmployeeEntity> createDoctor(CreateDoctorRequest request) async {
    final dto = CreateDoctorDto(
      firstName: request.firstName,
      lastName: request.lastName,
      email: request.email,
      employeeId: request.employeeId,
      phone: request.phone,
      avatar: request.avatar,
      dateOfBirth: request.dateOfBirth,
      gender: _mapDoctorGender(request.gender),
      status: CreateDoctorDtoStatusEnum.ACTIVE,
      jobTitle: request.jobTitle,
      medicalTitles: request.medicalTitles,
      medicalLicenses: request.medicalLicenses,
      experienceYears: request.experienceYears,
      consultationFee: request.consultationFee,
      specializations: request.specializations,
      education: request.education,
      certifications: request.certifications,
    );

    final response = await _employeesApi.partnerEmployeesControllerCreateDoctor(
      dto,
    );
    if (response == null) {
      throw EmployeeCreationException('Failed to create doctor');
    }

    developer.log(
      'Created doctor: '
      '${request.firstName} ${request.lastName}',
      name: 'EmployeeRemoteDataSource',
    );

    return _mapToEmployeeEntity(response);
  }

  @override
  Future<EmployeeEntity> createSpaTherapist(
    CreateSpaTherapistRequest request,
  ) async {
    final dto = CreateSpaTherapistDto(
      firstName: request.firstName,
      lastName: request.lastName,
      email: request.email,
      employeeId: request.employeeId,
      phone: request.phone,
      avatar: request.avatar,
      dateOfBirth: request.dateOfBirth,
      gender: _mapSpaGender(request.gender),
      status: CreateSpaTherapistDtoStatusEnum.ACTIVE,
      jobTitle: request.jobTitle,
      therapistLevel: _mapSpaLevel(request.therapistLevel),
      commissionRate: request.commissionRate,
      healthCheckDate: request.healthCheckDate,
      skills: request.skills,
      deviceProficiency: request.deviceProficiency,
    );

    final response = await _employeesApi
        .partnerEmployeesControllerCreateSpaTherapist(dto);
    if (response == null) {
      throw EmployeeCreationException('Failed to create spa therapist');
    }

    developer.log(
      'Created spa therapist: '
      '${request.firstName} ${request.lastName}',
      name: 'EmployeeRemoteDataSource',
    );

    return _mapToEmployeeEntity(response);
  }

  @override
  Future<EmployeeEntity> createMassageTherapist(
    CreateMassageTherapistRequest request,
  ) async {
    final dto = CreateMassageTherapistDto(
      firstName: request.firstName,
      lastName: request.lastName,
      email: request.email,
      employeeId: request.employeeId,
      phone: request.phone,
      avatar: request.avatar,
      dateOfBirth: request.dateOfBirth,
      gender: _mapMassageGender(request.gender),
      status: CreateMassageTherapistDtoStatusEnum.ACTIVE,
      jobTitle: request.jobTitle,
      therapistLevel: _mapMassageLevel(request.therapistLevel),
      strengthLevel: _mapMassageStrength(request.strengthLevel),
      commissionRate: request.commissionRate,
      healthCheckDate: request.healthCheckDate,
      skills: request.skills,
    );

    final response = await _employeesApi
        .partnerEmployeesControllerCreateMassageTherapist(dto);
    if (response == null) {
      throw EmployeeCreationException('Failed to create massage therapist');
    }

    developer.log(
      'Created massage therapist: '
      '${request.firstName} ${request.lastName}',
      name: 'EmployeeRemoteDataSource',
    );

    return _mapToEmployeeEntity(response);
  }

  @override
  Future<List<EmployeeEntity>> getEmployeesByRole({
    required String role,
    int? limit,
  }) async {
    final response = await _employeesApi.partnerEmployeesControllerFindAll(
      role: role,
    );
    if (response == null) return [];

    final employees = response.map(_mapToEmployeeEntity).toList();

    if (limit != null && employees.length > limit) {
      return employees.sublist(0, limit);
    }

    return employees;
  }

  @override
  Future<Map<String, String>> getDeviceProficiency() async {
    // TODO(api): Implement when endpoint is available
    return {};
  }

  @override
  Future<Map<String, String>> getSpaSkills() async {
    // TODO(api): Implement when endpoint is available
    return {};
  }

  // ==========================================================
  // Private Helper Methods
  // ==========================================================

  /// Maps an [EmployeeResponseDto] to [EmployeeEntity].
  EmployeeEntity _mapToEmployeeEntity(EmployeeResponseDto dto) {
    final role = dto.role.value.toUpperCase();
    final id = EmployeeId(dto.id);
    final common = _mapCommonFields(dto);

    if (role == 'DOCTOR' && dto.doctorProfile != null) {
      final profile = dto.doctorProfile!;
      return DoctorEntity(
        id: id,
        fullName: common.fullName,
        displayName: common.displayName,
        avatar: common.avatar,
        role: role,
        position: common.position,
        rating: common.rating,
        reviewCount: common.reviewCount,
        status: common.status,
        email: common.email,
        phone: common.phone,
        address: '',
        city: '',
        state: '',
        country: '',
        description: dto.description?.toString(),
        documents: const [],
        dateOfBirth: common.dateOfBirth,
        gender: common.gender,
        employmentType: common.employmentType,
        startDate: common.startDate,
        jobTitle: profile.title ?? '',

        medicalLicenses: profile.medicalLicenses,
        medicalTitles: profile.medicalTitles,
        experienceYears: profile.experienceYears?.toInt(),
        consultationFee: profile.consultationFee?.toDouble(),
        specializations: profile.specializations,
        education: profile.education,
        certifications: profile.certifications,
      );
    } else if (role == 'THERAPIST' && dto.therapistProfile != null) {
      final profile = dto.therapistProfile!;
      final type = profile.type?.toUpperCase() ?? '';

      if (type == 'SPA') {
        return SpaTherapistEntity(
          id: id,
          fullName: common.fullName,
          displayName: common.displayName,
          avatar: common.avatar,
          role: role,
          position: common.position,
          rating: common.rating,
          reviewCount: common.reviewCount,
          status: common.status,
          email: common.email,
          phone: common.phone,
          address: '',
          city: '',
          state: '',
          country: '',
          description: dto.description?.toString(),
          documents: const [],
          dateOfBirth: common.dateOfBirth,
          gender: common.gender,
          employmentType: common.employmentType,
          startDate: common.startDate,
          jobTitle: 'Spa Therapist',
          therapistLevel: profile.level,
          commissionRate: profile.commissionRate?.toDouble() ?? 0.0,
          healthCheckDate: profile.healthCheckDate?.toIso8601String(),
          skills: profile.skills,
          deviceProficiency: profile.deviceProficiency,
        );
      } else if (type == 'MASSAGE') {
        return MassageTherapistEntity(
          id: id,
          fullName: common.fullName,
          displayName: common.displayName,
          avatar: common.avatar,
          role: role,
          position: common.position,
          rating: common.rating,
          reviewCount: common.reviewCount,
          status: common.status,
          email: common.email,
          phone: common.phone,
          address: '',
          city: '',
          state: '',
          country: '',
          description: dto.description?.toString(),
          documents: const [],
          dateOfBirth: common.dateOfBirth,
          gender: common.gender,
          employmentType: common.employmentType,
          startDate: common.startDate,
          jobTitle: 'Massage Therapist',
          therapistLevel: profile.level,
          commissionRate: profile.commissionRate?.toDouble() ?? 0.0,
          healthCheckDate: profile.healthCheckDate?.toIso8601String(),
          skills: profile.skills,
          strengthLevel: profile.strengthLevel,
        );
      }
    }

    return BasicEmployeeEntity(
      id: id,
      fullName: common.fullName,
      displayName: common.displayName,
      avatar: common.avatar,
      role: role,
      position: common.position,
      rating: common.rating,
      reviewCount: common.reviewCount,
      status: common.status,
      email: common.email,
      phone: common.phone,
      address: '',
      city: '',
      state: '',
      country: '',
      description: dto.description?.toString(),
      documents: const [],
      dateOfBirth: common.dateOfBirth,
      gender: common.gender,
      employmentType: common.employmentType,
      startDate: common.startDate,
    );
  }

  /// Extracts common fields from [EmployeeResponseDto].
  _CommonFields _mapCommonFields(EmployeeResponseDto dto) {
    return _CommonFields(
      fullName: dto.fullName,
      displayName: dto.displayName?.toString() ?? '',
      avatar: dto.avatarUrl?.toString() ?? '',
      position: dto.role.value,
      rating: dto.rating.toDouble(),
      reviewCount: dto.reviewCount.toInt(),
      status: dto.status.value,
      email: dto.email,
      phone: dto.phone?.toString() ?? '',
      dateOfBirth: dto.dob?.toString(),
      gender: dto.gender?.value,
      employmentType: dto.employmentType?.toString(),
      startDate: dto.startDate?.toString(),
    );
  }

  UpdateEmployeeDtoRoleEnum? _mapUpdateRole(String role) {
    return switch (role.toUpperCase()) {
      'DOCTOR' => UpdateEmployeeDtoRoleEnum.DOCTOR,
      'THERAPIST' => UpdateEmployeeDtoRoleEnum.THERAPIST,
      'RECEPTIONIST' => UpdateEmployeeDtoRoleEnum.RECEPTIONIST,
      'MANAGER' => UpdateEmployeeDtoRoleEnum.MANAGER,
      _ => null,
    };
  }

  UpdateEmployeeDtoStatusEnum? _mapUpdateStatus(String status) {
    return switch (status.toUpperCase()) {
      'ACTIVE' => UpdateEmployeeDtoStatusEnum.ACTIVE,
      'INACTIVE' => UpdateEmployeeDtoStatusEnum.INACTIVE,
      'ON_LEAVE' => UpdateEmployeeDtoStatusEnum.ON_LEAVE,
      _ => null,
    };
  }

  CreateDoctorDtoGenderEnum? _mapDoctorGender(String? gender) {
    if (gender == null) return null;
    return switch (gender.toUpperCase()) {
      'MALE' => CreateDoctorDtoGenderEnum.MALE,
      'FEMALE' => CreateDoctorDtoGenderEnum.FEMALE,
      'OTHER' => CreateDoctorDtoGenderEnum.OTHER,
      _ => null,
    };
  }

  CreateSpaTherapistDtoGenderEnum? _mapSpaGender(String? gender) {
    if (gender == null) return null;
    return switch (gender.toUpperCase()) {
      'MALE' => CreateSpaTherapistDtoGenderEnum.MALE,
      'FEMALE' => CreateSpaTherapistDtoGenderEnum.FEMALE,
      'OTHER' => CreateSpaTherapistDtoGenderEnum.OTHER,
      _ => null,
    };
  }

  CreateMassageTherapistDtoGenderEnum? _mapMassageGender(String? gender) {
    if (gender == null) return null;
    return switch (gender.toUpperCase()) {
      'MALE' => CreateMassageTherapistDtoGenderEnum.MALE,
      'FEMALE' => CreateMassageTherapistDtoGenderEnum.FEMALE,
      'OTHER' => CreateMassageTherapistDtoGenderEnum.OTHER,
      _ => null,
    };
  }

  CreateSpaTherapistDtoTherapistLevelEnum? _mapSpaLevel(String? level) {
    if (level == null) return null;
    return switch (level.toUpperCase()) {
      'JUNIOR' => CreateSpaTherapistDtoTherapistLevelEnum.JUNIOR,
      'SENIOR' => CreateSpaTherapistDtoTherapistLevelEnum.SENIOR,
      'MASTER' => CreateSpaTherapistDtoTherapistLevelEnum.MASTER,
      _ => null,
    };
  }

  CreateMassageTherapistDtoTherapistLevelEnum? _mapMassageLevel(String? level) {
    if (level == null) return null;
    return switch (level.toUpperCase()) {
      'JUNIOR' => CreateMassageTherapistDtoTherapistLevelEnum.JUNIOR,
      'SENIOR' => CreateMassageTherapistDtoTherapistLevelEnum.SENIOR,
      'MASTER' => CreateMassageTherapistDtoTherapistLevelEnum.MASTER,
      _ => null,
    };
  }

  CreateMassageTherapistDtoStrengthLevelEnum? _mapMassageStrength(
    String? level,
  ) {
    if (level == null) return null;
    return switch (level.toUpperCase()) {
      'SOFT' => CreateMassageTherapistDtoStrengthLevelEnum.SOFT,
      'MEDIUM' => CreateMassageTherapistDtoStrengthLevelEnum.MEDIUM,
      'STRONG' => CreateMassageTherapistDtoStrengthLevelEnum.STRONG,
      _ => null,
    };
  }
}

/// Helper class for common employee fields.
class _CommonFields {
  const _CommonFields({
    required this.fullName,
    required this.displayName,
    required this.avatar,
    required this.position,
    required this.rating,
    required this.reviewCount,
    required this.status,
    required this.email,
    required this.phone,
    this.dateOfBirth,
    this.gender,
    this.employmentType,
    this.startDate,
  });

  final String fullName;
  final String displayName;
  final String avatar;
  final String position;
  final double rating;
  final int reviewCount;
  final String status;
  final String email;
  final String phone;
  final String? dateOfBirth;
  final String? gender;
  final String? employmentType;
  final String? startDate;
}

// ============================================================================
// 3. MOCK IMPLEMENTATION
// ============================================================================

/// Mock implementation of [EmployeeRemoteDataSource] for UI testing.
///
/// Provides rich static data with simulated network delays.
class EmployeeRemoteDataSourceMock implements EmployeeRemoteDataSource {
  @override
  Future<List<EmployeeEntity>> getEmployees(
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  ) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return List.generate(count, (index) {
      final i = startingAt + index;
      final type = i % 3;
      final id = EmployeeId('mock-id-$i');

      if (type == 0) {
        return createMockDoctor(id);
      } else if (type == 1) {
        return createMockSpaTherapist(id);
      } else {
        return createMockMassageTherapist(id);
      }
    });
  }

  @override
  Future<int> getTotalRows() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return 100;
  }

  @override
  Future<EmployeeEntity> getEmployeeById(EmployeeId id) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final idVal = id.value.toLowerCase();

    if (idVal.contains('doctor')) {
      return createMockDoctor(id);
    } else if (idVal.contains('spa')) {
      return createMockSpaTherapist(id);
    } else if (idVal.contains('massage')) {
      return createMockMassageTherapist(id);
    }

    final hashInfo = idVal.codeUnits.fold(0, (p, c) => p + c);
    final type = hashInfo % 3;

    try {
      final parts = idVal.split('-');
      if (parts.isNotEmpty) {
        final lastNum = int.tryParse(parts.last);
        if (lastNum != null) {
          final type = lastNum % 3;
          if (type == 0) return createMockDoctor(id);
          if (type == 1) return createMockSpaTherapist(id);
          if (type == 2) return createMockMassageTherapist(id);
        }
      }
    } on FormatException {
      // Ignore parsing errors, use fallback
    }

    if (type == 0) return createMockDoctor(id);
    if (type == 1) return createMockSpaTherapist(id);
    return createMockMassageTherapist(id);
  }

  @override
  Future<EmployeeEntity> createDoctor(CreateDoctorRequest request) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    developer.log(
      'Mock: Created doctor ${request.firstName} ${request.lastName}',
      name: 'EmployeeRemoteDataSourceMock',
    );

    return DoctorEntity(
      id: EmployeeId('new-doctor-id-${DateTime.now().millisecondsSinceEpoch}'),
      fullName: '${request.firstName} ${request.lastName}',
      displayName: '${request.firstName} ${request.lastName}',
      avatar: request.avatar ?? '',
      role: 'DOCTOR',
      position: 'Doctor',
      rating: 0.0,
      reviewCount: 0,
      status: 'ACTIVE',
      email: request.email,
      phone: request.phone,
      address: '',
      city: '',
      state: '',
      country: '',
      jobTitle: request.jobTitle,
      medicalTitles: request.medicalTitles,
      medicalLicenses: request.medicalLicenses,
      experienceYears: request.experienceYears,
      consultationFee: request.consultationFee,
      specializations: request.specializations,
      education: request.education,
      certifications: request.certifications,
      workSchedule: [],
      dateOfBirth: request.dateOfBirth,
      gender: request.gender,
      employmentType: 'Full-Time',
      startDate: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<EmployeeEntity> createSpaTherapist(
    CreateSpaTherapistRequest request,
  ) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    developer.log(
      'Mock: Created spa therapist ${request.firstName} ${request.lastName}',
      name: 'EmployeeRemoteDataSourceMock',
    );

    return SpaTherapistEntity(
      id: EmployeeId(
        'new-spa-therapist-id-${DateTime.now().millisecondsSinceEpoch}',
      ),
      fullName: '${request.firstName} ${request.lastName}',
      displayName: '${request.firstName} ${request.lastName}',
      avatar: request.avatar ?? '',
      role: 'THERAPIST',
      position: 'Spa Therapist',
      rating: 0.0,
      reviewCount: 0,
      status: 'ACTIVE',
      email: request.email,
      phone: request.phone,
      address: '',
      city: '',
      state: '',
      country: '',
      jobTitle: request.jobTitle,
      therapistLevel: request.therapistLevel,
      commissionRate: request.commissionRate,
      healthCheckDate: request.healthCheckDate,
      skills: request.skills,
      deviceProficiency: request.deviceProficiency,
      workSchedule: [],
      dateOfBirth: request.dateOfBirth,
      gender: request.gender,
      employmentType: 'Part-Time',
      startDate: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<EmployeeEntity> createMassageTherapist(
    CreateMassageTherapistRequest request,
  ) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    developer.log(
      'Mock: Created massage therapist ${request.firstName} ${request.lastName}',
      name: 'EmployeeRemoteDataSourceMock',
    );

    return MassageTherapistEntity(
      id: EmployeeId(
        'new-massage-therapist-id-${DateTime.now().millisecondsSinceEpoch}',
      ),
      fullName: '${request.firstName} ${request.lastName}',
      displayName: '${request.firstName} ${request.lastName}',
      avatar: request.avatar ?? '',
      role: 'THERAPIST',
      position: 'Massage Therapist',
      rating: 0.0,
      reviewCount: 0,
      status: 'ACTIVE',
      email: request.email,
      phone: request.phone,
      address: '',
      city: '',
      state: '',
      country: '',
      jobTitle: request.jobTitle,
      therapistLevel: request.therapistLevel,
      strengthLevel: request.strengthLevel,
      commissionRate: request.commissionRate,
      healthCheckDate: request.healthCheckDate,
      skills: request.skills,
      workSchedule: [],
      dateOfBirth: request.dateOfBirth,
      gender: request.gender,
      employmentType: 'Contract',
      startDate: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<void> updateEmployee(UpdateEmployeeRequest request) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    developer.log(
      'Mock: Updated employee ${request.id}',
      name: 'EmployeeRemoteDataSourceMock',
    );
  }

  @override
  Future<void> deleteEmployee(EmployeeId id) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    developer.log(
      'Mock: Deleted employee $id',
      name: 'EmployeeRemoteDataSourceMock',
    );
  }

  @override
  Future<List<EmployeeEntity>> getEmployeesByRole({
    required String role,
    int? limit,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final count = limit ?? 10;

    if (role.toUpperCase() == 'DOCTOR') {
      return List.generate(
        count,
        (index) => createMockDoctor(EmployeeId('mock-doc-$index')),
      );
    } else {
      return List.generate(count, (index) {
        if (index % 2 == 0) {
          return createMockSpaTherapist(EmployeeId('mock-spa-$index'));
        } else {
          return createMockMassageTherapist(EmployeeId('mock-massage-$index'));
        }
      });
    }
  }

  @override
  Future<Map<String, String>> getDeviceProficiency() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return employeeMockDeviceProficiency;
  }

  @override
  Future<Map<String, String>> getSpaSkills() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return employeeMockSpaSkills;
  }
}

// ============================================================================
// 4. PROVIDER WITH MOCK SWITCHING
// ============================================================================

/// Provider for [EmployeeRemoteDataSource] with mock/real switching.
///
/// Uses [StoreKey.mockFlag] to determine whether to use mock or real
/// implementation.
@riverpod
EmployeeRemoteDataSource employeeRemoteDataSource(Ref ref) {
  final isMock = Store.get(StoreKey.mockFlag, false);
  if (isMock) {
    return EmployeeRemoteDataSourceMock();
  }
  final apiService = ref.read(apiServiceProvider);
  return EmployeeRemoteDataSourceImpl(apiService: apiService);
}

// ============================================================================
// 5. CUSTOM EXCEPTIONS
// ============================================================================

/// Exception thrown when an employee is not found.
class EmployeeNotFoundException implements Exception {
  /// Creates an exception for the given [id].
  const EmployeeNotFoundException(this.id);

  /// The employee ID that was not found.
  final EmployeeId id;

  @override
  String toString() =>
      'EmployeeNotFoundException: Employee with id $id not found';
}

/// Exception thrown when employee creation fails.
class EmployeeCreationException implements Exception {
  /// Creates an exception with the given [message].
  const EmployeeCreationException(this.message);

  /// The error message.
  final String message;

  @override
  String toString() => 'EmployeeCreationException: $message';
}
