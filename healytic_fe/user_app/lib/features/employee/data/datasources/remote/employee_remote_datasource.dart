import 'package:logging/logging.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/employee/domain/entities/employee_detail.entity.dart';
import 'package:user_app/features/employee/domain/entities/medical_credential.entity.dart';
import 'package:user_app/features/service_details/data/datasources/remote/service_details_mock_data.dart';
import 'package:user_app/features/service_details/domain/entities/service_details.entity.dart';
import 'package:user_openapi/api.dart' hide EmployeeRole, EmployeeStatus;

import 'employee_mock_data.dart';

/// Contract for fetching employee data.
abstract class EmployeeRemoteDatasource {
  /// Fetches all employees, optionally filtered
  /// by [role].
  Future<List<EmployeeDetailEntity>> getEmployees({String? role});

  /// Fetches a single employee by [id].
  Future<EmployeeDetailEntity> getEmployeeById(String id);

  /// Fetches public reviews for a single employee.
  Future<List<ReviewEntity>> getEmployeeReviews(String id);
}

// ─── Real implementation ──────────────────────────

/// Production implementation backed by the
/// [UserEmployeesApi] OpenAPI client.
class EmployeeRemoteDatasourceImpl implements EmployeeRemoteDatasource {
  static final _log = Logger('EmployeeDatasource');
  final ApiService _apiService;

  EmployeeRemoteDatasourceImpl(this._apiService);

  @override
  Future<List<EmployeeDetailEntity>> getEmployees({String? role}) async {
    try {
      final dtos = await _apiService.userEmployeesApi
          .userEmployeesControllerFindAll(role: role);

      _log.info('Fetched ${dtos?.length ?? 0} employees');

      return (dtos ?? []).map(_mapEmployeeDto).toList();
    } catch (e, s) {
      _log.severe('Error fetching employees', e, s);
      rethrow;
    }
  }

  @override
  Future<EmployeeDetailEntity> getEmployeeById(String id) async {
    try {
      final dto = await _apiService.userEmployeesApi
          .userEmployeesControllerFindOne(id);

      if (dto == null) {
        throw Exception('Employee $id not found');
      }

      _log.info('Fetched employee: ${dto.fullName}');
      return _mapEmployeeDto(dto);
    } catch (e, s) {
      _log.severe('Error fetching employee $id', e, s);
      rethrow;
    }
  }

  @override
  Future<List<ReviewEntity>> getEmployeeReviews(String id) async {
    try {
      final dtos = await _apiService.userEmployeesApi
          .userEmployeesControllerFindReviews(id);

      _log.info('Fetched ${dtos?.length ?? 0} reviews for employee $id');

      return (dtos ?? []).map(_mapReviewDto).toList();
    } catch (e, s) {
      _log.severe('Error fetching employee reviews $id', e, s);
      rethrow;
    }
  }

  // ─── DTO → Entity mappers ────────────────────────

  EmployeeDetailEntity _mapEmployeeDto(EmployeeResponseDto dto) {
    print('reviewCount ${dto.reviewCount}');
    return EmployeeDetailEntity(
      id: dto.id,
      employeeCode: dto.employeeCode,
      fullName: dto.fullName,
      avatarUrl: _objToString(dto.avatarUrl),
      role: EmployeeRole.fromString(dto.role.value),
      status: EmployeeStatus.fromString(dto.status.value),
      jobTitle: _objToString(dto.jobTitle),
      description: _objToString(dto.description),
      email: dto.email,
      phone: _objToString(dto.phone),
      dob: _parseDateTime(dto.dob),
      gender: EmployeeGender.fromString(dto.gender?.value),
      startDate: _parseDateTime(dto.startDate),
      employmentType: _objToString(dto.employmentType),
      emergencyContactName: _objToString(dto.emergencyContactName),
      emergencyContactPhone: _objToString(dto.emergencyContactPhone),
      rating: dto.rating.toDouble(),
      reviewCount: dto.reviewCount.toInt(),
      schedule: _mapSchedule(dto.schedule),
      workHistory: _mapWorkHistory(dto.workHistory),
      verificationDocuments: _mapVerificationDocs(dto.verificationDocuments),
      doctorProfile: _mapDoctorProfile(dto.doctorProfile),
      therapistProfile: _mapTherapistProfile(dto.therapistProfile),
    );
  }

