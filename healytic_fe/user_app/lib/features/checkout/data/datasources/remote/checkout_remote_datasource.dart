import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/features/checkout/domain/entities/checkout.entity.dart';
import 'checkout_mock_data.dart';

/// Contract for fetching checkout data from a remote source.
abstract class CheckoutRemoteDatasource {
  /// Retrieves the full checkout payload.
  Future<CheckoutData> getCheckoutData();
}

/// Real API implementation (stub — not wired yet).
class CheckoutRemoteDatasourceImpl implements CheckoutRemoteDatasource {
  // TODO: inject OpenAPI client when backend endpoint exists.

  @override
  Future<CheckoutData> getCheckoutData() async {
    // Placeholder until the backend API is available.
    throw UnimplementedError('Real checkout API not implemented yet');
  }
}

/// Mock implementation returning fake data after a
/// simulated network delay.
class CheckoutRemoteDatasourceMock implements CheckoutRemoteDatasource {
  @override
  Future<CheckoutData> getCheckoutData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return kMockCheckoutData;
  }
}

/// Switches between real and mock implementations using
/// [StoreKey.mockFlag].
final checkoutRemoteDatasourceProvider = Provider<CheckoutRemoteDatasource>((
  ref,
) {
  final useMock = Store.tryGet(StoreKey.mockFlag) == 'true';

  if (useMock) {
    return CheckoutRemoteDatasourceMock();
  }

  return CheckoutRemoteDatasourceImpl();
});
