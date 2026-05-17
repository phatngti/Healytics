import 'dart:developer' show log;

import 'package:user_openapi/api.dart'
    show
        ApiException,
        CancelEmployeeAppointmentDto,
        EmployeeAppointmentResponseDto,
        EmployeeBookingStatusFilter;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/config/app_environment.dart';
import '../../../../../core/providers/api.provider.dart';
import '../../../../../core/services/api.service.dart';
import '../../../domain/entities/employee_appointment.entity.dart';
import 'employee_appointment_mock_data.dart';

part 'employee_appointment_remote_datasource.g.dart';

/// Contract for appointment data operations.
abstract class EmployeeAppointmentRemoteDatasource {
  /// Fetches appointments, optionally filtered
  /// by [status].
  Future<List<EmployeeAppointmentEntity>> getAppointments({
    EmployeeAppointmentStatus? status,
  });

  /// Fetches a single appointment by [id].
  Future<EmployeeAppointmentEntity?> getById(String id);

  /// Transitions appointment to in-progress.
  Future<bool> startService(String id);

  /// Transitions appointment to completed.
  Future<bool> completeService(String id);

  /// Cancels an appointment with optional [reason].
  Future<bool> cancelAppointment(
    String id, {
    String? reason,
  });
}

/// Real implementation using OpenAPI client.
class EmployeeAppointmentRemoteDatasourceImpl
    implements EmployeeAppointmentRemoteDatasource {
  final ApiService apiService;

  EmployeeAppointmentRemoteDatasourceImpl({
    required this.apiService,
  });

  // ── Mapping helpers ─────────────────────────

  /// Maps OpenAPI status → domain status.
  EmployeeAppointmentStatus _mapStatus(
    EmployeeBookingStatusFilter status,
  ) =>
      switch (status) {
        EmployeeBookingStatusFilter.upcoming =>
          EmployeeAppointmentStatus.upcoming,
        EmployeeBookingStatusFilter.inProgress =>
          EmployeeAppointmentStatus.inProgress,
        EmployeeBookingStatusFilter.completed =>
          EmployeeAppointmentStatus.completed,
        EmployeeBookingStatusFilter.canceled =>
          EmployeeAppointmentStatus.canceled,
        _ => EmployeeAppointmentStatus.upcoming,
      };

  /// Maps domain status → OpenAPI filter.
  EmployeeBookingStatusFilter? _mapStatusToFilter(
    EmployeeAppointmentStatus? status,
  ) =>
      switch (status) {
        EmployeeAppointmentStatus.upcoming =>
          EmployeeBookingStatusFilter.upcoming,
        EmployeeAppointmentStatus.inProgress =>
          EmployeeBookingStatusFilter.inProgress,
        EmployeeAppointmentStatus.completed =>
          EmployeeBookingStatusFilter.completed,
        EmployeeAppointmentStatus.canceled =>
          EmployeeBookingStatusFilter.canceled,
        null => null,
      };

  /// Defensively maps a DTO to the domain entity.
  EmployeeAppointmentEntity _mapToEntity(
    EmployeeAppointmentResponseDto dto,
  ) =>
      EmployeeAppointmentEntity(
        id: dto.id,
        serviceName: dto.serviceName,
        customerName: dto.customerName,
        customerId: dto.customerId,
        imageUrl: dto.imageUrl,
        status: _mapStatus(dto.status),
        category: dto.category,
        clinicName: dto.clinicName,
        address: dto.address,
        date: dto.date,
        checkInTime: dto.checkInTime,
        checkOutTime: dto.checkOutTime,
        duration: dto.duration,
        price: dto.price?.toDouble(),
        notes: dto.notes,
      );

  // ── API methods ─────────────────────────────

  @override
  Future<List<EmployeeAppointmentEntity>> getAppointments({
    EmployeeAppointmentStatus? status,
  }) async {
    try {
      final statusFilter = _mapStatusToFilter(status);
      final response = await apiService
          .employeeAppointmentsApi
          .employeeAppointmentsControllerListMyAppointments(
        status: statusFilter,
        page: 1,
        limit: 100,
      );
      if (response == null) return [];
      return response.data
          .map(_mapToEntity)
          .toList();
    } on ApiException catch (e) {
      log(
        'Failed to fetch appointments: ${e.code}',
        name: 'EmployeeAppointmentDatasource',
      );
      rethrow;
    }
  }

  @override
  Future<EmployeeAppointmentEntity?> getById(
    String id,
  ) async {
    try {
      final dto = await apiService
          .employeeAppointmentsApi
          .employeeAppointmentsControllerGetAppointment(
            id,
          );
      return dto != null ? _mapToEntity(dto) : null;
    } on ApiException catch (e) {
      if (e.code == 404) return null;
      log(
        'Failed to get appointment $id: ${e.code}',
        name: 'EmployeeAppointmentDatasource',
      );
      rethrow;
    }
  }

  @override
  Future<bool> startService(String id) async {
    try {
      final dto = await apiService
          .employeeAppointmentsApi
          .employeeAppointmentsControllerStartService(id);
      return dto != null;
    } on ApiException catch (e) {
      log(
        'Failed to start service $id: ${e.code}',
        name: 'EmployeeAppointmentDatasource',
      );
      rethrow;
    }
  }

  @override
  Future<bool> completeService(String id) async {
    try {
      final dto = await apiService
          .employeeAppointmentsApi
          .employeeAppointmentsControllerCompleteService(
            id,
          );
      return dto != null;
    } on ApiException catch (e) {
      log(
        'Failed to complete service $id: ${e.code}',
        name: 'EmployeeAppointmentDatasource',
      );
      rethrow;
    }
  }

  @override
  Future<bool> cancelAppointment(
    String id, {
    String? reason,
  }) async {
    try {
      final cancelDto = CancelEmployeeAppointmentDto(
        reason: reason,
      );
      final dto = await apiService
          .employeeAppointmentsApi
          .employeeAppointmentsControllerCancelAppointment(
            id,
            cancelDto,
          );
      return dto != null;
    } on ApiException catch (e) {
      log(
        'Failed to cancel appointment $id: ${e.code}',
        name: 'EmployeeAppointmentDatasource',
      );
      rethrow;
    }
  }
}

