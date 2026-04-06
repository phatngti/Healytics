import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/cart/domain/entities/voucher.entity.dart';

import 'voucher_picker_sheet.widget.dart';

/// Tappable row that shows the applied voucher or
/// a "Select voucher" prompt.
///
/// Opens [VoucherPickerSheet] on tap and calls
/// [onApply] with the selected voucher's code.
class VoucherSelectorRow extends StatelessWidget {
  /// Currently applied coupon code (null if none).
  final String? appliedCoupon;

  /// Available vouchers for this item.
  final List<VoucherEntity> vouchers;

  /// Whether the voucher list is still loading.
  final bool isVouchersLoading;

  /// Called with the selected voucher code.
  final ValueChanged<String> onApply;

  /// Called to remove the applied voucher.
  final VoidCallback onRemove;

  /// Whether a coupon operation is in progress.
  final bool isCouponLoading;

  const VoucherSelectorRow({
    super.key,
    this.appliedCoupon,
    required this.vouchers,
    this.isVouchersLoading = false,
    required this.onApply,
    required this.onRemove,
    this.isCouponLoading = false,
  });

  Future<void> _openPicker(BuildContext context) async {
    final selected = await VoucherPickerSheet.show(
      context,
      vouchers: vouchers,
      appliedCode: appliedCoupon,
      isLoading: isVouchersLoading,
    );

    if (selected != null && context.mounted) {
      onApply(selected.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasApplied = appliedCoupon != null && appliedCoupon!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(top: AppDimens.spaceMd),
      child: InkWell(
        onTap: isCouponLoading ? null : () => _openPicker(context),
        borderRadius: AppDimens.radiusMediumSmall,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMd,
            vertical: AppDimens.spaceSmMd,
          ),
          decoration: BoxDecoration(
            color: hasApplied
                ? colorScheme.primary.withValues(alpha: 0.06)
                : colorScheme.surfaceContainerHighest,
            borderRadius: AppDimens.radiusMediumSmall,
            border: hasApplied
                ? Border.all(color: colorScheme.primary.withValues(alpha: 0.3))
                : null,
          ),
          child: Row(
            children: [
              Icon(
                Symbols.confirmation_number,
                size: AppDimens.iconSm,
                color: hasApplied
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: AppDimens.spaceSm),
              Expanded(
                child: hasApplied
                    ? _AppliedLabel(
                        code: appliedCoupon!,
                        textTheme: textTheme,
                        colorScheme: colorScheme,
                      )
                    : Text(
                        'Select voucher',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
              ),
              if (isCouponLoading)
                SizedBox(
                  width: AppDimens.iconSm,
                  height: AppDimens.iconSm,
                  child: CircularProgressIndicator(
                    strokeWidth: AppDimens.spaceXxs,
                    color: colorScheme.primary,
                  ),
                )
              else if (hasApplied)
                _RemoveButton(onRemove: onRemove, colorScheme: colorScheme)
              else
                Icon(
                  Symbols.chevron_right,
                  size: AppDimens.iconSm,
                  color: colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Displays the applied voucher code.
class _AppliedLabel extends StatelessWidget {
  final String code;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  const _AppliedLabel({
    required this.code,
    required this.textTheme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      code,
      style: textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.primary,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Compact remove button for the applied voucher.
class _RemoveButton extends StatelessWidget {
  final VoidCallback onRemove;
  final ColorScheme colorScheme;

  const _RemoveButton({required this.onRemove, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onRemove,
      borderRadius: AppDimens.radiusPill,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceXxs),
        child: Icon(
          Symbols.close,
          size: AppDimens.iconSm,
          color: colorScheme.error,
        ),
      ),
    );
  }
}
