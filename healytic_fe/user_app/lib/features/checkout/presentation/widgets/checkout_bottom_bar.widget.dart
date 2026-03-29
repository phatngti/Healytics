import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:user_app/theme/app_theme.dart';

/// Fixed bottom bar with total price, savings badge,
/// and "Confirm Payment" button.
class CheckoutBottomBar extends StatelessWidget {
  final int total;
  final int saved;
  final VoidCallback onConfirm;

  const CheckoutBottomBar({
    super.key,
    required this.total,
    required this.saved,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final semanticColors = Theme.of(context)
        .extension<SemanticColors>();
    final pad = AppDimens.horizontalPadding(context);

    return Container(
      padding: EdgeInsets.fromLTRB(
        pad,
        pad,
        pad,
        pad + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow
                .withValues(alpha: 0.05),
            blurRadius: AppDimens.spaceXl,
            offset: const Offset(0, -AppDimens.spaceXs),
          ),
        ],
      ),
      child: Row(
        children: [
          _PriceColumn(
            total: total,
            saved: saved,
            semanticColors: semanticColors,
          ),
          AppDimens.horizontalMedium,
          Expanded(
            child: _ConfirmButton(
              onConfirm: onConfirm,
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays total price and optional savings badge.
class _PriceColumn extends StatelessWidget {
  final int total;
  final int saved;
  final SemanticColors? semanticColors;

  const _PriceColumn({
    required this.total,
    required this.saved,
    this.semanticColors,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          _formatCurrency(total),
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
            height: 1.2,
          ),
        ),
        if (saved > 0) ...[
          const SizedBox(height: AppDimens.spaceXxs),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceXs + 2,
              vertical: AppDimens.spaceXxs,
            ),
            decoration: BoxDecoration(
              color: (semanticColors?.success ??
                      Colors.green)
                  .withValues(alpha: 0.1),
              borderRadius: AppDimens.radiusExtraSmall
                  + const BorderRadius.all(
                    Radius.circular(2),
                  ),
            ),
            child: Text(
              'Save ${_formatCurrency(saved)}',
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: semanticColors?.success ??
                    Colors.green,
              ),
            ),
          ),
        ],
      ],
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

/// Filled "Confirm Payment" button.
class _ConfirmButton extends StatelessWidget {
  final VoidCallback onConfirm;

  const _ConfirmButton({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return FilledButton(
      onPressed: onConfirm,
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: EdgeInsets.symmetric(
          vertical: AppDimens.contentPadding(context),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimens.radiusMediumSmall,
        ),
        elevation: 4,
        shadowColor: colorScheme.primary
            .withValues(alpha: 0.3),
      ),
      child: Text(
        'Confirm Payment',
        style: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
