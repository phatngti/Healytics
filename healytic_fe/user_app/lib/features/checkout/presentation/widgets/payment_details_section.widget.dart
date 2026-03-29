import 'package:common/utils/demensions.dart';
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
    return subtotal -
        shopDiscount -
        platformVoucher -
        coins;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final pad = AppDimens.cardPadding(context);
    final radius = AppDimens.cardRadius(context);

    return Container(
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: colorScheme.outlineVariant
              .withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow
                .withValues(alpha: 0.08),
            blurRadius: AppDimens.spaceMd,
            offset: const Offset(
              0,
              AppDimens.spaceXxs,
            ),
          ),
          BoxShadow(
            color: colorScheme.shadow
                .withValues(alpha: 0.04),
            blurRadius: AppDimens.spaceXxl,
            offset: const Offset(
              0,
              AppDimens.spaceXs + 2,
            ),
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
          AppDimens.verticalMedium,
          _DetailRow(
            label: 'Subtotal',
            value: _formatCurrency(subtotal),
          ),
          AppDimens.verticalMediumSmall,
          _DetailRow(
            label: 'Shop Discount',
            value:
                '-${_formatCurrency(shopDiscount)}',
            isDiscount: true,
          ),
          AppDimens.verticalMediumSmall,
          _DetailRow(
            label: 'Platform Voucher',
            value:
                '-${_formatCurrency(platformVoucher)}',
            isDiscount: true,
          ),
          if (useCoins) ...[
            AppDimens.verticalMediumSmall,
            _DetailRow(
              label: 'Coins Used',
              value:
                  '-${_formatCurrency(coinsUsed)}',
              isDiscount: true,
            ),
          ],
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppDimens.contentPadding(
                context,
              ),
            ),
            child: Divider(
              height: 1,
              color: colorScheme.outlineVariant,
            ),
          ),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Payment',
                style:
                    textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                _formatCurrency(_total),
                style:
                    textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          AppDimens.verticalExtraSmall,
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '(VAT Included)',
              style:
                  textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int amount) {
    final formatted =
        amount.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '$formattedđ';
  }
}

/// A single row showing a label and value pair in
/// the payment breakdown.
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDiscount;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
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
            color: isDiscount
                ? colorScheme.error
                : colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
