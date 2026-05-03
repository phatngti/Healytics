import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../../core/config/app_environment.dart';
import '../../../../../core/providers/api.provider.dart';
import '../../../../../core/services/api.service.dart';
import 'employee_appointment_mock_data.dart';
import '../../../domain/entities/employee_appointment.entity.dart';

part 'employee_appointment_remote_datasource.g.dart';

/// Contract for appointment data operations.
abstract class EmployeeAppointmentRemoteDatasource {
  Future<List<EmployeeAppointmentEntity>> getAppointments({
    EmployeeAppointmentStatus? status,
  });

  Future<EmployeeAppointmentEntity?> getById(String id);

  Future<bool> startService(String id);
  Future<bool> completeService(String id);
  Future<bool> cancelAppointment(String id);
}

/// Real implementation using OpenAPI client.
class EmployeeAppointmentRemoteDatasourceImpl
    implements EmployeeAppointmentRemoteDatasource {
  final ApiService apiService;

  EmployeeAppointmentRemoteDatasourceImpl({required this.apiService});

  @override
  Future<List<EmployeeAppointmentEntity>> getAppointments({
    EmployeeAppointmentStatus? status,
  }) async {
    // TODO: Replace with real API call when
    // employee appointment endpoints are available.
    throw UnimplementedError('Real API not yet implemented');
  }

  @override
  Future<EmployeeAppointmentEntity?> getById(String id) async {
    throw UnimplementedError('Real API not yet implemented');
  }

  @override
  Future<bool> startService(String id) async {
    throw UnimplementedError('Real API not yet implemented');
  }

  @override
  Future<bool> completeService(String id) async {
    throw UnimplementedError('Real API not yet implemented');
  }

  @override
  Future<bool> cancelAppointment(String id) async {
    throw UnimplementedError('Real API not yet implemented');
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
  Future<bool> cancelAppointment(String id) async {
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
EmployeeAppointmentRemoteDatasource employeeAppointmentRemoteDatasource(
  Ref ref,
) {
  if (AppEnvironment.current.useMock) {
    return EmployeeAppointmentRemoteDatasourceMock();
  }
  final apiService = ref.read(apiServiceProvider);
  return EmployeeAppointmentRemoteDatasourceImpl(apiService: apiService);
}
