import 'package:common/utils/demensions.dart';
import 'package:common/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:user_app/features/cart/domain/entities/cart_item.entity.dart';
import 'package:user_app/features/cart/presentation/providers/cart.provider.dart';
import 'package:user_app/features/checkout/domain/entities/'
    'booking_params.entity.dart';
import 'package:user_app/features/checkout/presentation/providers/'
    'checkout.provider.dart';
import 'package:user_app/router/routes.dart';

import '../widgets/cart_app_bar.widget.dart';
import '../widgets/cart_empty_state.widget.dart';
import '../widgets/cart_header.widget.dart';
import '../widgets/cart_item_card.widget.dart';
import '../widgets/cart_summary_footer.widget.dart';

/// Main cart screen displaying the user's saved
/// service items.
///
/// Composes [CartAppBar], [CartHeader], a list of
/// [CartItemCard]s with [Dismissible] wrappers, and
/// a [CartSummaryFooter].
class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  String _searchQuery = '';

  /// Tracks which item is currently applying a
  /// coupon (for loading indicator).
  String? _couponLoadingId;

  void _handleCheckout(CartState cartState) {
    if (cartState.selectedCount == 0) return;

    final item = cartState.selectedItems.first;

    // Ensure the item has specialist and slot
    // data required by the checkout flow.
    if (!item.hasSpecialist || !item.hasSlotTime) {
      ToastContext.showToast(
        context,
        ToastType.warning,
        'Please select a specialist and time '
        'slot before checkout.',
      );
      return;
    }

    final timeLabel = DateFormat('hh:mm a')
        .format(item.slotTime!);

    final params = BookingParams(
      serviceId: item.serviceId,
      serviceName: item.serviceName,
      serviceImageUrl: item.serviceImageUrl,
      price: item.price,
      clinicName: item.clinicName,
      clinicAddress: item.clinicAddress,
      clinicImageUrl: item.clinicImageUrl,
      employeeId: item.specialistId!,
      employeeName: item.specialistName!,
      selectedDate: item.slotTime!,
      selectedTimeSlot: timeLabel,
    );

    ref
        .read(bookingParamsProvider.notifier)
        .set(params);
    const CheckoutRoute().push(context);
  }

  List<CartItemEntity> _filteredItems(List<CartItemEntity> items) {
    if (_searchQuery.isEmpty) return items;
    final query = _searchQuery.toLowerCase();
    return items
        .where((i) => i.serviceName.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final cartAsync = ref.watch(cartProvider);

    return Scaffold(
      appBar: CartAppBar(
        onSearchChanged: (query) {
          setState(() => _searchQuery = query);
        },
      ),
      body: cartAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(cartProvider),
        ),
        data: (cartState) {
          if (cartState.items.isEmpty) {
            return CartEmptyState(
              onExplore: () => const HomeRoute().go(context),
            );
          }

          return _CartBody(
            cartState: cartState,
            filteredItems: _filteredItems(cartState.items),
            couponLoadingId: _couponLoadingId,
            onToggleSelection: (id) =>
                ref.read(cartProvider.notifier)
                    .toggleItemSelection(id),
            onDelete: (id) =>
                ref.read(cartProvider.notifier)
                    .removeItem(id),
            onApplyCoupon: (id, code) async {
              setState(() {
                _couponLoadingId = id;
              });
              try {
                await ref
                    .read(cartProvider.notifier)
                    .applyCoupon(cartItemId: id, couponCode: code);
              } finally {
                if (mounted) {
                  setState(() {
                    _couponLoadingId = null;
                  });
                }
              }
            },
            onRemoveCoupon: (id) async {
              setState(() {
                _couponLoadingId = id;
              });
              try {
                await ref.read(cartProvider.notifier).removeCoupon(id);
              } finally {
                if (mounted) {
                  setState(() {
                    _couponLoadingId = null;
                  });
                }
              }
            },
            onRefresh: () async {
              ref.invalidate(cartProvider);
              // Wait for the re-fetch.
              await ref.read(cartProvider.future);
            },
          );
        },
      ),
      bottomNavigationBar: cartAsync.maybeWhen(
        data: (cartState) => cartState.items.isNotEmpty
            ? CartSummaryFooter(
                cartState: cartState,
                onCheckout: () => _handleCheckout(cartState),
              )
            : null,
        orElse: () => null,
      ),
    );
  }
}

