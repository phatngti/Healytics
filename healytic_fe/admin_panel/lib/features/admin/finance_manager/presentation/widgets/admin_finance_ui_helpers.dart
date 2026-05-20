import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_period.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ────────────────────────────────────────────────────
// Formatting
// ────────────────────────────────────────────────────

/// Formats a monetary amount with the correct locale.
String formatAdminCurrency(double amount, String currency) {
  final formatter = NumberFormat.currency(
    locale: currency == 'VND' ? 'vi_VN' : 'en_US',
    symbol: currency == 'VND' ? 'VND ' : '\$',
    decimalDigits: 0,
  );
  return formatter.format(amount);
}

/// Compact currency format for KPI cards.
String formatAdminCurrencyCompact(double amount, String currency) {
  final prefix = currency == 'VND' ? 'VND ' : '\$';
  if (amount >= 1e9) {
    return '$prefix${(amount / 1e9).toStringAsFixed(1)}B';
  }
  if (amount >= 1e6) {
    return '$prefix${(amount / 1e6).toStringAsFixed(1)}M';
  }
  if (amount >= 1e3) {
    return '$prefix${(amount / 1e3).toStringAsFixed(0)}K';
  }
  return '$prefix${amount.toStringAsFixed(0)}';
}

/// Short date: `28 Apr 2026`.
String formatAdminDate(DateTime value) {
  return DateFormat('dd MMM yyyy').format(value);
}

/// Date + time: `28 Apr 2026, 14:30`.
String formatAdminDateTime(DateTime value) {
  return DateFormat('dd MMM yyyy, HH:mm').format(value);
}

/// Relative time description.
String formatAdminRelativeTime(DateTime value) {
  final diff = DateTime.now().difference(value);
  if (diff.inMinutes < 60) {
    return '${diff.inMinutes}m ago';
  }
  if (diff.inHours < 24) {
    return '${diff.inHours}h ago';
  }
  if (diff.inDays < 7) {
    return '${diff.inDays}d ago';
  }
  return formatAdminDate(value);
}

// ────────────────────────────────────────────────────
// Status chip colors
// ────────────────────────────────────────────────────

/// Returns the background color for a status label.
Color adminFinanceStatusBackground(BuildContext context, String label) {
  final cs = Theme.of(context).colorScheme;
  final tone = _statusTone(label);
  return switch (tone) {
    AdminFinanceRiskTone.positive => Colors.green.withValues(alpha: 0.16),
    AdminFinanceRiskTone.warning => Colors.amber.withValues(alpha: 0.18),
    AdminFinanceRiskTone.critical => cs.errorContainer,
    AdminFinanceRiskTone.neutral => cs.primaryContainer,
  };
}

/// Returns the foreground color for a status label.
Color adminFinanceStatusForeground(BuildContext context, String label) {
  final cs = Theme.of(context).colorScheme;
  final tone = _statusTone(label);
  return switch (tone) {
    AdminFinanceRiskTone.positive => Colors.green.shade900,
    AdminFinanceRiskTone.warning => Colors.orange.shade900,
    AdminFinanceRiskTone.critical => cs.onErrorContainer,
    AdminFinanceRiskTone.neutral => cs.onPrimaryContainer,
  };
}

AdminFinanceRiskTone _statusTone(String label) {
  final n = label.toLowerCase();

  // Critical
  if (n.contains('failed') ||
      n.contains('rejected') ||
      n.contains('expired') ||
      n.contains('breached') ||
      n.contains('mismatch')) {
    return AdminFinanceRiskTone.critical;
  }

  // Positive
  if (n.contains('paid') ||
      n.contains('settled') ||
      n.contains('approved') ||
      n.contains('resolved') ||
      n.contains('ready')) {
    return AdminFinanceRiskTone.positive;
  }

  // Warning
  if (n.contains('review') ||
      n.contains('held') ||
      n.contains('in payout') ||
      n.contains('processing') ||
      n.contains('reopened')) {
    return AdminFinanceRiskTone.warning;
  }

  return AdminFinanceRiskTone.neutral;
}

// ────────────────────────────────────────────────────
// Status chip widget
// ────────────────────────────────────────────────────

/// Themed status chip for finance statuses.
class AdminFinanceStatusChip extends StatelessWidget {
  const AdminFinanceStatusChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSmMd,
        vertical: AppDimens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: adminFinanceStatusBackground(context, label),
        borderRadius: AppDimens.radiusPill,
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: adminFinanceStatusForeground(context, label),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Risk-tone indicator dot.
class AdminFinanceRiskDot extends StatelessWidget {
  const AdminFinanceRiskDot({super.key, required this.tone, this.size = 10});

  final AdminFinanceRiskTone tone;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = switch (tone) {
      AdminFinanceRiskTone.positive => Colors.green.shade600,
      AdminFinanceRiskTone.warning => Colors.orange.shade600,
      AdminFinanceRiskTone.critical => Theme.of(context).colorScheme.error,
      AdminFinanceRiskTone.neutral => Theme.of(context).colorScheme.outline,
    };
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

/// Change percent badge (↑ 12.3% or ↓ 4.1%).
class AdminFinanceChangeBadge extends StatelessWidget {
  const AdminFinanceChangeBadge({super.key, required this.changePercent});

  final double changePercent;

  @override
  Widget build(BuildContext context) {
    final isPositive = changePercent >= 0;
    final color = isPositive ? Colors.green.shade700 : Colors.red;
    final arrow = isPositive ? '↑' : '↓';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$arrow ${changePercent.abs().toStringAsFixed(1)}%',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
