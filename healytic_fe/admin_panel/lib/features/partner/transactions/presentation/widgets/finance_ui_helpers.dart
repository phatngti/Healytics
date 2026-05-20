import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatFinanceCurrency(double amount, String currency) {
  final formatter = NumberFormat.currency(
    locale: currency == 'VND' ? 'vi_VN' : 'en_US',
    symbol: currency == 'VND' ? 'VND ' : '\$',
    decimalDigits: 0,
  );
  return formatter.format(amount);
}

String formatFinanceDate(DateTime value) {
  return DateFormat('dd MMM yyyy').format(value);
}

String formatFinanceDateTime(DateTime value) {
  return DateFormat('dd MMM yyyy, HH:mm').format(value);
}

class FinanceStatusBadge extends StatelessWidget {
  const FinanceStatusBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSmMd,
        vertical: AppDimens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.primaryContainer,
        borderRadius: AppDimens.radiusPill,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: foregroundColor ?? colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

Color financeStatusBackground(BuildContext context, String label) {
  final colorScheme = Theme.of(context).colorScheme;
  final normalized = label.toLowerCase();
  if (normalized.contains('failed') || normalized.contains('rejected')) {
    return colorScheme.errorContainer;
  }
  if (normalized.contains('pending') ||
      normalized.contains('review') ||
      normalized.contains('held')) {
    return Colors.amber.withValues(alpha: 0.18);
  }
  if (normalized.contains('paid') ||
      normalized.contains('settled') ||
      normalized.contains('approved')) {
    return Colors.green.withValues(alpha: 0.16);
  }
  return colorScheme.primaryContainer;
}

Color financeStatusForeground(BuildContext context, String label) {
  final colorScheme = Theme.of(context).colorScheme;
  final normalized = label.toLowerCase();
  if (normalized.contains('failed') || normalized.contains('rejected')) {
    return colorScheme.onErrorContainer;
  }
  if (normalized.contains('pending') ||
      normalized.contains('review') ||
      normalized.contains('held')) {
    return Colors.orange.shade900;
  }
  if (normalized.contains('paid') ||
      normalized.contains('settled') ||
      normalized.contains('approved')) {
    return Colors.green.shade900;
  }
  return colorScheme.onPrimaryContainer;
}