/// Scrollable cart body with header and item list.
///
/// Uses [ConsumerWidget] to access per-item voucher
/// providers for scoped voucher loading.
class _CartBody extends ConsumerWidget {
  final CartState cartState;
  final List<CartItemEntity> filteredItems;
  final String? couponLoadingId;
  final ValueChanged<String> onToggleSelection;
  final ValueChanged<String> onDelete;
  final void Function(String id, String code) onApplyCoupon;
  final ValueChanged<String> onRemoveCoupon;
  final Future<void> Function() onRefresh;

  const _CartBody({
    required this.cartState,
    required this.filteredItems,
    this.couponLoadingId,
    required this.onToggleSelection,
    required this.onDelete,
    required this.onApplyCoupon,
    required this.onRemoveCoupon,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hPad = AppDimens.horizontalPadding(context);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(
          hPad,
          0,
          hPad,
          AppDimens.bottomScrollPadding(context),
        ),
        itemCount: filteredItems.length + 1,
        itemBuilder: (context, index) {
          // Header row at index 0
          if (index == 0) {
            return CartHeader(
              itemCount: cartState.itemCount,
            );
          }

          final itemIndex = index - 1;
          final item = filteredItems[itemIndex];
          final isSelected = cartState.selectedIds.contains(item.id);

          // Watch per-item vouchers.
          final vouchersAsync = ref.watch(
            availableVouchersForItemProvider(
              serviceId: item.serviceId,
              clinicId: item.clinicId,
            ),
          );

          // Dim non-selected items when a
          // selection exists.
          final hasSelection =
              cartState.hasSelection;
          final isDimmed =
              hasSelection && !isSelected;

          return Padding(
            padding: EdgeInsets.only(
              bottom: AppDimens.spaceLg,
            ),
            child: _DimmedCartItem(
              isDimmed: isDimmed,
              child: Dismissible(
                key: ValueKey(item.id),
                direction:
                    DismissDirection.endToStart,
                onDismissed: (_) =>
                    onDelete(item.id),
                background: _SwipeBackground(),
                child: CartItemCard(
                  item: item,
                  isSelected: isSelected,
                  onToggleSelection: () =>
                      onToggleSelection(item.id),
                  onDelete: () =>
                      onDelete(item.id),
                  onApplyCoupon: (code) =>
                      onApplyCoupon(
                    item.id,
                    code,
                  ),
                  onRemoveCoupon: () =>
                      onRemoveCoupon(item.id),
                  isCouponLoading:
                      couponLoadingId == item.id,
                  availableVouchers:
                      vouchersAsync.value ?? [],
                  isVouchersLoading:
                      vouchersAsync.isLoading,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Dims a cart item with reduced opacity and a
/// translucent surface overlay when [isDimmed] is
/// `true`. The child remains tappable so users can
/// switch selection by tapping the radio.
class _DimmedCartItem extends StatelessWidget {
  final bool isDimmed;
  final Widget child;

  const _DimmedCartItem({
    required this.isDimmed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      opacity: isDimmed ? 0.45 : 1.0,
      child: Stack(
        children: [
          child,
          if (isDimmed)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface
                        .withValues(alpha: 0.3),
                    borderRadius:
                        AppDimens.radiusMediumSmall,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Red swipe-to-delete background.
class _SwipeBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: AppDimens.spaceXxl),
      decoration: BoxDecoration(
        color: colorScheme.error.withValues(alpha: 0.1),
        borderRadius: AppDimens.radiusMediumSmall,
      ),
      child: Icon(
        Icons.delete_sweep,
        color: colorScheme.error,
        size: AppDimens.iconXxl,
      ),
    );
  }
}

/// Error state with retry button.
class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimens.horizontalPadding(context)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: AppDimens.iconXxl,
              color: colorScheme.error,
            ),
            AppDimens.verticalMedium,
            Text(
              'Failed to load cart',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppDimens.verticalSmall,
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            AppDimens.verticalLarge,
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
