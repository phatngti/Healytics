import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/cart/domain/entities/cart_item.entity.dart';
import 'package:user_app/features/cart/domain/entities/voucher.entity.dart';

import 'cart_mock_data.dart';

// ────────────────────────────────────────────────────
// Abstract Interface
// ────────────────────────────────────────────────────

/// Contract for cart data operations.
abstract class CartRemoteDataSource {
  /// Fetches all cart items.
  Future<List<CartItemEntity>> getCartItems();

  /// Adds a service to the cart.
  Future<CartItemEntity> addItem({required String serviceId});

  /// Removes an item by its cart item ID.
  Future<void> removeItem(String cartItemId);

  /// Applies a coupon code to a specific item.
  Future<CartItemEntity> applyCoupon({
    required String cartItemId,
    required String couponCode,
  });

  /// Removes a coupon from a specific item.
  Future<CartItemEntity> removeCoupon(String cartItemId);

  /// Fetches vouchers available for a specific
  /// service and clinic combination.
  Future<List<VoucherEntity>> getAvailableVouchers({
    required String serviceId,
    required String clinicId,
  });

  /// Clears all items from the cart.
  Future<void> clearCart();
}

// ────────────────────────────────────────────────────
// Real Implementation
// ────────────────────────────────────────────────────

/// Real API implementation backed by OpenAPI clients.
///
/// Endpoints are not yet available — throws
/// [UnimplementedError] until backend delivers the
/// cart API.
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  static final _log = Logger('CartRemoteDataSourceImpl');

  final ApiService _apiService;

  const CartRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<CartItemEntity>> getCartItems() async {
    _log.info('GET /cart — not implemented yet');
    // TODO: Wire to generated API client
    // final response = await _apiService
    //     .userCartApi.cartControllerGetItems();
    // return response.map(_mapDto).toList();
    throw UnimplementedError('Cart API not implemented yet');
  }

  @override
  Future<CartItemEntity> addItem({required String serviceId}) async {
    _log.info('POST /cart — not implemented yet');
    throw UnimplementedError('Cart API not implemented yet');
  }

  @override
  Future<void> removeItem(String cartItemId) async {
    _log.info('DELETE /cart/$cartItemId — not implemented');
    throw UnimplementedError('Cart API not implemented yet');
  }

  @override
  Future<CartItemEntity> applyCoupon({
    required String cartItemId,
    required String couponCode,
  }) async {
    _log.info(
      'POST /cart/$cartItemId/coupon — '
      'not implemented',
    );
    throw UnimplementedError('Cart API not implemented yet');
  }

  @override
  Future<CartItemEntity> removeCoupon(String cartItemId) async {
    _log.info(
      'DELETE /cart/$cartItemId/coupon — '
      'not implemented',
    );
    throw UnimplementedError('Cart API not implemented yet');
  }

  @override
  Future<List<VoucherEntity>> getAvailableVouchers({
    required String serviceId,
    required String clinicId,
  }) async {
    _log.info(
      'GET /vouchers?service=$serviceId'
      '&clinic=$clinicId — not implemented',
    );
    throw UnimplementedError('Voucher API not implemented yet');
  }

  @override
  Future<void> clearCart() async {
    _log.info('DELETE /cart — not implemented');
    throw UnimplementedError('Cart API not implemented yet');
  }
}

// ────────────────────────────────────────────────────
// Mock Implementation
// ────────────────────────────────────────────────────

/// Mock implementation using an in-memory list seeded
/// from [kMockCartItems].
///
/// Simulates network delay for all operations.
class CartRemoteDataSourceMock implements CartRemoteDataSource {
  /// Mutable in-memory cart state.
  final List<CartItemEntity> _items = [...kMockCartItems];

  int _nextId = 100;

  @override
  Future<List<CartItemEntity>> getCartItems() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_items);
  }

  @override
  Future<CartItemEntity> addItem({required String serviceId}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Simulate creating a new cart item with
    // service details that would come from backend.
    final newItem = CartItemEntity(
      id: 'cart-${_nextId++}',
      serviceId: serviceId,
      serviceName: 'Service $serviceId',
      serviceImageUrl: 'https://picsum.photos/seed/$serviceId/200',
      price: '350.000đ',
      priceAmount: 350000,
      clinicId: 'clinic-001',
      clinicName: 'Healytics Clinic',
      clinicAddress: '456 Nguyen Hue, Q1, HCM',
      clinicImageUrl: 'https://picsum.photos/seed/clinic/100',
      createdAt: DateTime.now(),
    );

    _items.add(newItem);
    return newItem;
  }

  @override
  Future<void> removeItem(String cartItemId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.removeWhere((i) => i.id == cartItemId);
  }

  @override
  Future<CartItemEntity> applyCoupon({
    required String cartItemId,
    required String couponCode,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _items.indexWhere((i) => i.id == cartItemId);
    if (index == -1) {
      throw Exception('Cart item not found: $cartItemId');
    }

    // Simulate a 5% discount for any coupon code.
    final item = _items[index];
    final discountPercent = 5;
    final discountAmount = (item.priceAmount * discountPercent) ~/ 100;

    final updated = item.copyWith(
      couponCode: couponCode,
      couponDiscountPercent: discountPercent,
      couponDiscountAmount: discountAmount,
    );

    _items[index] = updated;
    return updated;
  }

  @override
  Future<CartItemEntity> removeCoupon(String cartItemId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _items.indexWhere((i) => i.id == cartItemId);
    if (index == -1) {
      throw Exception('Cart item not found: $cartItemId');
    }

    // Clear coupon by creating a new instance
    // without coupon fields.
    final item = _items[index];
    final updated = CartItemEntity(
      id: item.id,
      serviceId: item.serviceId,
      serviceName: item.serviceName,
      serviceImageUrl: item.serviceImageUrl,
      price: item.price,
      priceAmount: item.priceAmount,
      clinicId: item.clinicId,
      clinicName: item.clinicName,
      clinicAddress: item.clinicAddress,
      clinicImageUrl: item.clinicImageUrl,
      specialistId: item.specialistId,
      specialistName: item.specialistName,
      specialistPosition: item.specialistPosition,
      slotTime: item.slotTime,
      createdAt: item.createdAt,
    );

    _items[index] = updated;
    return updated;
  }

  @override
  Future<List<VoucherEntity>> getAvailableVouchers({
    required String serviceId,
    required String clinicId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Filter vouchers matching the service/clinic
    // or global vouchers (null serviceId/clinicId).
    return kMockVouchers.where((v) {
      final matchesService = v.serviceId == null || v.serviceId == serviceId;
      final matchesClinic = v.clinicId == null || v.clinicId == clinicId;
      return matchesService && matchesClinic && v.isValid;
    }).toList();
  }

  @override
  Future<void> clearCart() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.clear();
  }
}

// ────────────────────────────────────────────────────
// Provider
// ────────────────────────────────────────────────────

/// Switches between real and mock implementations
/// using [AppEnvironment.useMock].
final cartRemoteDatasourceProvider = Provider<CartRemoteDataSource>((ref) {
  if (AppEnvironment.current.useMock) {
    return CartRemoteDataSourceMock();
  }

  return CartRemoteDataSourceImpl(ref.read(apiServiceProvider));
});
