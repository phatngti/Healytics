import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/clinic_info/domain/entities/clinic_info.entity.dart';
import 'package:user_app/features/clinic_info/domain/entities/clinic_product.entity.dart';

import 'clinic_info_mock_data.dart';
import 'clinic_products_mock_data.dart';

/// Contract for fetching clinic detail data from a
/// remote source.
abstract class ClinicInfoRemoteDatasource {
  /// `GET /health-services/clinics/:id/info`
  Future<ClinicInfoEntity> getClinicInfo(String clinicId);

  /// `GET /health-services/clinics/:id/products`
  Future<ClinicProductsData> getClinicProducts(String clinicId);
}

// ─────────────────────────────────────────────────────
// Real implementation
// ─────────────────────────────────────────────────────

// TODO(clinic): Replace with real mapping once
// OpenAPI client is regenerated from the updated
// backend spec that includes the
// `GET /health-services/clinics/:id/info` endpoint.

/// Calls the backend clinic info endpoint and maps
/// the response DTO to a domain entity.
///
/// Currently throws [UnimplementedError] until the
/// OpenAPI client is regenerated.
class ClinicInfoRemoteDatasourceImpl implements ClinicInfoRemoteDatasource {
  const ClinicInfoRemoteDatasourceImpl(this._apiService);

  // ignore: unused_field
  final ApiService _apiService;

  @override
  Future<ClinicInfoEntity> getClinicInfo(String clinicId) async {
    // TODO(clinic): Call generated API method once
    // available after OpenAPI regeneration.
    throw UnimplementedError(
      'Regenerate OpenAPI client to enable real '
      'clinic info endpoint.',
    );
  }

  @override
  Future<ClinicProductsData> getClinicProducts(String clinicId) async {
    // TODO(clinic): Call generated API method once
    // available after OpenAPI regeneration.
    throw UnimplementedError('Regenerate OpenAPI client for clinic products.');
  }
}

// ─────────────────────────────────────────────────────
// Mock implementation
// ─────────────────────────────────────────────────────

/// Returns fake data after a simulated network delay.
class ClinicInfoRemoteDatasourceMock implements ClinicInfoRemoteDatasource {
  @override
  Future<ClinicInfoEntity> getClinicInfo(String clinicId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return kMockClinicInfoMap[clinicId] ?? kMockClinicInfo;
  }

  @override
  Future<ClinicProductsData> getClinicProducts(String clinicId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const ClinicProductsData(
      categories: kMockClinicProductCategories,
      products: kMockClinicProducts,
    );
  }
}

// ─────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────

/// Uses [AppEnvironment.useMock] to switch between
/// real and mock implementations at runtime.
final clinicInfoRemoteDatasourceProvider = Provider<ClinicInfoRemoteDatasource>(
  (ref) {
    if (AppEnvironment.current.useMock) {
      return ClinicInfoRemoteDatasourceMock();
    }
    final apiService = ref.read(apiServiceProvider);
    return ClinicInfoRemoteDatasourceImpl(apiService);
  },
);
