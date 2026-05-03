import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_period.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_revenue_trend_point.entity.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_formatters.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_panel.widget.dart';
import 'package:common/utils/demensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AdminDashboardRevenueTrendPanel extends StatelessWidget {
  const AdminDashboardRevenueTrendPanel({
    super.key,
    required this.points,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  final List<AdminDashboardRevenueTrendPoint> points;
  final AdminDashboardPeriod selectedPeriod;
  final ValueChanged<AdminDashboardPeriod> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AdminDashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppDimens.spaceMd,
            runSpacing: AppDimens.spaceMd,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Finance Trend',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  AppDimens.verticalExtraSmall,
                  Text(
                    'Daily gross revenue, net revenue, and refund pressure for the selected period.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              SegmentedButton<AdminDashboardPeriod>(
                segments: AdminDashboardPeriod.values
                    .map(
                      (item) =>
                          ButtonSegment(value: item, label: Text(item.label)),
                    )
                    .toList(),
                selected: {selectedPeriod},
                onSelectionChanged: (value) => onPeriodChanged(value.first),
              ),
            ],
          ),
          AppDimens.verticalLarge,
          SizedBox(
            height: 280,
            child: points.isEmpty
                ? const Center(child: Text('No revenue trend data available.'))
                : _RevenueChart(points: points),
          ),
        ],
      ),
    );
  }
}

class _RevenueChart extends StatelessWidget {
  const _RevenueChart({required this.points});

  final List<AdminDashboardRevenueTrendPoint> points;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final gross = points
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.grossRevenue))
        .toList();
    final net = points
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.netRevenue))
        .toList();
    final maxY = gross.fold<double>(
      0,
      (max, item) => item.y > max ? item.y : max,
    );

    return LineChart(
      LineChartData(
        minY: 0,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY == 0 ? 1 : maxY / 4,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: colorScheme.outlineVariant.withValues(alpha: 0.25)),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 70,
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(right: AppDimens.spaceSm),
                child: Text(
                  formatAdminCurrency(value),
                  style: Theme.of(context).textTheme.labelSmall,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= points.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: AppDimens.spaceSm),
                  child: Text(
                    formatAdminDate(points[index].date),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: gross,
            color: colorScheme.primary,
            barWidth: 3,
            isCurved: true,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withValues(alpha: 0.18),
                  colorScheme.primary.withValues(alpha: 0.02),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            dotData: const FlDotData(show: false),
          ),
          LineChartBarData(
            spots: net,
            color: colorScheme.tertiary,
            barWidth: 2,
            isCurved: true,
            dotData: const FlDotData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => colorScheme.inverseSurface,
            getTooltipItems: (spots) => spots
                .map(
                  (spot) => LineTooltipItem(
                    '${formatAdminDate(points[spot.x.toInt()].date)}\n${formatAdminCurrencyFull(spot.y)}',
                    Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: colorScheme.onInverseSurface,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
