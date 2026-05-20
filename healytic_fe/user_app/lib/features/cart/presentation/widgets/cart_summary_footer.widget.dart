import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/features/cart/presentation/providers/cart.provider.dart';
import 'package:user_app/theme/app_theme.dart';

/// Fixed bottom summary bar for the cart screen.
///
/// Displays subtotal, discount,
/// total amount, and a "Checkout Now" CTA button.
class CartSummaryFooter extends StatelessWidget {
  /// Cart state containing pricing calculations.
  final CartState cartState;

  /// Callback when "Checkout Now" is tapped.
  final VoidCallback? onCheckout;

  const CartSummaryFooter({
    super.key,
    required this.cartState,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hPad = AppDimens.horizontalPadding(context);
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        hPad,
        AppDimens.spaceXl,
        hPad,
        AppDimens.spaceXl + bottomPad,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SummaryRows(cartState: cartState),
          SizedBox(height: AppDimens.spaceXl),
          _CheckoutButton(
            onCheckout: onCheckout,
            isEnabled: cartState.selectedCount > 0,
          ),
        ],
      ),
    );
  }
}

/// Price breakdown rows.
class _SummaryRows extends StatelessWidget {
  final CartState cartState;

  const _SummaryRows({required this.cartState});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>();
    final successColor = semanticColors?.success ?? Colors.green;

    return Column(
      children: [
        // Subtotal
        _PriceRow(
          label: 'Subtotal',
          value: _formatCurrency(cartState.subtotal),
        ),
        SizedBox(height: AppDimens.spaceSmMd),
        // Discount
        if (cartState.totalDiscount > 0) ...[
          _DiscountRow(
            discount: cartState.totalDiscount,
            successColor: successColor,
          ),
          SizedBox(height: AppDimens.spaceSmMd),
        ],
        // Divider
        Padding(
          padding: const EdgeInsets.only(top: AppDimens.spaceMd),
          child: Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        SizedBox(height: AppDimens.spaceMd),
        // Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Amount',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              _formatCurrency(cartState.total),
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// A single label–value price row.
class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool valueBold;

  const _PriceRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.valueBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: textTheme.bodySmall?.copyWith(
            fontWeight: valueBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

/// Discount row showing the savings amount.
class _DiscountRow extends StatelessWidget {
  final int discount;
  final Color successColor;

  const _DiscountRow({required this.discount, required this.successColor});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'Discount',
              style: textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        Text(
          '-${_formatCurrency(discount)}',
          style: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: successColor,
          ),
        ),
      ],
    );
  }
}

/// Full-width "Checkout Now" button.
class _CheckoutButton extends StatelessWidget {
  final VoidCallback? onCheckout;
  final bool isEnabled;

  const _CheckoutButton({required this.onCheckout, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      height: AppDimens.touchTarget,
      child: FilledButton(
        key: keys.cartPage.checkoutButton,
        onPressed: isEnabled ? onCheckout : null,
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.primary.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimens.radiusMediumSmall,
          ),
          elevation: 4,
          shadowColor: colorScheme.primary.withValues(alpha: 0.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Symbols.lock, size: AppDimens.iconMd),
            SizedBox(width: AppDimens.spaceSm),
            Text(
              'CHECKOUT NOW',
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Formats VND amount with thousand separators.
String _formatCurrency(int amount) {
  final formatted = amount.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );
  return '$formattedđ';
}
