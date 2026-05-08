import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/revenue.entity.dart';

/// 2×2 grid of KPI cards for the revenue dashboard.
///
/// Matches the HTML design's "squircle card" pattern
/// with icon badges, trend indicators, and comparison
/// text.
class RevenueKpiGrid extends StatelessWidget {
  /// Revenue summary data to display.
  final RevenueSummaryEntity summary;

  const RevenueKpiGrid({
    required this.summary,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.compactCurrency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _KpiCard(
          label: 'Total Revenue',
          value: fmt.format(summary.totalRevenue),
          trend: '+4.2%',
        ),
        _KpiCard(
          label: 'Net Earnings',
          value: fmt.format(summary.netEarnings),
          icon: Icons.account_balance_wallet_outlined,
        ),
        _KpiCard(
          label: 'Completed',
          value: '${summary.completedAppointments}',
          icon: Icons.check_circle_outline,
          subtitle: 'vs 8 yesterday',
        ),
        _KpiCard(
          label: 'Canceled',
          value: '${summary.canceledAppointments}',
          icon: Icons.close,
          isNegative: true,
        ),
      ],
    );
  }
}

/// Individual KPI card with optional trend badge,
/// icon badge, or subtitle text.
class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final String? trend;
  final String? subtitle;
  final bool isNegative;

  const _KpiCard({
    required this.label,
    required this.value,
    this.icon,
    this.trend,
    this.subtitle,
    this.isNegative = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final pad = AppDimens.cardPadding(context);
    final radius = AppDimens.cardRadius(context);

    return Container(
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: cs.outlineVariant
              .withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow
                .withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          // Label + icon badge
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: tt.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (icon != null)
                _IconBadge(
                  icon: icon!,
                  isNegative: isNegative,
                ),
            ],
          ),
          const SizedBox(height: 4),
          // Value
          Text(
            value,
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // Trend badge
          if (trend != null) ...[
            const SizedBox(height: 8),
            _TrendBadge(trend: trend!),
          ],
          // Subtitle
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: tt.labelSmall?.copyWith(
                color: cs.onSurfaceVariant
                    .withValues(alpha: 0.6),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

/// Small icon badge in the top-right of a KPI card.
class _IconBadge extends StatelessWidget {
  final IconData icon;
  final bool isNegative;

  const _IconBadge({
    required this.icon,
    required this.isNegative,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bgColor = isNegative
        ? cs.error.withValues(alpha: 0.1)
        : cs.primary.withValues(alpha: 0.1);
    final fgColor =
        isNegative ? cs.error : cs.primary;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: fgColor),
    );
  }
}

/// Green trend badge showing percentage change.
class _TrendBadge extends StatelessWidget {
  final String trend;
  const _TrendBadge({required this.trend});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = cs.tertiary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.trending_up,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 2),
          Text(
            trend,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
