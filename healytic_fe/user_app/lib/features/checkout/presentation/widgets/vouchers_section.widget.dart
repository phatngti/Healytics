import 'package:flutter/material.dart';
import 'package:user_app/features/checkout/domain/entities/checkout.entity.dart';

/// Voucher rows (shop & platform) plus coin
/// redemption toggle.
class VouchersSection extends StatelessWidget {
  final VoucherInfo? shopVoucher;
  final VoucherInfo? platformVoucher;
  final int coinBalance;
  final int coinValue;
  final bool useCoins;
  final ValueChanged<bool> onCoinsToggled;

  const VouchersSection({
    super.key,
    this.shopVoucher,
    this.platformVoucher,
    required this.coinBalance,
    required this.coinValue,
    required this.useCoins,
    required this.onCoinsToggled,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          if (shopVoucher != null)
            _VoucherRow(
              icon: Icons.storefront,
              label: shopVoucher!.label,
              discount: shopVoucher!.discountAmount,
              isApplied: shopVoucher!.isApplied,
            ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          if (platformVoucher != null)
            _VoucherRow(
              icon: Icons.confirmation_number,
              label: platformVoucher!.label,
              discount: platformVoucher!.discountAmount,
              isApplied: platformVoucher!.isApplied,
            ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          _CoinRow(
            coinBalance: coinBalance,
            coinValue: coinValue,
            useCoins: useCoins,
            onToggled: onCoinsToggled,
          ),
        ],
      ),
    );
  }
}

class _VoucherRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final int discount;
  final bool isApplied;

  const _VoucherRow({
    required this.icon,
    required this.label,
    required this.discount,
    required this.isApplied,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        // TODO: open voucher selection
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            if (isApplied && discount > 0)
              Text(
                '-${_formatCurrency(discount)}',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              )
            else
              Text(
                'Select voucher',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(int amount) {
    final formatted = amount.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '${formatted}đ';
  }
}

class _CoinRow extends StatelessWidget {
  final int coinBalance;
  final int coinValue;
  final bool useCoins;
  final ValueChanged<bool> onToggled;

  const _CoinRow({
    required this.coinBalance,
    required this.coinValue,
    required this.useCoins,
    required this.onToggled,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final formatted = coinValue.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.monetization_on, color: Colors.amber.shade400, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Redeem Coins',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Balance: $coinBalance coins '
                  '(-${formatted}đ)',
                  style: textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: useCoins,
            onChanged: onToggled,
            activeColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
