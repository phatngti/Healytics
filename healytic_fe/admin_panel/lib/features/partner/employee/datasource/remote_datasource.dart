import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/partner/employee/datasource/data/employee_mock_data.dart';
import 'package:admin_panel/features/partner/employee/domain/create_employee.request.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/update_employee.request.dart';
import 'package:admin_panel/features/partner/employee/domain/therapist_type.dart';
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

  Future<EmployeeEntity> createSpaTherapist(CreateSpaTherapistRequest request);

  Future<EmployeeEntity> createMassageTherapist(
    CreateMassageTherapistRequest request,
  );

  Future<void> updateEmployee(UpdateEmployeeRequest request);

  Future<void> deleteEmployee(EmployeeId id);

  Future<List<EmployeeEntity>> getEmployeesByRole({
    required String role,
    int? limit,
  });

  Future<Map<String, String>> getSpaSkills();

  Future<Map<String, String>> getDeviceProficiency();
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
      title: request.jobTitle,
      medicalLicense: request.medicalLicense,
      experienceYears: request.experienceYears,
      consultationFee: request.consultationFee,
      specializations: request.specializations,
      education: request.education,
      certifications: request.certifications,
    );

    final dto = CreateDoctorDto(
      employeeCode: request.employeeId,
      fullName: '${request.firstName} ${request.lastName}',
      displayName: '${request.firstName} ${request.lastName}',
      email: request.email,
      phone: request.phone,
      avatarUrl: request.avatar,
      dob: request.dateOfBirth,
      gender: _mapDoctorGender(request.gender),
      status: CreateDoctorDtoStatusEnum.ACTIVE,
      branchId: request.branch,
      profile: profile,
    );

    final response = await _employeesApi.employeesControllerCreateDoctor(dto);
    if (response == null) {
      throw Exception('Failed to create doctor');
    }
    return _mapToEmployeeEntity(response as Map<String, dynamic>);
  }

  @override
  Future<EmployeeEntity> createSpaTherapist(
    CreateSpaTherapistRequest request,
  ) async {
    final profile = TherapistProfileDto(
      level: _mapTherapistLevel(request.therapistLevel),
      type: TherapistType.spa.apiValue,
      strengthLevel: null,
      commissionRate: request.commissionRate,
      healthCheckDate: request.healthCheckDate,
      skills: request.skills,
    );

    final dto = CreateTherapistDto(
      employeeCode: request.employeeId,
      fullName: '${request.firstName} ${request.lastName}',
      displayName: '${request.firstName} ${request.lastName}',
      email: request.email,
      phone: request.phone,
      avatarUrl: request.avatar,
      dob: request.dateOfBirth,
      gender: _mapTherapistGender(request.gender),
      status: CreateTherapistDtoStatusEnum.ACTIVE,
      branchId: request.branch,
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

  @override
  Future<EmployeeEntity> createMassageTherapist(
    CreateMassageTherapistRequest request,
  ) async {
    final profile = TherapistProfileDto(
      level: _mapTherapistLevel(request.therapistLevel),
      type: TherapistType.massage.apiValue,
      strengthLevel: _mapStrengthLevel(request.strengthLevel),
      commissionRate: request.commissionRate,
      healthCheckDate: request.healthCheckDate,
      skills: request.skills,
    );

    final dto = CreateTherapistDto(
      employeeCode: request.employeeId,
      fullName: '${request.firstName} ${request.lastName}',
      displayName: '${request.firstName} ${request.lastName}',
      email: request.email,
      phone: request.phone,
      avatarUrl: request.avatar,
      dob: request.dateOfBirth,
      gender: _mapTherapistGender(request.gender),
      status: CreateTherapistDtoStatusEnum.ACTIVE,
      branchId: request.branch,
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
    final role = json['role']?.toString().toUpperCase() ?? '';
    final profile = json['profile'] as Map<String, dynamic>? ?? {};
    final id = EmployeeId(json['id']?.toString() ?? '');
    final common = _mapCommonFields(json);

    if (role == 'DOCTOR') {
      return DoctorEntity(
        id: id,
        fullName: common['fullName'],
        displayName: common['displayName'],
        avatar: common['avatar'],
        role: role,
        position: common['position'],
        rating: common['rating'],
        reviewCount: common['reviewCount'],
        status: common['status'],
        email: common['email'],
        phone: common['phone'],
        address: common['address'],
        city: common['city'],
        state: common['state'],
        country: common['country'],
        licenseUrl: common['licenseUrl'],
        idCardUrl: common['idCardUrl'],
        description: json['description']?.toString(),
        documents: common['documents'],
        dateOfBirth: common['dateOfBirth'],
        gender: common['gender'],
        employmentType: common['employmentType'],
        startDate: common['startDate'],
        // Doctor specific
        jobTitle: profile['title']?.toString() ?? '',
        medicalLicense: profile['medicalLicense']?.toString() ?? '',
        experienceYears: int.tryParse(
          profile['experienceYears']?.toString() ?? '',
        ),
        consultationFee: double.tryParse(
          profile['consultationFee']?.toString() ?? '',
        ),
        specializations: _parseList(profile['specializations']),
        education: _parseList(profile['education']),
        certifications: _parseList(profile['certifications']),
      );
    } else if (role == 'THERAPIST') {
      final type = profile['type']?.toString().toUpperCase();
      if (type == 'SPA') {
        return SpaTherapistEntity(
          id: id,
          fullName: common['fullName'],
          displayName: common['displayName'],
          avatar: common['avatar'],
          role: role,
          position: common['position'],
          rating: common['rating'],
          reviewCount: common['reviewCount'],
          status: common['status'],
          email: common['email'],
          phone: common['phone'],
          address: common['address'],
          city: common['city'],
          state: common['state'],
          country: common['country'],
          licenseUrl: common['licenseUrl'],
          idCardUrl: common['idCardUrl'],
          description: json['description']?.toString(),
          documents: common['documents'],
          dateOfBirth: common['dateOfBirth'],
          gender: common['gender'],
          employmentType: common['employmentType'],
          startDate: common['startDate'],
          // Spa Specific
          jobTitle: 'Spa Therapist', // No title in profile for therapist?
          therapistLevel: profile['level']?.toString(),
          commissionRate:
              double.tryParse(profile['commissionRate']?.toString() ?? '0.0') ??
              0.0,
          healthCheckDate: profile['healthCheckDate']?.toString(),
          skills: _parseList(profile['skills']),
          deviceProficiency: _parseList(profile['deviceProficiency']),
        );
      } else if (type == 'MASSAGE') {
        return MassageTherapistEntity(
          id: id,
          fullName: common['fullName'],
          displayName: common['displayName'],
          avatar: common['avatar'],
          role: role,
          position: common['position'],
          rating: common['rating'],
          reviewCount: common['reviewCount'],
          status: common['status'],
          email: common['email'],
          phone: common['phone'],
          address: common['address'],
          city: common['city'],
          state: common['state'],
          country: common['country'],
          licenseUrl: common['licenseUrl'],
          idCardUrl: common['idCardUrl'],
          description: json['description']?.toString(),
          documents: common['documents'],
          dateOfBirth: common['dateOfBirth'],
          gender: common['gender'],
          employmentType: common['employmentType'],
          startDate: common['startDate'],
          // Massage Specific
          jobTitle: 'Massage Therapist',
          therapistLevel: profile['level']?.toString(),
          commissionRate:
              double.tryParse(profile['commissionRate']?.toString() ?? '0.0') ??
              0.0,
          healthCheckDate: profile['healthCheckDate']?.toString(),
          skills: _parseList(profile['skills']),
          strengthLevel: profile['strengthLevel']?.toString(),
        );
      }
    }

    // Fallback to basic
    return BasicEmployeeEntity(
      id: id,
      fullName: common['fullName'],
      displayName: common['displayName'],
      avatar: common['avatar'],
      role: role,
      position: common['position'],
      rating: common['rating'],
      reviewCount: common['reviewCount'],
      status: common['status'],
      email: common['email'],
      phone: common['phone'],
      address: common['address'],
      city: common['city'],
      state: common['state'],
      country: common['country'],
      licenseUrl: common['licenseUrl'],
      idCardUrl: common['idCardUrl'],
      description: json['description']?.toString(),
      documents: common['documents'],
      dateOfBirth: common['dateOfBirth'],
      gender: common['gender'],
      employmentType: common['employmentType'],
      startDate: common['startDate'],
    );
  }

  Map<String, dynamic> _mapCommonFields(Map<String, dynamic> json) {
    return {
      'fullName': json['fullName']?.toString() ?? '',
      'displayName': json['displayName']?.toString() ?? '',
      'avatar': json['avatarUrl']?.toString() ?? '',
      'position': json['role']?.toString() ?? '',
      'rating': double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
      'reviewCount': (json['reviewCount'] as num?)?.toInt() ?? 0,
      'status': json['status']?.toString() ?? 'ACTIVE',
      'email': json['email']?.toString() ?? '',
      'phone': json['phone']?.toString() ?? '',
      'address': '',
      'city': '',
      'state': '',
      'country': '',
      'licenseUrl': json['licenseUrl']?.toString(),
      'idCardUrl': json['idCardUrl']?.toString(),
      'documents': _parseList(json['documents']),
      'dateOfBirth': json['dob']?.toString(),
      'gender': json['gender']?.toString(),
      'employmentType': json['employmentType']?.toString(),
      'startDate': json['startDate']?.toString(),
    };
  }

  List<String> _parseList(dynamic list) {
    if (list is List) {
      return list.map((e) => e.toString()).toList();
    }
    return [];
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

  @override
  Future<Map<String, String>> getDeviceProficiency() async {
    // TODO: Implement API call
    return {};
  }

  @override
  Future<Map<String, String>> getSpaSkills() async {
    // TODO: Implement API call
    return {};
  }
}

class EmployeeRemoteDataSourceMock implements EmployeeRemoteDataSource {
  static const _workSchedule = employeeMockWorkSchedule;

  Map<String, dynamic> _getCommonFields(String idSuffix, String role) {
    // Use hash of idSuffix to pick a stable random image
    final imageIndex = idSuffix.hashCode.abs() % employeeMockAvatarPaths.length;
    final avatarUrl = employeeMockAvatarPaths[imageIndex];

    return {
      'fullName': 'Mock $role Name $idSuffix',
      'displayName': 'Mock $role $idSuffix',
      'avatar': avatarUrl,
      'role': role.toUpperCase(),
      'position': role == 'Doctor'
          ? 'Specialist Doctor'
          : '$role Therapist', // 'Spa Therapist' or 'Massage Therapist'
      'rating': 4.5,
      'reviewCount': 100,
      'status': 'ACTIVE',
      'email': 'mock.$role.$idSuffix@example.com',
      'phone': '0901234567',
      'address': '123 Mock Street, District 1',
      'city': 'Ho Chi Minh City',
      'state': 'Ho Chi Minh',
      'country': 'Vietnam',
      'licenseUrl': employeeMockPdfUrl,
      'idCardUrl': employeeMockPdfUrl,
      'documents': employeeMockDocuments,
      'description': employeeMockDescription,
      'dateOfBirth': '1990-05-15',
      'gender': 'FEMALE',
      'employmentType': 'Full-Time',
      'startDate': '2023-01-01',
    };
  }

  DoctorEntity _createDoctor(EmployeeId id) {
    final common = _getCommonFields(id.value, 'Doctor');
    return DoctorEntity(
      id: id,
      fullName: common['fullName'],
      displayName: common['displayName'],
      avatar: common['avatar'],
      role: 'DOCTOR',
      position: 'Senior Doctor',
      rating: common['rating'],
      reviewCount: common['reviewCount'],
      status: common['status'],
      email: common['email'],
      phone: common['phone'],
      address: common['address'],
      city: common['city'],
      state: common['state'],
      country: common['country'],
      licenseUrl: common['licenseUrl'],
      idCardUrl: common['idCardUrl'],
      description: common['description'],
      documents: common['documents'],
      dateOfBirth: common['dateOfBirth'],
      gender: common['gender'],
      employmentType: common['employmentType'],
      startDate: common['startDate'],
      jobTitle: 'Dermatologist',
      medicalLicense: 'MED-LICENSE-${id.value}',
      experienceYears: 12,
      consultationFee: 500000.0,
      specializations: ['Dermatology', 'Cosmetic Surgery', 'Laser Treatments'],
      education: [
        'MD - University of Medicine and Pharmacy',
        'PhD - Dermatological Research Institute',
      ],
      certifications: [
        'Board Certified Dermatologist',
        'Advanced Laser Safety Officer',
      ],
      workSchedule: _workSchedule,
    );
  }

  SpaTherapistEntity _createSpaTherapist(EmployeeId id) {
    final common = _getCommonFields(id.value, 'Spa');
    return SpaTherapistEntity(
      id: id,
      fullName: common['fullName'],
      displayName: common['displayName'],
      avatar: common['avatar'],
      role: 'THERAPIST',
      position: 'Spa Therapist',
      rating: common['rating'],
      reviewCount: common['reviewCount'],
      status: common['status'],
      email: common['email'],
      phone: common['phone'],
      address: common['address'],
      city: common['city'],
      state: common['state'],
      country: common['country'],
      licenseUrl: common['licenseUrl'],
      idCardUrl: common['idCardUrl'],
      description: common['description'],
      documents: common['documents'],
      dateOfBirth: common['dateOfBirth'],
      gender: common['gender'],
      employmentType: common['employmentType'],
      startDate: common['startDate'],
      jobTitle: 'Senior Spa Therapist',
      therapistLevel: 'SENIOR',
      commissionRate: 15.0,
      healthCheckDate: DateTime.now()
          .subtract(const Duration(days: 30))
          .toIso8601String(),
      skills: ['Facial', 'Body Wrap', 'Aromatherapy', 'Skin Care'],
      deviceProficiency: ['Laser Machine', 'HIFU Device', 'Skin Analyzer'],
      workSchedule: _workSchedule,
    );
  }

  MassageTherapistEntity _createMassageTherapist(EmployeeId id) {
    final common = _getCommonFields(id.value, 'Massage');
    return MassageTherapistEntity(
      id: id,
      fullName: common['fullName'],
      displayName: common['displayName'],
      avatar: common['avatar'],
      role: 'THERAPIST',
      position: 'Massage Therapist',
      rating: common['rating'],
      reviewCount: common['reviewCount'],
      status: common['status'],
      email: common['email'],
      phone: common['phone'],
      address: common['address'],
      city: common['city'],
      state: common['state'],
      country: common['country'],
      licenseUrl: common['licenseUrl'],
      idCardUrl: common['idCardUrl'],
      description: common['description'],
      documents: common['documents'],
      dateOfBirth: common['dateOfBirth'],
      gender: common['gender'],
      employmentType: common['employmentType'],
      startDate: common['startDate'],
      jobTitle: 'Master Massage Therapist',
      therapistLevel: 'MASTER',
      strengthLevel: 'STRONG',
      commissionRate: 20.0,
      healthCheckDate: DateTime.now()
          .subtract(const Duration(days: 15))
          .toIso8601String(),
      skills: ['Thai Massage', 'Shiatsu', 'Deep Tissue', 'Reflexology'],
      workSchedule: _workSchedule,
    );
  }

  @override
  Future<List<EmployeeEntity>> getEmployees(
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(count, (index) {
      final i = startingAt + index;
      final type = i % 3; // 0: Doctor, 1: Spa, 2: Massage
      final id = EmployeeId('mock-id-$i');

      if (type == 0) {
        return _createDoctor(id);
      } else if (type == 1) {
        return _createSpaTherapist(id);
      } else {
        return _createMassageTherapist(id);
      }
    });
  }

  @override
  Future<int> getTotalRows() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 100;
  }

  @override
  Future<EmployeeEntity> getEmployeeById(EmployeeId id) async {
    await Future.delayed(const Duration(seconds: 1));
    final idVal = id.value.toLowerCase();

    // Heuristics to decide type based on ID content or random for generic IDs
    if (idVal.contains('doctor')) {
      return _createDoctor(id);
    } else if (idVal.contains('spa')) {
      return _createSpaTherapist(id);
    } else if (idVal.contains('massage')) {
      return _createMassageTherapist(id);
    }

    // Fallback based on hash code or parsing number
    final hashInfo = idVal.codeUnits.fold(0, (p, c) => p + c);
    final type = hashInfo % 3;

    // Check if it ends with a number
    try {
      final parts = idVal.split('-');
      if (parts.isNotEmpty) {
        final lastNum = int.tryParse(parts.last);
        if (lastNum != null) {
          final type = lastNum % 3;
          if (type == 0) return _createDoctor(id);
          if (type == 1) return _createSpaTherapist(id);
          if (type == 2) return _createMassageTherapist(id);
        }
      }
    } catch (_) {}

    if (type == 0) return _createDoctor(id);
    if (type == 1) return _createSpaTherapist(id);
    return _createMassageTherapist(id);
  }

  @override
  Future<EmployeeEntity> createDoctor(CreateDoctorRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
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
      medicalLicense: request.medicalLicense,
      experienceYears: request.experienceYears,
      consultationFee: request.consultationFee,
      specializations: request.specializations,
      education: request.education,
      certifications: request.certifications,
      workSchedule: [],
      dateOfBirth: request.dateOfBirth,
      gender: request.gender,
      employmentType: 'Full-Time', // Default for new
      startDate: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<EmployeeEntity> createSpaTherapist(
    CreateSpaTherapistRequest request,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
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
      employmentType: 'Part-Time', // Default for new
      startDate: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<EmployeeEntity> createMassageTherapist(
    CreateMassageTherapistRequest request,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
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
      employmentType: 'Contract', // Default for new
      startDate: DateTime.now().toIso8601String(),
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

    // Return specific types based on requested role
    if (role.toUpperCase() == 'DOCTOR') {
      return List.generate(
        count,
        (index) => _createDoctor(EmployeeId('mock-doc-$index')),
      );
    } else {
      // Return mix of therapists if role is therapist, or just basic if generic
      return List.generate(count, (index) {
        if (index % 2 == 0) {
          return _createSpaTherapist(EmployeeId('mock-spa-$index'));
        } else {
          return _createMassageTherapist(EmployeeId('mock-massage-$index'));
        }
      });
    }
  }

  @override
  Future<Map<String, String>> getDeviceProficiency() async {
    await Future.delayed(const Duration(seconds: 1));
    return employeeMockDeviceProficiency;
  }

  @override
  Future<Map<String, String>> getSpaSkills() async {
    await Future.delayed(const Duration(seconds: 1));
    return employeeMockSpaSkills;
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
