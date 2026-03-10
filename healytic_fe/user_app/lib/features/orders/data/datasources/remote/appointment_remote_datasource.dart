import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';

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

/// Real API implementation (placeholder).
class AppointmentRemoteDatasourceImpl implements AppointmentRemoteDatasource {
  @override
  Future<List<AppointmentEntity>> getAppointments() {
    throw UnimplementedError('Real API not yet connected');
  }

  @override
  Future<List<AppointmentCategory>> getCategories() {
    throw UnimplementedError('Real API not yet connected');
  }

  @override
  Future<List<RecommendedServiceEntity>> getRecommendations() {
    throw UnimplementedError('Real API not yet connected');
  }

  @override
  Future<AppointmentEntity?> getAppointmentById(String id) {
    throw UnimplementedError('Real API not yet connected');
  }
}

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

/// Uses [StoreKey.mockFlag] to switch between real and
/// mock implementations at runtime.
final appointmentRemoteDatasourceProvider =
    Provider<AppointmentRemoteDatasource>((ref) {
      final useMock = Store.tryGet(StoreKey.mockFlag) == 'true';

      if (useMock) {
        return AppointmentRemoteDatasourceMock();
      }

      return AppointmentRemoteDatasourceImpl();
    });
