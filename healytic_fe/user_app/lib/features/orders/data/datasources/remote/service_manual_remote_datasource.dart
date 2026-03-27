// Remote data source for the service manual feature.
//
// 3-part pattern: abstract interface, implementation,
// and mock.

import 'package:user_app/features/orders/data/datasources/remote/service_manual_mock_data.dart';
import 'package:user_app/features/orders/domain/entities/service_manual.entity.dart';

// ─── Abstract interface ───────────────────────────

/// Contract for fetching service manual data.
abstract class ServiceManualRemoteDataSource {
  /// Fetches the service manual for [appointmentId].
  Future<ServiceManualEntity?> fetchManual(String appointmentId);
}

// ─── Real implementation ──────────────────────────

/// Production implementation backed by the API.
///
/// TODO: integrate with `user_openapi` when endpoint
/// is available.
class ServiceManualRemoteDataSourceImpl
    implements ServiceManualRemoteDataSource {
  @override
  Future<ServiceManualEntity?> fetchManual(String appointmentId) async {
    // TODO: call real API
    throw UnimplementedError('Real API not yet available');
  }
}

// ─── Mock implementation ──────────────────────────

/// Mock data source using in-memory data with a
/// simulated network delay.
class ServiceManualRemoteDataSourceMock
    implements ServiceManualRemoteDataSource {
  @override
  Future<ServiceManualEntity?> fetchManual(String appointmentId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return getMockServiceManual(appointmentId);
  }
}
