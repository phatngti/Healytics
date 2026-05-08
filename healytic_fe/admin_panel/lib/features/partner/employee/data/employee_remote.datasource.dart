import 'dart:developer' as developer;

import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/partner/employee/data/employee_mock_data.dart';
import 'package:admin_panel/features/partner/employee/domain/create_employee.request.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_gender.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_role.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_status.dart';
import 'package:admin_panel/features/partner/employee/domain/employment_type.dart';
import 'package:admin_panel/features/partner/employee/domain/massage_strength_level.dart';
import 'package:admin_panel/features/partner/employee/domain/schedule_entry_key.dart';
import 'package:admin_panel/features/partner/employee/domain/therapist_level.dart';
import 'package:admin_panel/features/partner/employee/domain/verification_document_entry.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/work_history_key.dart';
import 'package:admin_panel/features/partner/employee/domain/therapist_type.dart';
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
      email: request.email,
      phone: request.phone,
      avatarUrl: request.avatar,
      role: _toUpdateRole(EmployeeRoleType.fromApiValue(request.role)),
      status: _toUpdateStatus(EmployeeStatusType.fromApiValue(request.status)),
      verificationDocuments: _toVerificationDocumentDtos(
        request.verificationDocuments,
      ),
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
      gender: _toDoctorGender(EmployeeGender.fromApiValue(request.gender)),
      emergencyContactName: request.emergencyContactName,
      emergencyContactPhone: request.emergencyContactPhone,
      employmentType: request.employmentType,
      startDate: request.startDate,
      schedule: _toScheduleEntries(request.schedule),

      status: CreateDoctorDtoStatusEnum.ACTIVE,
      description: request.description ?? '',
      jobTitle: request.jobTitle,
      verificationDocuments: _toVerificationDocumentDtos(
        request.verificationDocuments,
      ),
      medicalCredentials: _toMedicalCredentials(
        request.medicalTitles,
        request.medicalLicenses,
      ),
      experienceYears: request.experienceYears,
      consultationFee: request.consultationFee,
      specializations: request.specializations,
      education: request.education,
      certifications: request.certifications,
      workHistory: _toWorkHistoryEntries(request.workHistory),
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
      gender: _toSpaGender(EmployeeGender.fromApiValue(request.gender)),
      emergencyContactName: request.emergencyContactName,
      emergencyContactPhone: request.emergencyContactPhone,
      employmentType: request.employmentType,
      startDate: request.startDate,
      schedule: _toScheduleEntries(request.schedule),

      status: CreateSpaTherapistDtoStatusEnum.ACTIVE,
      description: request.description ?? '',
      jobTitle: request.jobTitle,
      verificationDocuments: _toVerificationDocumentDtos(
        request.verificationDocuments,
      ),
      therapistLevel: _toSpaLevel(
        TherapistLevel.fromApiValue(request.therapistLevel),
      ),
      commissionRate: request.commissionRate,
      healthCheckDate: request.healthCheckDate,
      skills: request.skills,
      deviceProficiency: request.deviceProficiency,
      workHistory: _toWorkHistoryEntries(request.workHistory),
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
      gender: _toMassageGender(EmployeeGender.fromApiValue(request.gender)),
      emergencyContactName: request.emergencyContactName,
      emergencyContactPhone: request.emergencyContactPhone,
      employmentType: request.employmentType,
      startDate: request.startDate,
      schedule: _toScheduleEntries(request.schedule),

      status: CreateMassageTherapistDtoStatusEnum.ACTIVE,
      description: request.description ?? '',
      jobTitle: request.jobTitle,
      verificationDocuments: _toVerificationDocumentDtos(
        request.verificationDocuments,
      ),
      therapistLevel: _toMassageLevel(
        TherapistLevel.fromApiValue(request.therapistLevel),
      ),
      strengthLevel: _toMassageStrength(
        MassageStrengthLevel.fromApiValue(request.strengthLevel),
      ),
      commissionRate: request.commissionRate,
      healthCheckDate: request.healthCheckDate,
      skills: request.skills,
      workHistory: _toWorkHistoryEntries(request.workHistory),
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
    final roleStr = dto.role.value.toUpperCase();
    final role = EmployeeRoleType.fromApiValue(roleStr);
    final id = EmployeeId(dto.id);
    final common = _mapCommonFields(dto);
    final schedule = _mapSchedule(dto.schedule);

    if (role == EmployeeRoleType.doctor && dto.doctorProfile != null) {
      final profile = dto.doctorProfile!;
      return DoctorEntity(
        id: id,
        employeeCode: common.employeeCode,
        fullName: common.fullName,
        displayName: common.displayName,
        avatar: common.avatar,
        role: roleStr,
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
        verificationDocuments: _mapVerificationDocuments(
          dto.verificationDocuments,
        ),
        workHistory: _mapWorkHistory(dto.workHistory),
        workSchedule: schedule,
        dateOfBirth: common.dateOfBirth,
        gender: common.gender,
        employmentType: common.employmentType,
        startDate: common.startDate,
        emergencyContactName: common.emergencyContactName,
        emergencyContactPhone: common.emergencyContactPhone,
        jobTitle: dto.jobTitle?.toString() ?? '',

        medicalLicenses: profile.medicalCredentials
            .map((c) => c.license ?? '')
            .where((s) => s.isNotEmpty)
            .toList(),
        medicalTitles: profile.medicalCredentials
            .map((c) => c.title ?? '')
            .where((s) => s.isNotEmpty)
            .toList(),
        experienceYears: profile.experienceYears?.toInt(),
        consultationFee: profile.consultationFee?.toDouble(),
        specializations: profile.specializations,
        education: profile.education,
        certifications: [],
      );
    } else if (role == EmployeeRoleType.therapist && dto.therapistProfile != null) {
      final profile = dto.therapistProfile!;
      final therapistType = TherapistType.fromApiValue(profile.type);

      if (therapistType == TherapistType.spa) {
        return SpaTherapistEntity(
          id: id,
          employeeCode: common.employeeCode,
          fullName: common.fullName,
          displayName: common.displayName,
          avatar: common.avatar,
          role: roleStr,
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
          verificationDocuments: _mapVerificationDocuments(
            dto.verificationDocuments,
          ),
          workHistory: _mapWorkHistory(dto.workHistory),
          workSchedule: schedule,
          dateOfBirth: common.dateOfBirth,
          gender: common.gender,
          employmentType: common.employmentType,
          startDate: common.startDate,
          emergencyContactName: common.emergencyContactName,
          emergencyContactPhone: common.emergencyContactPhone,
          jobTitle: TherapistType.spa.displayName,
          therapistLevel: profile.level,
          commissionRate: profile.commissionRate?.toDouble() ?? 0.0,
          healthCheckDate: profile.healthCheckDate?.toIso8601String(),
          skills: profile.skills,
          deviceProficiency: profile.deviceProficiency,
        );
      } else if (therapistType == TherapistType.massage) {
        return MassageTherapistEntity(
          id: id,
          employeeCode: common.employeeCode,
          fullName: common.fullName,
          displayName: common.displayName,
          avatar: common.avatar,
          role: roleStr,
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
          verificationDocuments: _mapVerificationDocuments(
            dto.verificationDocuments,
          ),
          workHistory: _mapWorkHistory(dto.workHistory),
          workSchedule: schedule,
          dateOfBirth: common.dateOfBirth,
          gender: common.gender,
          employmentType: common.employmentType,
          startDate: common.startDate,
          emergencyContactName: common.emergencyContactName,
          emergencyContactPhone: common.emergencyContactPhone,
          jobTitle: TherapistType.massage.displayName,
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
      employeeCode: common.employeeCode,
      fullName: common.fullName,
      displayName: common.displayName,
      avatar: common.avatar,
      role: roleStr,
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
      verificationDocuments: _mapVerificationDocuments(
        dto.verificationDocuments,
      ),
      workHistory: _mapWorkHistory(dto.workHistory),
      workSchedule: schedule,
      dateOfBirth: common.dateOfBirth,
      gender: common.gender,
      employmentType: common.employmentType,
      startDate: common.startDate,
      emergencyContactName: common.emergencyContactName,
      emergencyContactPhone: common.emergencyContactPhone,
    );
  }

  /// Extracts common fields from [EmployeeResponseDto].
  _CommonFields _mapCommonFields(EmployeeResponseDto dto) {
    return _CommonFields(
      employeeCode: dto.employeeCode,
      fullName: dto.fullName,
      displayName: dto.fullName,
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
      jobTitle: dto.jobTitle?.toString(),
      emergencyContactName: dto.emergencyContactName?.toString(),
      emergencyContactPhone: dto.emergencyContactPhone?.toString(),
    );
  }

  /// Maps [EmployeeRoleType] to OpenAPI [EmployeeRole].
  EmployeeRole? _toUpdateRole(EmployeeRoleType? role) =>
      switch (role) {
        EmployeeRoleType.doctor => EmployeeRole.DOCTOR,
        EmployeeRoleType.therapist => EmployeeRole.THERAPIST,
        EmployeeRoleType.receptionist =>
          EmployeeRole.RECEPTIONIST,
        EmployeeRoleType.manager => EmployeeRole.MANAGER,
        null => null,
      };

  /// Maps [EmployeeStatusType] to OpenAPI [EmployeeStatus].
  EmployeeStatus? _toUpdateStatus(
    EmployeeStatusType? status,
  ) =>
      switch (status) {
        EmployeeStatusType.active => EmployeeStatus.ACTIVE,
        EmployeeStatusType.inactive =>
          EmployeeStatus.INACTIVE,
        EmployeeStatusType.onLeave =>
          EmployeeStatus.ON_LEAVE,
        null => null,
      };

  /// Converts schedule maps to [WorkScheduleEntryDto].
  List<WorkScheduleEntryDto> _toScheduleEntries(
    List<Map<String, dynamic>> schedule,
  ) => schedule
      .map(
        (entry) => WorkScheduleEntryDto(
          day:
              WorkScheduleEntryDtoDayEnum.fromJson(
                entry[ScheduleEntryKey.day],
              ) ??
              WorkScheduleEntryDtoDayEnum.monday,
          start: entry[ScheduleEntryKey.start]?.toString(),
          end: entry[ScheduleEntryKey.end]?.toString(),
          isWorking: entry[ScheduleEntryKey.isWorking] as bool? ?? false,
        ),
      )
      .toList();

  /// Converts work history maps to
  /// [WorkHistoryEntryDto].
  List<WorkHistoryEntryDto> _toWorkHistoryEntries(
    List<Map<String, dynamic>> entries,
  ) => entries
      .map(
        (e) => WorkHistoryEntryDto(
          facility: e[WorkHistoryKey.facility]?.toString() ?? '',
          position: e[WorkHistoryKey.position]?.toString() ?? '',
          period: e[WorkHistoryKey.period]?.toString() ?? '',
          isCurrent: e[WorkHistoryKey.isCurrent] as bool? ?? false,
        ),
      )
      .toList();

  /// Pairs medical titles and licenses into
  /// [MedicalCredentialResponseDto] entries.
  ///
  /// Entries are paired by index. If the lists
  /// differ in length the shorter side fills with
  /// empty strings so no data is lost.
  List<MedicalCredentialResponseDto> _toMedicalCredentials(
    List<String> titles,
    List<String> licenses,
  ) {
    final count = titles.length > licenses.length
        ? titles.length
        : licenses.length;
    return List.generate(count, (i) {
      return MedicalCredentialResponseDto(
        title: i < titles.length ? titles[i] : '',
        license: i < licenses.length ? licenses[i] : '',
      );
    });
  }

  /// Maps [EmployeeGender] to [CreateDoctorDtoGenderEnum].
  CreateDoctorDtoGenderEnum? _toDoctorGender(EmployeeGender? gender) =>
      switch (gender) {
        EmployeeGender.male => CreateDoctorDtoGenderEnum.MALE,
        EmployeeGender.female => CreateDoctorDtoGenderEnum.FEMALE,
        EmployeeGender.nonBinary => CreateDoctorDtoGenderEnum.OTHER,
        _ => null,
      };

  /// Maps [EmployeeGender] to [CreateSpaTherapistDtoGenderEnum].
  CreateSpaTherapistDtoGenderEnum? _toSpaGender(EmployeeGender? gender) =>
      switch (gender) {
        EmployeeGender.male => CreateSpaTherapistDtoGenderEnum.MALE,
        EmployeeGender.female => CreateSpaTherapistDtoGenderEnum.FEMALE,
        EmployeeGender.nonBinary => CreateSpaTherapistDtoGenderEnum.OTHER,
        _ => null,
      };

  /// Maps [EmployeeGender] to
  /// [CreateMassageTherapistDtoGenderEnum].
  CreateMassageTherapistDtoGenderEnum? _toMassageGender(
    EmployeeGender? gender,
  ) => switch (gender) {
    EmployeeGender.male => CreateMassageTherapistDtoGenderEnum.MALE,
    EmployeeGender.female => CreateMassageTherapistDtoGenderEnum.FEMALE,
    EmployeeGender.nonBinary => CreateMassageTherapistDtoGenderEnum.OTHER,
    _ => null,
  };

  /// Maps [TherapistLevel] to
  /// [CreateSpaTherapistDtoTherapistLevelEnum].
  CreateSpaTherapistDtoTherapistLevelEnum? _toSpaLevel(TherapistLevel? level) =>
      switch (level) {
        TherapistLevel.junior => CreateSpaTherapistDtoTherapistLevelEnum.JUNIOR,
        TherapistLevel.senior => CreateSpaTherapistDtoTherapistLevelEnum.SENIOR,
        TherapistLevel.master => CreateSpaTherapistDtoTherapistLevelEnum.MASTER,
        null => null,
      };

  /// Maps [TherapistLevel] to
  /// [CreateMassageTherapistDtoTherapistLevelEnum].
  CreateMassageTherapistDtoTherapistLevelEnum? _toMassageLevel(
    TherapistLevel? level,
  ) => switch (level) {
    TherapistLevel.junior => CreateMassageTherapistDtoTherapistLevelEnum.JUNIOR,
    TherapistLevel.senior => CreateMassageTherapistDtoTherapistLevelEnum.SENIOR,
    TherapistLevel.master => CreateMassageTherapistDtoTherapistLevelEnum.MASTER,
    null => null,
  };

  /// Maps [MassageStrengthLevel] to
  /// [CreateMassageTherapistDtoStrengthLevelEnum].
  CreateMassageTherapistDtoStrengthLevelEnum? _toMassageStrength(
    MassageStrengthLevel? level,
  ) => switch (level) {
    MassageStrengthLevel.soft =>
      CreateMassageTherapistDtoStrengthLevelEnum.SOFT,
    MassageStrengthLevel.medium =>
      CreateMassageTherapistDtoStrengthLevelEnum.MEDIUM,
    MassageStrengthLevel.strong =>
      CreateMassageTherapistDtoStrengthLevelEnum.STRONG,
    null => null,
  };

  /// Maps [WorkHistoryEntryDto] list to domain
  /// [WorkHistoryEntry] list.
  List<WorkHistoryEntry> _mapWorkHistory(List<WorkHistoryEntryDto> dtos) => dtos
      .map(
        (d) => WorkHistoryEntry(
          facility: d.facility,
          position: d.position,
          period: d.period,
          isCurrent: d.isCurrent,
        ),
      )
      .toList();

  /// Maps [WorkScheduleEntryDto] list to domain
  /// [EmployeeSchedule] list.
  List<EmployeeSchedule> _mapSchedule(List<WorkScheduleEntryDto> dtos) => dtos
      .map(
        (d) => EmployeeSchedule(
          day: d.day.value,
          start: d.start ?? '',
          end: d.end ?? '',
          isWorking: d.isWorking,
        ),
      )
      .toList();

  /// Maps [VerificationDocumentEntryDto] list
  /// to domain [VerificationDocumentEntry] list.
  List<VerificationDocumentEntry> _mapVerificationDocuments(
    List<VerificationDocumentEntryDto> dtos,
  ) => dtos
      .map(
        (d) => VerificationDocumentEntry(
          fieldKey: d.fieldKey,
          documents: d.documents
              .map(
                (doc) => DocumentEntry(
                  name: doc.name,
                  url: doc.url,
                  updatedTime: doc.updatedTime,
                ),
              )
              .toList(),
        ),
      )
      .toList();

  /// Converts domain verification document maps
  /// to [VerificationDocumentEntryDto].
  ///
  /// Each map is expected to have the nested
  /// shape `{fieldKey, documents: [{name, url}]}`.
  List<VerificationDocumentEntryDto> _toVerificationDocumentDtos(
    List<Map<String, dynamic>> entries,
  ) => entries.map((e) {
    final rawDocs = e['documents'] as List? ?? [];
    return VerificationDocumentEntryDto(
      fieldKey: e['fieldKey']?.toString() ?? '',
      documents: rawDocs
          .whereType<Map<String, dynamic>>()
          .map(
            (d) => DocumentEntryDto(
              name: d['name']?.toString() ?? '',
              url: d['url']?.toString() ?? '',
            ),
          )
          .toList(),
    );
  }).toList();
}

/// Helper class for common employee fields.
class _CommonFields {
  const _CommonFields({
    required this.employeeCode,
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
    this.jobTitle,
    this.emergencyContactName,
    this.emergencyContactPhone,
  });

  final String employeeCode;
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
  final String? jobTitle;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
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
      role: EmployeeRoleType.doctor.apiValue,
      position: EmployeeRoleType.doctor.displayName,
      rating: 0.0,
      reviewCount: 0,
      status: EmployeeStatusType.active.apiValue,
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
      employmentType: EmploymentType.fullTime.displayName,
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
      role: EmployeeRoleType.therapist.apiValue,
      position: TherapistType.spa.displayName,
      rating: 0.0,
      reviewCount: 0,
      status: EmployeeStatusType.active.apiValue,
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
      employmentType: EmploymentType.partTime.displayName,
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
      role: EmployeeRoleType.therapist.apiValue,
      position: TherapistType.massage.displayName,
      rating: 0.0,
      reviewCount: 0,
      status: EmployeeStatusType.active.apiValue,
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
      employmentType: EmploymentType.contractor.displayName,
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

    final parsedRole = EmployeeRoleType.fromApiValue(role);
    if (parsedRole == EmployeeRoleType.doctor) {
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
