import 'package:user_app/features/cart/domain/entities/cart_item.entity.dart';
import 'package:user_app/features/cart/domain/entities/voucher.entity.dart';

/// Abstract repository contract for cart operations.
///
/// All operations are backed by the remote API.
/// Pure Dart — no Flutter or Riverpod imports.
abstract class CartRepository {
  /// Fetches all cart items from the backend.
  Future<List<CartItemEntity>> getCartItems();

  /// Adds a scheduled service to the cart by its ID.
  ///
  /// Returns the created [CartItemEntity] from the
  /// backend response.
  Future<CartItemEntity> addItem({
    required String serviceId,
    String? employeeId,
    required DateTime timeSlot,
    bool autoAssignStaff = false,
  });

  /// Removes an item by its cart item ID.
  Future<void> removeItem(String cartItemId);

  /// Applies a coupon code to a specific cart item.
  ///
  /// Returns the updated [CartItemEntity] with the
  /// discount information populated.
  Future<CartItemEntity> applyCoupon({
    required String cartItemId,
    required String couponCode,
  });

  /// Removes a coupon from a specific cart item.
  ///
  /// Returns the updated [CartItemEntity] with coupon
  /// fields cleared.
  Future<CartItemEntity> removeCoupon(String cartItemId);

  /// Fetches available vouchers for a given service
  /// and clinic combination.
  Future<List<VoucherEntity>> getAvailableVouchers({
    required String serviceId,
    required String clinicId,
  });

  /// Clears all items from the cart.
  Future<void> clearCart();
}
