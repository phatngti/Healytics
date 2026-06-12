import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/cart/data/provider/cart.provider.dart';
import 'package:user_app/features/cart/domain/entities/cart_item.entity.dart';
import 'package:user_app/features/cart/domain/entities/voucher.entity.dart';

part 'cart.provider.g.dart';

/// Presentation state for the cart screen.
///
/// Items are fetched from the backend. Selection
/// is single-item only for checkout.
class CartState {
  /// Creates a cart state.
  const CartState({this.items = const [], this.selectedIds = const {}});

  /// All cart items from the backend.
  final List<CartItemEntity> items;

  /// ID of the currently selected item (at most one).
  final Set<String> selectedIds;

  /// Total number of items in the cart.
  int get itemCount => items.length;

  /// Items currently selected for checkout.
  List<CartItemEntity> get selectedItems =>
      items.where((i) => selectedIds.contains(i.id)).toList();

  /// Number of selected items (0 or 1).
  int get selectedCount => selectedIds.length;

  /// Whether an item is selected for checkout.
  bool get hasSelection => selectedIds.isNotEmpty;

  /// Subtotal of selected items (before discounts).
  int get subtotal =>
      selectedItems.fold(0, (sum, item) => sum + item.priceAmount);

  /// Total coupon discount across selected items.
  int get totalDiscount => selectedItems.fold(
    0,
    (sum, item) => sum + (item.couponDiscountAmount ?? 0),
  );

  /// Final payable total after discounts.
  int get total => subtotal - totalDiscount;

  /// Creates a copy with overridden fields.
  CartState copyWith({List<CartItemEntity>? items, Set<String>? selectedIds}) {
    return CartState(
      items: items ?? this.items,
      selectedIds: selectedIds ?? this.selectedIds,
    );
  }
}

/// Global cart state notifier.
///
/// Uses `keepAlive: true` so the cart badge count
/// survives navigation and the state persists while
/// the app is open. Data is re-fetched from the
/// backend on [build].
@Riverpod(keepAlive: true)
class CartNotifier extends _$CartNotifier {
  static final _log = Logger('CartNotifier');

  @override
  Future<CartState> build() async {
    final repo = ref.read(cartRepositoryProvider);
    final items = await repo.getCartItems();
    // Start with no selection — user picks one.
    return CartState(items: items);
  }

  /// Adds a scheduled service to the cart.
  ///
  /// Re-fetches the entire cart from backend to stay
  /// in sync.
  Future<void> addItem({
    required String serviceId,
    required String employeeId,
    required DateTime timeSlot,
  }) async {
    try {
      final repo = ref.read(cartRepositoryProvider);
      await repo.addItem(
        serviceId: serviceId,
        employeeId: employeeId,
        timeSlot: timeSlot,
      );
      if (!ref.mounted) return;
      ref.invalidateSelf();
    } catch (e, st) {
      _log.severe('Failed to add item', e, st);
      rethrow;
    }
  }

  /// Removes an item with optimistic UI update.
  ///
  /// Removes immediately from state, then syncs
  /// with the backend. Rolls back on error.
  Future<void> removeItem(String cartItemId) async {
    final current = state.value;

    // Optimistic removal when cart data is loaded.
    if (current != null) {
      state = AsyncData(
        current.copyWith(
          items: current.items.where((i) => i.id != cartItemId).toList(),
          selectedIds: current.selectedIds.difference({cartItemId}),
        ),
      );
    }

    try {
      final repo = ref.read(cartRepositoryProvider);
      await repo.removeItem(cartItemId);
      if (current == null && ref.mounted) {
        ref.invalidateSelf();
      }
    } catch (e, st) {
      _log.severe('Failed to remove item', e, st);
      if (current != null && ref.mounted) {
        state = AsyncData(current);
      }
      rethrow;
    }
  }

  /// Selects a single item for checkout.
  ///
  /// Only one item can be selected at a time.
  /// Tapping the already-selected item deselects it.
  void toggleItemSelection(String cartItemId) {
    final current = state.value;
    if (current == null) return;

    final isAlreadySelected = current.selectedIds.contains(cartItemId);

    final newIds = isAlreadySelected ? <String>{} : {cartItemId};

    state = AsyncData(current.copyWith(selectedIds: newIds));
  }

  /// Applies a coupon code to a specific item.
  ///
  /// Calls the backend and updates the local item
  /// with discount information.
  Future<void> applyCoupon({
    required String cartItemId,
    required String couponCode,
  }) async {
    try {
      final repo = ref.read(cartRepositoryProvider);
      final updated = await repo.applyCoupon(
        cartItemId: cartItemId,
        couponCode: couponCode,
      );
      if (!ref.mounted) return;

      _replaceItem(cartItemId, updated);
    } catch (e, st) {
      _log.severe('Failed to apply coupon', e, st);
      rethrow;
    }
  }

  /// Removes a coupon from a specific item.
  Future<void> removeCoupon(String cartItemId) async {
    try {
      final repo = ref.read(cartRepositoryProvider);
      final updated = await repo.removeCoupon(cartItemId);
      if (!ref.mounted) return;

      _replaceItem(cartItemId, updated);
    } catch (e, st) {
      _log.severe('Failed to remove coupon', e, st);
      rethrow;
    }
  }

  /// Clears the entire cart.
  Future<void> clearCart() async {
    try {
      final repo = ref.read(cartRepositoryProvider);
      await repo.clearCart();
      if (!ref.mounted) return;

      state = const AsyncData(CartState());
    } catch (e, st) {
      _log.severe('Failed to clear cart', e, st);
      rethrow;
    }
  }

  /// Removes items that were successfully checked out.
  void removeCheckedOutItems(List<String> serviceIds) {
    final current = state.value;
    if (current == null) return;

    final remaining = current.items
        .where((i) => !serviceIds.contains(i.serviceId))
        .toList();

    final remainingIds = remaining.map((i) => i.id).toSet();

    state = AsyncData(
      current.copyWith(
        items: remaining,
        selectedIds: current.selectedIds.intersection(remainingIds),
      ),
    );
  }

  /// Replaces a single item in the list by ID.
  void _replaceItem(String cartItemId, CartItemEntity updated) {
    final current = state.value;
    if (current == null) return;

    final updatedItems = current.items.map((item) {
      return item.id == cartItemId ? updated : item;
    }).toList();

    state = AsyncData(current.copyWith(items: updatedItems));
  }
}

/// Lightweight provider for the cart badge count.
///
/// Used by [HomeHeader] to show the cart icon badge
/// without pulling the full [CartState].
@riverpod
int cartBadgeCount(Ref ref) {
  final cartAsync = ref.watch(cartProvider);
  return cartAsync.value?.itemCount ?? 0;
}

/// Fetches vouchers available for a specific
/// service and clinic combination.
///
/// Scoped per item so each cart entry shows
/// only relevant vouchers in its picker.
@riverpod
Future<List<VoucherEntity>> availableVouchersForItem(
  Ref ref, {
  required String serviceId,
  required String clinicId,
}) async {
  final repo = ref.read(cartRepositoryProvider);
  return repo.getAvailableVouchers(serviceId: serviceId, clinicId: clinicId);
}
