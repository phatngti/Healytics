import 'package:logging/logging.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';
import 'package:user_openapi/api.dart';

import 'appointment_mock_data.dart';

/// Contract for fetching appointment data.
abstract class AppointmentRemoteDatasource {
  /// Fetches all appointments.
  Future<List<AppointmentEntity>> getAppointments();

  /// Fetches appointment category filters.
  Future<List<AppointmentCategory>> getCategories();

  /// Fetches recommended services.
  Future<List<RecommendedServiceEntity>> getRecommendations();

  /// Fetches a single appointment by [id].
  Future<AppointmentEntity?> getAppointmentById(String id);
}

// ─── Real implementation ──────────────────────────

/// Production implementation backed by the
/// [UserAppointmentsApi] OpenAPI client.
class AppointmentRemoteDatasourceImpl implements AppointmentRemoteDatasource {
  static final _log = Logger('AppointmentDatasource');
  final ApiService _apiService;

  AppointmentRemoteDatasourceImpl(this._apiService);

  @override
  Future<List<AppointmentEntity>> getAppointments() async {
    try {
      final response = await _apiService.userAppointmentsApi
          .userAppointmentControllerListAppointments();
      if (response == null) return [];
      _log.info('Fetched ${response.length} appointments');
      return response.map(_mapAppointmentDto).toList();
    } catch (e, s) {
      _log.severe('Error fetching appointments', e, s);
      return [];
    }
  }

  @override
  Future<List<AppointmentCategory>> getCategories() async {
    try {
      final response = await _apiService.userAppointmentsApi
          .userAppointmentControllerListCategories();

      if (response == null) return [];
      return response.map(_mapCategoryDto).toList();
    } catch (e, s) {
      _log.severe('Error fetching categories', e, s);
      return [];
    }
  }

  @override
  Future<List<RecommendedServiceEntity>> getRecommendations() async {
    try {
      final response = await _apiService.userAppointmentsApi
          .userAppointmentControllerListRecommendedServices();

      if (response == null) return [];
      return response.map(_mapRecommendationDto).toList();
    } catch (e, s) {
      _log.severe('Error fetching recommendations', e, s);
      return [];
    }
  }

  @override
  Future<AppointmentEntity?> getAppointmentById(String id) async {
    try {
      final response = await _apiService.userAppointmentsApi
          .userAppointmentControllerGetAppointment(id);

      if (response == null) return null;
      return _mapAppointmentDto(response);
    } catch (e, s) {
      _log.severe('Error fetching appointment $id', e, s);
      return null;
    }
  }

  // ─── DTO → Entity mappers ────────────────────────

  AppointmentEntity _mapAppointmentDto(AppointmentResponseDto dto) {
    return AppointmentEntity(
      id: dto.id,
      serviceName: dto.serviceName,
      vendorName: dto.vendorName,
      imageUrl: dto.imageUrl,
      status: dto.status.value.toLowerCase(),
      category: dto.category,
      providerName: dto.providerName,
      providerId: dto.providerId,
      address: dto.address,
      date: DateTime.tryParse(dto.date) ?? DateTime.now(),
      checkInTime: dto.checkInTime,
      checkOutTime: dto.checkOutTime,
      duration: dto.duration,
      distanceKm: _parseDistance(dto.distanceKm),
    );
  }

  AppointmentCategory _mapCategoryDto(AppointmentCategoryResponseDto dto) {
    return AppointmentCategory(
      id: dto.id,
      name: dto.name,
      iconSlug: dto.iconSlug,
    );
  }

  RecommendedServiceEntity _mapRecommendationDto(
    RecommendedServiceResponseDto dto,
  ) {
    return RecommendedServiceEntity(
      id: dto.id,
      name: dto.name,
      description: dto.description,
      imageUrl: dto.imageUrl,
      price: dto.price,
      duration: dto.duration,
    );
  }

  /// Defensively converts the DTO's [Object?]
  /// distance into a [double?].
  double? _parseDistance(Object? raw) {
    if (raw == null) return null;
    if (raw is num) return raw.toDouble();
    if (raw is String) return double.tryParse(raw);
    return null;
  }
}

// ─── Mock implementation ──────────────────────────

/// Mock implementation returning fake data after a
/// simulated network delay.
class AppointmentRemoteDatasourceMock implements AppointmentRemoteDatasource {
  @override
  Future<List<AppointmentEntity>> getAppointments() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return kMockAppointments;
  }

  @override
  Future<List<AppointmentCategory>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return kMockAppointmentCategories;
  }

  @override
  Future<List<RecommendedServiceEntity>> getRecommendations() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return kMockRecommendedServices;
  }

  @override
  Future<AppointmentEntity?> getAppointmentById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return kMockAppointments.where((a) => a.id == id).firstOrNull;
  }
}

// ─── Provider ─────────────────────────────────────

/// Uses [AppEnvironment.useMock] to switch between
/// real and mock implementations at runtime.
final appointmentRemoteDatasourceProvider =
    Provider<AppointmentRemoteDatasource>((ref) {
      final useMock = AppEnvironment.current.useMock;

      if (useMock) {
        return AppointmentRemoteDatasourceMock();
      }

      final apiService = ref.read(apiServiceProvider);
      return AppointmentRemoteDatasourceImpl(apiService);
    });
