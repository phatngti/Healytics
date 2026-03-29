import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:user_app/features/checkout/domain/entities/checkout.entity.dart';

/// Radio-style payment method selector section.
class PaymentMethodSection extends StatelessWidget {
  final List<PaymentMethodOption> methods;
  final PaymentMethodType selectedType;
  final ValueChanged<PaymentMethodType> onSelected;

  const PaymentMethodSection({
    super.key,
    required this.methods,
    required this.selectedType,
    required this.onSelected,
  });

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
            'Payment Method',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          AppDimens.verticalMedium,
          ...methods.map(
            (method) => Padding(
              padding: const EdgeInsets.only(
                bottom: AppDimens.spaceMd,
              ),
              child: _PaymentOptionTile(
                method: method,
                isSelected:
                    method.type == selectedType,
                onTap: () => onSelected(method.type),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A single payment option with icon, label, and
/// radio indicator.
class _PaymentOptionTile extends StatelessWidget {
  final PaymentMethodOption method;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOptionTile({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pad = AppDimens.contentPadding(context);

    return InkWell(
      onTap: onTap,
      borderRadius: AppDimens.radiusMediumSmall,
      child: Container(
        padding: EdgeInsets.all(pad),
        decoration: BoxDecoration(
          borderRadius: AppDimens.radiusMediumSmall,
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant,
          ),
          color: isSelected
              ? colorScheme.primary
                  .withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            _PaymentIcon(
              type: method.type,
              isSelected: isSelected,
            ),
            AppDimens.horizontalMediumSmall,
            Expanded(
              child: _PaymentLabel(
                method: method,
                isSelected: isSelected,
              ),
            ),
            _RadioIndicator(
              isSelected: isSelected,
            ),
          ],
        ),
      ),
    );
  }
}

/// Icon for the payment method type.
class _PaymentIcon extends StatelessWidget {
  final PaymentMethodType type;
  final bool isSelected;

  const _PaymentIcon({
    required this.type,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return switch (type) {
      PaymentMethodType.card => Container(
          width: AppDimens.avatarSm,
          height: AppDimens.iconMd,
          decoration: BoxDecoration(
            color: colorScheme.onSurface,
            borderRadius: AppDimens.radiusExtraSmall,
          ),
          alignment: Alignment.center,
          child: Text(
            'VISA',
            style: TextStyle(
              fontSize: AppDimens.spaceXs + 2,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: colorScheme.surface,
            ),
          ),
        ),
      PaymentMethodType.eWallet => Icon(
          Icons.account_balance_wallet,
          color: colorScheme.tertiary,
          size: AppDimens.iconMd,
        ),
      PaymentMethodType.payLater => Icon(
          Icons.schedule,
          color: colorScheme.secondary,
          size: AppDimens.iconMd,
        ),
    };
  }
}

/// Label text (and optional sub-label) for a payment
/// option.
class _PaymentLabel extends StatelessWidget {
  final PaymentMethodOption method;
  final bool isSelected;

  const _PaymentLabel({
    required this.method,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return RichText(
      text: TextSpan(
        text: method.label,
        style: textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: isSelected
              ? colorScheme.onSurface
              : colorScheme.onSurfaceVariant,
        ),
        children: [
          if (method.subLabel != null)
            TextSpan(
              text: ' ${method.subLabel}',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

/// Custom radio circle indicator.
class _RadioIndicator extends StatelessWidget {
  final bool isSelected;

  const _RadioIndicator({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: AppDimens.iconMd,
      height: AppDimens.iconMd,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.outline,
          width: AppDimens.borderWidthThick,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: AppDimens.spaceSmMd,
                height: AppDimens.spaceSmMd,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary,
                ),
              ),
            )
          : null,
    );
  }
}
