import 'package:admin_panel/features/partner/transactions/domain/finance_models.dart';
import 'package:admin_panel/features/partner/transactions/presentation/widgets/finance_ui_helpers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class FinanceTrendPanel extends StatelessWidget {
  const FinanceTrendPanel({
    super.key,
    required this.data,
    required this.selectedPeriod,
    required this.selectedMetric,
    required this.onPeriodChanged,
    required this.onMetricChanged,
    required this.currency,
  });

  final List<FinanceTrendPoint> data;
  final FinancePeriod selectedPeriod;
  final FinanceMetric selectedMetric;
  final ValueChanged<FinancePeriod> onPeriodChanged;
  final ValueChanged<FinanceMetric> onMetricChanged;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Finance Trend',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gross, net, and refund movement over time.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              SegmentedButton<FinancePeriod>(
                segments: FinancePeriod.values
                    .map(
                      (item) =>
                          ButtonSegment(value: item, label: Text(item.label)),
                    )
                    .toList(),
                selected: {selectedPeriod},
                onSelectionChanged: (selected) =>
                    onPeriodChanged(selected.first),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SegmentedButton<FinanceMetric>(
            segments: FinanceMetric.values
                .map(
                  (item) => ButtonSegment(value: item, label: Text(item.label)),
                )
                .toList(),
            selected: {selectedMetric},
            onSelectionChanged: (selected) => onMetricChanged(selected.first),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 280,
            child: data.isEmpty
                ? Center(
                    child: Text(
                      'No finance data available for the selected filters.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  )
                : _FinanceLineChart(
                    data: data,
                    selectedMetric: selectedMetric,
                    currency: currency,
                  ),
          ),
        ],
      ),
    );
  }
}

class _FinanceLineChart extends StatelessWidget {
  const _FinanceLineChart({
    required this.data,
    required this.selectedMetric,
    required this.currency,
  });

  final List<FinanceTrendPoint> data;
  final FinanceMetric selectedMetric;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final values = data
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), _metricValue(entry.value)))
        .toList();
    final maxY = values.fold<double>(
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
          getDrawingHorizontalLine: (value) => FlLine(
            color: colorScheme.outlineVariant.withValues(alpha: 0.25),
            strokeWidth: 1,
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: values,
            isCurved: true,
            barWidth: 3,
            color: colorScheme.primary,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.primary.withValues(alpha: 0.25),
                  colorScheme.primary.withValues(alpha: 0.02),
                ],
              ),
            ),
            dotData: FlDotData(show: true),
          ),
        ],
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 72,
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  formatFinanceCurrency(value, currency),
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
                if (index < 0 || index >= data.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    formatFinanceDate(data[index].date),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => colorScheme.inverseSurface,
            getTooltipItems: (spots) {
              return spots
                  .map(
                    (spot) => LineTooltipItem(
                      '${formatFinanceDate(data[spot.x.toInt()].date)}\n${formatFinanceCurrency(spot.y, currency)}',
                      Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: colorScheme.onInverseSurface,
                      ),
                    ),
                  )
                  .toList();
            },
          ),
        ),
      ),
    );
  }

  double _metricValue(FinanceTrendPoint point) => switch (selectedMetric) {
    FinanceMetric.gross => point.grossAmount,
    FinanceMetric.net => point.netAmount,
    FinanceMetric.refunds => point.refundAmount,
  };
}
