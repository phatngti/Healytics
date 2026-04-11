import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/network_image_auto.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/features/cart/domain/entities/cart_item.entity.dart';
import 'package:user_app/features/cart/domain/entities/voucher.entity.dart';

import 'appointment_details_panel.widget.dart';
import 'voucher_selector_row.widget.dart';

/// Card displaying a single cart item with checkbox,
/// image, name, price, specialist info, slot time,
/// clinic info, and conditional voucher selector.
///
/// The voucher selector only appears when the item
/// is selected (checkbox checked).
///
/// Intended to be wrapped in a [Dismissible] by the
/// parent list for swipe-to-delete.
class CartItemCard extends StatelessWidget {
  /// The cart item to display.
  final CartItemEntity item;

  /// Whether this item is selected for checkout.
  final bool isSelected;

  /// Callback when the checkbox is toggled.
  final VoidCallback onToggleSelection;

  /// Callback when the delete icon is tapped.
  final VoidCallback onDelete;

  /// Callback when "edit" is tapped — navigates
  /// to service details.
  final VoidCallback? onEdit;

  /// Callback when a voucher code is applied.
  final ValueChanged<String> onApplyCoupon;

  /// Callback to remove the applied voucher.
  final VoidCallback onRemoveCoupon;

  /// Whether a coupon operation is in progress.
  final bool isCouponLoading;

  /// Available vouchers for this item.
  final List<VoucherEntity> availableVouchers;

  /// Whether the voucher list is still loading.
  final bool isVouchersLoading;

  const CartItemCard({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onToggleSelection,
    required this.onDelete,
    this.onEdit,
    required this.onApplyCoupon,
    required this.onRemoveCoupon,
    this.isCouponLoading = false,
    this.availableVouchers = const [],
    this.isVouchersLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardPad = AppDimens.cardPadding(context);

    return Semantics(
      label: 'Cart item: ${item.serviceName}',
      child: Container(
        padding: EdgeInsets.all(cardPad),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppDimens.radiusMediumSmall,
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: AppDimens.spaceMd,
              offset: const Offset(0, AppDimens.spaceXxs),
            ),
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.02),
              blurRadius: AppDimens.spaceXxl,
              offset: const Offset(0, AppDimens.spaceXs),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radio — single-service checkout
            Padding(
              padding: const EdgeInsets.only(top: AppDimens.spaceXxs),
              child: GestureDetector(
                key: keys.cartPage.itemSelection(item.id),
                onTap: onToggleSelection,
                child: SizedBox(
                  width: AppDimens.iconLg,
                  height: AppDimens.iconLg,
                  child: Center(
                    child: _RadioIndicator(
                      isSelected: isSelected,
                      activeColor: colorScheme.primary,
                      inactiveColor: colorScheme.outline,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: AppDimens.spaceMd),
            // Content column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ItemHeader(item: item, onEdit: onEdit, onDelete: onDelete),
                  SizedBox(height: AppDimens.spaceMd),
                  AppointmentDetailsPanel(
                    clinicName: item.clinicName,
                    clinicAddress: item.clinicAddress,
                  ),
                  // Conditional voucher selector
                  if (isSelected)
                    VoucherSelectorRow(
                      itemId: item.id,
                      appliedCoupon: item.couponCode,
                      vouchers: availableVouchers,
                      isVouchersLoading: isVouchersLoading,
                      onApply: onApplyCoupon,
                      onRemove: onRemoveCoupon,
                      isCouponLoading: isCouponLoading,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Row with service image, name, price, specialist
/// info, slot time, and edit/delete icon buttons.
class _ItemHeader extends StatelessWidget {
  final CartItemEntity item;
  final VoidCallback? onEdit;
  final VoidCallback onDelete;

  const _ItemHeader({required this.item, this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final imgSize = AppDimens.adaptive(
      context,
      small: 72,
      medium: 80,
      large: 88,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Service image
        ClipRRect(
          borderRadius: AppDimens.radiusSmall,
          child: SizedBox(
            width: imgSize,
            height: imgSize,
            child: NetworkImageAuto(
              imageUrl: item.serviceImageUrl,
              fit: BoxFit.cover,
              errorWidget: (_) => Container(
                color: colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: AppDimens.spaceMd),
        // Name + Price + Specialist + Slot
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service name + price + actions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.serviceName,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: AppDimens.spaceXxs),
                        Text(
                          item.price,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _ActionIcons(onEdit: onEdit, onDelete: onDelete),
                ],
              ),
              // Specialist info
              if (item.hasSpecialist)
                _SpecialistInfo(
                  name: item.specialistName!,
                  position: item.specialistPosition,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              // Slot time
              if (item.hasSlotTime)
                _SlotTimeInfo(
                  slotTime: item.slotTime!,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Specialist name and position row.
class _SpecialistInfo extends StatelessWidget {
  final String name;
  final String? position;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _SpecialistInfo({
    required this.name,
    this.position,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppDimens.spaceXs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: AppDimens.spaceXxs),
            child: Icon(
              Symbols.person,
              size: AppDimens.iconXs,
              color: colorScheme.primary,
            ),
          ),
          SizedBox(width: AppDimens.spaceXxs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (position != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppDimens.spaceXxs),
                    child: Text(
                      position!,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Slot time display row with formatted datetime.
class _SlotTimeInfo extends StatelessWidget {
  final DateTime slotTime;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _SlotTimeInfo({
    required this.slotTime,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppDimens.spaceXxs),
      child: Row(
        children: [
          Icon(
            Symbols.schedule,
            size: AppDimens.iconXs,
            color: colorScheme.primary,
          ),
          SizedBox(width: AppDimens.spaceXxs),
          Text(
            _formatSlotTime(slotTime),
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Formats as "HH:mm dd/MM/yy".
  String _formatSlotTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = (dt.year % 100).toString().padLeft(2, '0');
    return '$h:$min $d/$m/$y';
  }
}

/// Edit and delete icon buttons.
class _ActionIcons extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback onDelete;

  const _ActionIcons({this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onEdit != null)
          _SmallIconButton(
            icon: Symbols.edit_note,
            color: colorScheme.outline,
            onTap: onEdit!,
            tooltip: 'Edit item',
          ),
        _SmallIconButton(
          icon: Symbols.delete,
          color: colorScheme.outline,
          activeColor: colorScheme.error,
          onTap: onDelete,
          tooltip: 'Remove item',
        ),
      ],
    );
  }
}

/// Compact icon button for card actions.
class _SmallIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color? activeColor;
  final VoidCallback onTap;
  final String tooltip;

  const _SmallIconButton({
    required this.icon,
    required this.color,
    this.activeColor,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDimens.radiusPill,
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceXs),
          child: Icon(icon, size: AppDimens.iconMd, color: color),
        ),
      ),
    );
  }
}

/// Custom radio indicator circle.
///
/// Renders a 20dp outer ring and a filled inner dot
/// when [isSelected] is `true`.
class _RadioIndicator extends StatelessWidget {
  final bool isSelected;
  final Color activeColor;
  final Color inactiveColor;

  const _RadioIndicator({
    required this.isSelected,
    required this.activeColor,
    required this.inactiveColor,
  });

  static const _outerSize = 20.0;
  static const _innerSize = 10.0;
  static const _borderWidth = 2.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _outerSize,
      height: _outerSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? activeColor : inactiveColor,
          width: _borderWidth,
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isSelected ? _innerSize : 0,
          height: isSelected ? _innerSize : 0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? activeColor : Colors.transparent,
          ),
        ),
      ),
    );
  }
}