/// Mock implementation with realistic data.
class EmployeeAppointmentRemoteDatasourceMock
    implements EmployeeAppointmentRemoteDatasource {
  /// In-memory store for status transitions.
  final List<EmployeeAppointmentEntity> _store = List.from(
    kMockEmployeeAppointments,
  );

  @override
  Future<List<EmployeeAppointmentEntity>> getAppointments({
    EmployeeAppointmentStatus? status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (status == null) return List.from(_store);
    return _store.where((a) => a.status == status).toList();
  }

  @override
  Future<EmployeeAppointmentEntity?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _store.where((a) => a.id == id).firstOrNull;
  }

  @override
  Future<bool> startService(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = _store.indexWhere((a) => a.id == id);
    if (idx == -1) return false;
    _store[idx] = _store[idx].copyWith(
      status: EmployeeAppointmentStatus.inProgress,
    );
    return true;
  }

  @override
  Future<bool> completeService(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = _store.indexWhere((a) => a.id == id);
    if (idx == -1) return false;
    _store[idx] = _store[idx].copyWith(
      status: EmployeeAppointmentStatus.completed,
    );
    return true;
  }

  @override
  Future<bool> cancelAppointment(
    String id, {
    String? reason,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = _store.indexWhere((a) => a.id == id);
    if (idx == -1) return false;
    _store[idx] = _store[idx].copyWith(
      status: EmployeeAppointmentStatus.canceled,
    );
    return true;
  }
}

@Riverpod(keepAlive: true)
EmployeeAppointmentRemoteDatasource
    employeeAppointmentRemoteDatasource(Ref ref) {
  if (AppEnvironment.current.useMock) {
    return EmployeeAppointmentRemoteDatasourceMock();
  }
  final apiService = ref.read(apiServiceProvider);
  return EmployeeAppointmentRemoteDatasourceImpl(
    apiService: apiService,
  );
}
