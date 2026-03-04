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
            'Payment Method',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ...methods.map(
            (method) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PaymentOptionTile(
                method: method,
                isSelected: method.type == selectedType,
                onTap: () => onSelected(method.type),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant,
          ),
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            _buildLeadingIcon(colorScheme),
            const SizedBox(width: 12),
            Expanded(child: _buildLabel(colorScheme, textTheme)),
            _buildRadio(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(ColorScheme colorScheme) {
    switch (method.type) {
      case PaymentMethodType.card:
        return Container(
          width: 32,
          height: 20,
          decoration: BoxDecoration(
            color: colorScheme.onSurface,
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Text(
            'VISA',
            style: TextStyle(
              fontSize: 6,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: colorScheme.surface,
            ),
          ),
        );
      case PaymentMethodType.eWallet:
        return Icon(Icons.account_balance_wallet, color: Colors.blue, size: 20);
      case PaymentMethodType.payLater:
        return Icon(Icons.schedule, color: Colors.purple, size: 20);
    }
  }

  Widget _buildLabel(ColorScheme colorScheme, TextTheme textTheme) {
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

  Widget _buildRadio(ColorScheme colorScheme) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? colorScheme.primary : colorScheme.outline,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
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
