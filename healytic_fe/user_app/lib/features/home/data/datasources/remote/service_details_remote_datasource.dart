import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/features/home/domain/entities/service_details.entity.dart';

import 'service_details_mock_data.dart';

/// Contract for fetching service detail data from a remote source.
abstract class ServiceDetailsRemoteDatasource {
  /// Loads full details for the service identified by [serviceId].
  Future<ServiceDetailsEntity> getServiceDetails(String serviceId);
}

/// Real implementation — replace body with actual API calls when
/// the backend endpoint is available.
class ServiceDetailsRemoteDatasourceImpl
    implements ServiceDetailsRemoteDatasource {
  @override
  Future<ServiceDetailsEntity> getServiceDetails(String serviceId) async {
    // TODO: replace with real API call
    // e.g. final response = await _api.getServiceDetails(serviceId);
    throw UnimplementedError('Real service details API not yet implemented');
  }
}

/// Mock implementation that returns fake data after a simulated
/// network delay, useful for development and testing.
class ServiceDetailsRemoteDatasourceMock
    implements ServiceDetailsRemoteDatasource {
  @override
  Future<ServiceDetailsEntity> getServiceDetails(String serviceId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return kMockServiceDetailsMap[serviceId] ?? kMockServiceDetails;
  }
}

/// Uses [StoreKey.mockFlag] to switch between real and mock
/// implementations at runtime.
final serviceDetailsRemoteDatasourceProvider =
    Provider<ServiceDetailsRemoteDatasource>((ref) {
      final useMock = Store.tryGet(StoreKey.mockFlag) == 'true';

      if (useMock) {
        return ServiceDetailsRemoteDatasourceMock();
      }

      return ServiceDetailsRemoteDatasourceImpl();
    });
