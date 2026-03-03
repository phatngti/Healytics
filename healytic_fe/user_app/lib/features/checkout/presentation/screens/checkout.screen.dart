import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/checkout/presentation/providers/checkout.provider.dart';
import 'package:user_app/features/checkout/presentation/widgets/checkout_bottom_bar.widget.dart';

import 'package:user_app/features/checkout/presentation/widgets/order_items_section.widget.dart';
import 'package:user_app/features/checkout/presentation/widgets/payment_details_section.widget.dart';
import 'package:user_app/features/checkout/presentation/widgets/payment_method_section.widget.dart';
import 'package:user_app/features/checkout/presentation/widgets/vouchers_section.widget.dart';

/// Main checkout screen composing all section widgets.
class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutAsync = ref.watch(checkoutProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'Checkout',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        backgroundColor: colorScheme.surface.withValues(alpha: 0.9),
      ),
      body: checkoutAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (state) => _CheckoutBody(state: state),
      ),
    );
  }
}

class _CheckoutBody extends ConsumerWidget {
  final CheckoutState state;

  const _CheckoutBody({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = state.checkoutData;
    final summary = data.summary;
    final notifier = ref.read(checkoutProvider.notifier);

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 140),
          children: [
            OrderItemsSection(items: data.items),
            const SizedBox(height: 24),
            VouchersSection(
              shopVoucher: data.shopVoucher,
              platformVoucher: data.platformVoucher,
              coinBalance: data.coinBalance,
              coinValue: data.coinValue,
              useCoins: state.useCoins,
              onCoinsToggled: notifier.toggleCoins,
            ),
            const SizedBox(height: 24),
            PaymentMethodSection(
              methods: data.paymentMethods,
              selectedType: state.selectedPayment,
              onSelected: notifier.selectPaymentMethod,
            ),
            const SizedBox(height: 24),
            PaymentDetailsSection(
              subtotal: summary.subtotal,
              shopDiscount: summary.shopDiscount,
              platformVoucher: summary.platformVoucher,
              coinsUsed: summary.coinsUsed,
              useCoins: state.useCoins,
            ),
            const SizedBox(height: 24),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: CheckoutBottomBar(
            total: state.effectiveTotal,
            saved: state.effectiveSaved,
            onConfirm: () {
              // TODO: handle payment confirmation
            },
          ),
        ),
      ],
    );
  }
}
