import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/cart/domain/entities/voucher.entity.dart';

/// Modal bottom sheet listing available vouchers
/// for a cart item.
///
/// Returns the selected [VoucherEntity] via
/// `Navigator.pop`, or null if dismissed.
class VoucherPickerSheet extends StatefulWidget {
  /// List of vouchers to display.
  final List<VoucherEntity> vouchers;

  /// Currently applied voucher code (for highlight).
  final String? appliedCode;

  /// Whether the voucher list is still loading.
  final bool isLoading;

  const VoucherPickerSheet({
    super.key,
    required this.vouchers,
    this.appliedCode,
    this.isLoading = false,
  });

  /// Shows the voucher picker as a modal bottom sheet
  /// and returns the selected voucher, or null.
  static Future<VoucherEntity?> show(
    BuildContext context, {
    required List<VoucherEntity> vouchers,
    String? appliedCode,
    bool isLoading = false,
  }) {
    return showModalBottomSheet<VoucherEntity>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => VoucherPickerSheet(
        vouchers: vouchers,
        appliedCode: appliedCode,
        isLoading: isLoading,
      ),
    );
  }

  @override
  State<VoucherPickerSheet> createState() => _VoucherPickerSheetState();
}

class _VoucherPickerSheetState extends State<VoucherPickerSheet> {
  String? _selectedCode;

  @override
  void initState() {
    super.initState();
    _selectedCode = widget.appliedCode;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final pad = AppDimens.horizontalPadding(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.65,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimens.spaceLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetHandle(colorScheme: colorScheme),
          _SheetHeader(
            textTheme: textTheme,
            colorScheme: colorScheme,
            pad: pad,
          ),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          if (widget.isLoading)
            _LoadingState(colorScheme: colorScheme)
          else if (widget.vouchers.isEmpty)
            _EmptyState(textTheme: textTheme, colorScheme: colorScheme)
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  horizontal: pad,
                  vertical: AppDimens.spaceMd,
                ),
                itemCount: widget.vouchers.length,
                separatorBuilder: (_, __) =>
                    SizedBox(height: AppDimens.spaceSm),
                itemBuilder: (context, index) {
                  final voucher = widget.vouchers[index];
                  final isSelected = _selectedCode == voucher.code;
                  return _VoucherTile(
                    voucher: voucher,
                    isSelected: isSelected,
                    onTap: () => setState(() {
                      _selectedCode = voucher.code;
                    }),
                  );
                },
              ),
            ),
          _ConfirmButton(
            pad: pad,
            selectedCode: _selectedCode,
            vouchers: widget.vouchers,
          ),
        ],
      ),
    );
  }
}

/// Drag handle indicator at sheet top.
class _SheetHandle extends StatelessWidget {
  final ColorScheme colorScheme;

  const _SheetHandle({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(
          top: AppDimens.spaceSm,
          bottom: AppDimens.spaceXs,
        ),
        width: AppDimens.spaceXxl * 2,
        height: AppDimens.spaceXxs,
        decoration: BoxDecoration(
          color: colorScheme.outlineVariant,
          borderRadius: AppDimens.radiusPill,
        ),
      ),
    );
  }
}

/// Sheet header with "Select Voucher" and close.
class _SheetHeader extends StatelessWidget {
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final double pad;

  const _SheetHeader({
    required this.textTheme,
    required this.colorScheme,
    required this.pad,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: pad,
        vertical: AppDimens.spaceSm,
      ),
      child: Row(
        children: [
          Icon(
            Symbols.confirmation_number,
            color: colorScheme.primary,
            size: AppDimens.iconMd,
          ),
          SizedBox(width: AppDimens.spaceSm),
          Expanded(
            child: Text(
              'Select Voucher',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Symbols.close,
              size: AppDimens.iconMd,
              color: colorScheme.onSurfaceVariant,
            ),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }
}

/// Loading indicator for voucher list.
class _LoadingState extends StatelessWidget {
  final ColorScheme colorScheme;

  const _LoadingState({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.spaceXxl),
      child: Center(
        child: CircularProgressIndicator(color: colorScheme.primary),
      ),
    );
  }
}

/// Empty state when no vouchers are available.
class _EmptyState extends StatelessWidget {
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  const _EmptyState({required this.textTheme, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.spaceXxl),
      child: Column(
        children: [
          Icon(
            Symbols.sentiment_dissatisfied,
            size: AppDimens.iconXxl,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: AppDimens.spaceMd),
          Text(
            'No vouchers available',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Single voucher tile with selection state.
class _VoucherTile extends StatelessWidget {
  final VoucherEntity voucher;
  final bool isSelected;
  final VoidCallback onTap;

  const _VoucherTile({
    required this.voucher,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: 'Voucher: ${voucher.code}',
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDimens.radiusMediumSmall,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(AppDimens.contentPadding(context)),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.08)
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: AppDimens.radiusMediumSmall,
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant.withValues(alpha: 0.3),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              // Discount badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceSm,
                  vertical: AppDimens.spaceXs,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: AppDimens.radiusExtraSmall,
                ),
                child: Text(
                  '-${voucher.discountPercent}%',
                  style: textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(width: AppDimens.spaceMd),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      voucher.code,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: AppDimens.spaceXxs),
                    Text(
                      voucher.label,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (voucher.expiresAt != null)
                      Padding(
                        padding: const EdgeInsets.only(top: AppDimens.spaceXxs),
                        child: Text(
                          'Expires: '
                          '${_formatDate(voucher.expiresAt!)}',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.7,
                            ),
                            fontSize: 10,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Check icon
              if (isSelected)
                Icon(
                  Symbols.check_circle,
                  color: colorScheme.primary,
                  size: AppDimens.iconMd,
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = (date.year % 100).toString().padLeft(2, '0');
    return '$d/$m/$y';
  }
}

/// Confirm selection button at sheet bottom.
class _ConfirmButton extends StatelessWidget {
  final double pad;
  final String? selectedCode;
  final List<VoucherEntity> vouchers;

  const _ConfirmButton({
    required this.pad,
    required this.selectedCode,
    required this.vouchers,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasSelection = selectedCode != null;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        pad,
        AppDimens.spaceSm,
        pad,
        AppDimens.spaceLg + MediaQuery.paddingOf(context).bottom,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: hasSelection
              ? () {
                  final selected = vouchers.firstWhere(
                    (v) => v.code == selectedCode,
                  );
                  Navigator.pop(context, selected);
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            disabledBackgroundColor: colorScheme.onSurface.withValues(
              alpha: 0.12,
            ),
            padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
            shape: RoundedRectangleBorder(
              borderRadius: AppDimens.radiusMediumSmall,
            ),
          ),
          child: Text(
            'Apply Voucher',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: hasSelection
                  ? colorScheme.onPrimary
                  : colorScheme.onSurface.withValues(alpha: 0.38),
            ),
          ),
        ),
      ),
    );
  }
}
