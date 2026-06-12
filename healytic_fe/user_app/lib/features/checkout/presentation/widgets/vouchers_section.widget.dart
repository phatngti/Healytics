import 'package:common/utils/demensions.dart';
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
    final radius = AppDimens.cardRadius(context);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: AppDimens.spaceMd,
            offset: const Offset(0, AppDimens.spaceXxs),
          ),
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: AppDimens.spaceXxl,
            offset: const Offset(0, AppDimens.spaceXs + 2),
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

/// A single voucher row with icon, label, discount,
/// and a chevron for selection.
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
    final pad = AppDimens.cardPadding(context);

    return InkWell(
      onTap: () {
        // TODO: open voucher selection
      },
      borderRadius: BorderRadius.circular(AppDimens.cardRadius(context)),
      child: Padding(
        padding: EdgeInsets.all(pad),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary, size: AppDimens.iconMd),
            AppDimens.horizontalMediumSmall,
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
            AppDimens.horizontalSmall,
            Icon(
              Icons.chevron_right,
              size: AppDimens.iconSm,
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
    return '$formattedđ';
  }
}

/// Coin redemption row with balance display and
/// toggle switch.
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
    final pad = AppDimens.cardPadding(context);

    final formatted = coinValue.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );

    return Padding(
      padding: EdgeInsets.all(pad),
      child: Row(
        children: [
          Icon(
            Icons.monetization_on,
            color: Colors.amber.shade400,
            size: AppDimens.iconMd,
          ),
          AppDimens.horizontalMediumSmall,
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
                  '(-$formattedđ)',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: useCoins,
            onChanged: onToggled,
            activeThumbColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
