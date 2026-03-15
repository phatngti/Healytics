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
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>();

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildPriceColumn(colorScheme, textTheme, semanticColors),
          const SizedBox(width: 16),
          Expanded(child: _buildButton(colorScheme)),
        ],
      ),
    );
  }

  Widget _buildPriceColumn(
    ColorScheme colorScheme,
    TextTheme textTheme,
    SemanticColors? semanticColors,
  ) {
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
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: (semanticColors?.success ?? Colors.green).withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Save ${_formatCurrency(saved)}',
              style: textTheme.labelSmall?.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: semanticColors?.success ?? Colors.green,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildButton(ColorScheme colorScheme) {
    return FilledButton(
      onPressed: onConfirm,
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        shadowColor: colorScheme.primary.withValues(alpha: 0.3),
      ),
      child: const Text(
        'Confirm Payment',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
