import 'package:user_app/features/cart/data/datasources/remote/cart_remote_datasource.dart';
import 'package:user_app/features/cart/domain/entities/cart_item.entity.dart';
import 'package:user_app/features/cart/domain/entities/voucher.entity.dart';
import 'package:user_app/features/cart/domain/repositories/cart.repository.dart';

/// Concrete [CartRepository] that delegates all
/// operations to the [CartRemoteDataSource].
class CartRepositoryImpl implements CartRepository {
  /// Creates a repository backed by the given
  /// remote datasource.
  const CartRepositoryImpl({required CartRemoteDataSource remoteDatasource})
    : _remoteDatasource = remoteDatasource;

  final CartRemoteDataSource _remoteDatasource;

  @override
  Future<List<CartItemEntity>> getCartItems() =>
      _remoteDatasource.getCartItems();

  @override
  Future<CartItemEntity> addItem({
    required String serviceId,
    String? employeeId,
    required DateTime timeSlot,
    bool autoAssignStaff = false,
  }) => _remoteDatasource.addItem(
    serviceId: serviceId,
    employeeId: employeeId,
    timeSlot: timeSlot,
    autoAssignStaff: autoAssignStaff,
  );

  @override
  Future<void> removeItem(String cartItemId) =>
      _remoteDatasource.removeItem(cartItemId);

  @override
  Future<CartItemEntity> applyCoupon({
    required String cartItemId,
    required String couponCode,
  }) => _remoteDatasource.applyCoupon(
    cartItemId: cartItemId,
    couponCode: couponCode,
  );

  @override
  Future<CartItemEntity> removeCoupon(String cartItemId) =>
      _remoteDatasource.removeCoupon(cartItemId);

  @override
  Future<List<VoucherEntity>> getAvailableVouchers({
    required String serviceId,
    required String clinicId,
  }) => _remoteDatasource.getAvailableVouchers(
    serviceId: serviceId,
    clinicId: clinicId,
  );

  @override
  Future<void> clearCart() => _remoteDatasource.clearCart();
}
