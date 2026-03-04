import 'package:flutter/material.dart';

/// Payment details breakdown showing subtotal,
/// discounts, and total.
class PaymentDetailsSection extends StatelessWidget {
  final int subtotal;
  final int shopDiscount;
  final int platformVoucher;
  final int coinsUsed;
  final bool useCoins;

  const PaymentDetailsSection({
    super.key,
    required this.subtotal,
    required this.shopDiscount,
    required this.platformVoucher,
    required this.coinsUsed,
    required this.useCoins,
  });

  int get _total {
    final coins = useCoins ? coinsUsed : 0;
    return subtotal - shopDiscount - platformVoucher - coins;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Details',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          _buildRow(context, 'Subtotal', _formatCurrency(subtotal)),
          const SizedBox(height: 12),
          _buildRow(
            context,
            'Shop Discount',
            '-${_formatCurrency(shopDiscount)}',
            isDiscount: true,
          ),
          const SizedBox(height: 12),
          _buildRow(
            context,
            'Platform Voucher',
            '-${_formatCurrency(platformVoucher)}',
            isDiscount: true,
          ),
          if (useCoins) ...[
            const SizedBox(height: 12),
            _buildRow(
              context,
              'Coins Used',
              '-${_formatCurrency(coinsUsed)}',
              isDiscount: true,
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: colorScheme.outlineVariant),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Payment',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                _formatCurrency(_total),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '(VAT Included)',
              style: textTheme.labelSmall?.copyWith(
                fontSize: 10,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    String label,
    String value, {
    bool isDiscount = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: isDiscount ? colorScheme.error : colorScheme.onSurface,
          ),
        ),
      ],
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