  List<WorkScheduleEntry> _mapSchedule(List<WorkScheduleEntryDto> entries) {
    return entries
        .map(
          (e) => WorkScheduleEntry(
            day: e.day.value,
            startTime: e.start,
            endTime: e.end,
            isWorking: e.isWorking,
          ),
        )
        .toList();
  }

  List<WorkHistoryEntry> _mapWorkHistory(List<WorkHistoryEntryDto> entries) {
    return entries
        .map(
          (e) => WorkHistoryEntry(
            facility: e.facility,
            position: e.position,
            period: e.period,
            isCurrent: e.isCurrent,
          ),
        )
        .toList();
  }

  List<VerificationDocumentEntity> _mapVerificationDocs(
    List<VerificationDocumentEntryDto> entries,
  ) {
    return entries
        .map(
          (e) => VerificationDocumentEntity(
            fieldKey: e.fieldKey,
            documents: e.documents
                .map(
                  (d) => DocumentEntryEntity(
                    name: d.name,
                    url: d.url,
                    updatedTime: d.updatedTime,
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  DoctorProfileEntity? _mapDoctorProfile(DoctorProfileResponseDto? dto) {
    if (dto == null) return null;
    return DoctorProfileEntity(
      title: dto.title,
      medicalCredentials: _mapCredentials(dto.medicalCredentials),
      experienceYears: dto.experienceYears?.toInt(),
      consultationFee: dto.consultationFee?.toDouble(),
      specializations: dto.specializations,
      education: dto.education,
    );
  }

  /// Defensively maps credential DTOs whose
  /// required API fields may still arrive as null.
  List<MedicalCredentialEntity> _mapCredentials(
    List<MedicalCredentialResponseDto> raw,
  ) {
    final credentials = <MedicalCredentialEntity>[];

    for (final dto in raw) {
      final title = dto.title?.trim();
      final license = dto.license?.trim();

      if ((title == null || title.isEmpty) &&
          (license == null || license.isEmpty)) {
        continue;
      }

      credentials.add(
        MedicalCredentialEntity(
          title: title?.isNotEmpty == true ? title! : license!,
          license: license,
        ),
      );
    }

    return credentials;
  }

  TherapistProfileEntity? _mapTherapistProfile(
    TherapistProfileResponseDto? dto,
  ) {
    if (dto == null) return null;
    return TherapistProfileEntity(
      level: dto.level,
      type: dto.type,
      strengthLevel: dto.strengthLevel,
      skills: dto.skills,
      deviceProficiency: dto.deviceProficiency,
      healthCheckDate: dto.healthCheckDate,
    );
  }

  ReviewEntity _mapReviewDto(PublicEmployeeReviewResponseDto dto) {
    return ReviewEntity(
      reviewerName: dto.reviewerName,
      avatarUrl: dto.avatarUrl?.toString() ?? '',
      rating: dto.rating.toInt(),
      date: DateTime.tryParse(dto.createdAt) ?? DateTime.now(),
      text: dto.comment?.toString() ?? '',
    );
  }

  /// Defensively converts [Object?] to [String?].
  String? _objToString(Object? value) {
    if (value == null) return null;
    return value.toString();
  }

  /// Parses [Object?] to [DateTime?] defensively.
  DateTime? _parseDateTime(Object? value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}

// ─── Mock implementation ──────────────────────────

/// Mock implementation returning fake data after a
/// simulated network delay.
class EmployeeRemoteDatasourceMock implements EmployeeRemoteDatasource {
  @override
  Future<List<EmployeeDetailEntity>> getEmployees({String? role}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (role == null) return kMockEmployees;
    final lower = role.toLowerCase();
    return kMockEmployees.where((e) => e.role.name == lower).toList();
  }

  @override
  Future<EmployeeDetailEntity> getEmployeeById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return kMockEmployees.firstWhere(
      (e) => e.id == id,
      orElse: () => kMockEmployees.first,
    );
  }

  @override
  Future<List<ReviewEntity>> getEmployeeReviews(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return kMockEmployeeReviewsMap[id] ?? [];
  }
}

// ─── Provider ─────────────────────────────────────

/// Uses [AppEnvironment.useMock] to switch between
/// real and mock implementations at runtime.
final employeeRemoteDatasourceProvider = Provider<EmployeeRemoteDatasource>((
  ref,
) {
  final useMock = AppEnvironment.current.useMock;

  if (useMock) {
    return EmployeeRemoteDatasourceMock();
  }

  final apiService = ref.read(apiServiceProvider);
  return EmployeeRemoteDatasourceImpl(apiService);
});
