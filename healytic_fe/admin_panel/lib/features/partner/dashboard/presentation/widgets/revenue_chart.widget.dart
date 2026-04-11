import 'package:admin_panel/features/partner/dashboard/domain/dashboard_time_period.dart';
import 'package:admin_panel/features/partner/dashboard/domain/revenue_data_point.entity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Revenue area + line chart with time period selector.
///
/// Uses fl_chart to render a gradient-filled area
/// chart with interactive tooltips.
class RevenueChart extends StatelessWidget {
  const RevenueChart({
    super.key,
    required this.data,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  final List<RevenueDataPoint> data;
  final DashboardTimePeriod selectedPeriod;
  final ValueChanged<DashboardTimePeriod>
      onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant
              .withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _ChartHeader(
              selectedPeriod: selectedPeriod,
              onPeriodChanged: onPeriodChanged,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: data.isEmpty
                  ? Center(
                      child: Text(
                        'No data available',
                        style: theme
                            .textTheme.bodyMedium,
                      ),
                    )
                  : _RevenueLineChart(
                      data: data,
                      colorScheme: colorScheme,
                      period: selectedPeriod,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartHeader extends StatelessWidget {
  const _ChartHeader({
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  final DashboardTimePeriod selectedPeriod;
  final ValueChanged<DashboardTimePeriod>
      onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.show_chart_rounded,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Revenue Overview',
              style: theme.textTheme.titleMedium
                  ?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        SegmentedButton<DashboardTimePeriod>(
          segments: DashboardTimePeriod.values
              .map(
                (p) => ButtonSegment(
                  value: p,
                  label: Text(
                    p.displayName,
                    style:
                        theme.textTheme.labelSmall,
                  ),
                ),
              )
              .toList(),
          selected: {selectedPeriod},
          onSelectionChanged: (selected) {
            onPeriodChanged(selected.first);
          },
          style: ButtonStyle(
            visualDensity: VisualDensity.compact,
            tapTargetSize:
                MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}

class _RevenueLineChart extends StatelessWidget {
  const _RevenueLineChart({
    required this.data,
    required this.colorScheme,
    required this.period,
  });

  final List<RevenueDataPoint> data;
  final ColorScheme colorScheme;
  final DashboardTimePeriod period;

  @override
  Widget build(BuildContext context) {
    final spots = data.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.revenue,
      );
    }).toList();

    final rawMaxY = data.fold<double>(
      0,
      (max, d) => d.revenue > max ? d.revenue : max,
    );
    // Ensure maxY is never zero to avoid
    // FlGridData.horizontalInterval assertion.
    final maxY = rawMaxY > 0 ? rawMaxY : 1.0;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 5,
          getDrawingHorizontalLine: (value) =>
              FlLine(
                color: colorScheme.outlineVariant
                    .withValues(alpha: 0.3),
                strokeWidth: 1,
              ),
        ),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                return Text(
                  _formatYAxis(value),
                  style: TextStyle(
                    fontSize: 10,
                    color:
                        colorScheme.onSurfaceVariant,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: _xInterval,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 ||
                    index >= data.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding:
                      const EdgeInsets.only(top: 8),
                  child: Text(
                    _formatXAxis(data[index].date),
                    style: TextStyle(
                      fontSize: 10,
                      color: colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: colorScheme.primary,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, __, ___, ____) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: colorScheme.primary,
                  strokeWidth: 1.5,
                  strokeColor:
                      colorScheme.surface,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.primary
                      .withValues(alpha: 0.3),
                  colorScheme.primary
                      .withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) =>
                colorScheme.inverseSurface,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final idx = spot.x.toInt();
                final point = data[idx];
                final dateStr =
                    DateFormat('MMM d')
                        .format(point.date);
                return LineTooltipItem(
                  '$dateStr\n',
                  TextStyle(
                    color:
                        colorScheme.onInverseSurface,
                    fontSize: 11,
                  ),
                  children: [
                    TextSpan(
                      text: _formatRevenue(
                        point.revenue,
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme
                            .onInverseSurface,
                        fontSize: 13,
                      ),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  double get _xInterval {
    return switch (period) {
      DashboardTimePeriod.today => 2,
      DashboardTimePeriod.thisWeek => 1,
      DashboardTimePeriod.thisMonth => 5,
      DashboardTimePeriod.thisQuarter => 2,
      DashboardTimePeriod.thisYear => 1,
    };
  }

  String _formatXAxis(DateTime date) {
    return switch (period) {
      DashboardTimePeriod.today =>
        DateFormat('HH:mm').format(date),
      DashboardTimePeriod.thisWeek =>
        DateFormat('EEE').format(date),
      DashboardTimePeriod.thisMonth =>
        DateFormat('d').format(date),
      DashboardTimePeriod.thisQuarter =>
        DateFormat('MMM d').format(date),
      DashboardTimePeriod.thisYear =>
        DateFormat('MMM').format(date),
    };
  }

  String _formatYAxis(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }

  String _formatRevenue(double value) {
    final formatter = NumberFormat('#,###', 'vi');
    return '${formatter.format(value)}₫';
  }
}
