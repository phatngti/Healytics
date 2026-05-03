import 'package:admin_panel/features/partner/transactions/domain/finance_models.dart';
import 'package:admin_panel/features/partner/transactions/presentation/widgets/finance_ui_helpers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    final effectiveMaxY = maxY == 0 ? 1.0 : maxY * 1.25;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: 0,
        maxY: effectiveMaxY,
        clipData: const FlClipData.all(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(
            color: colorScheme.outlineVariant.withValues(alpha: 0.25),
            strokeWidth: 1,
            dashArray: const [4, 4],
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: values,
            isCurved: true,
            preventCurveOverShooting: true,
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
            dotData: FlDotData(
              show: true,
              getDotPainter: (_, __, ___, ____) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: colorScheme.surface,
                  strokeWidth: 2,
                  strokeColor: colorScheme.primary,
                );
              },
            ),
          ),
        ],
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (!_shouldShowFinanceAxisLabel(
                  value: value,
                  index: index,
                  points: data,
                )) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _formatAxisDate(data[index].date),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          touchSpotThreshold: 20,
          getTouchedSpotIndicator: (barData, spotIndexes) {
            return spotIndexes.map((_) {
              return TouchedSpotIndicatorData(
                const FlLine(color: Colors.transparent),
                FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 6,
                      color: colorScheme.surface,
                      strokeWidth: 2,
                      strokeColor: barData.color ?? colorScheme.primary,
                    );
                  },
                ),
              );
            }).toList();
          },
          touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipColor: (_) => colorScheme.surface,
            tooltipBorder: BorderSide(color: colorScheme.outlineVariant),
            getTooltipItems: (spots) {
              return spots
                  .map(
                    (spot) => LineTooltipItem(
                      '${formatFinanceDate(data[spot.x.toInt()].date)}\n${formatFinanceCurrency(spot.y, currency)}',
                      Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
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

bool _shouldShowFinanceAxisLabel({
  required double value,
  required int index,
  required List<FinanceTrendPoint> points,
}) {
  if (value != index.toDouble() || index < 0 || index >= points.length) {
    return false;
  }

  if (points.length <= 8) {
    return true;
  }

  final step = ((points.length - 1) / 6).ceil();
  return index == 0 || index == points.length - 1 || index % step == 0;
}

String _formatAxisDate(DateTime value) => DateFormat('dd MMM').format(value);
