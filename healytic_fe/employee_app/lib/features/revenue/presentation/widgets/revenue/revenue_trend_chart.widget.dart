import 'package:common/utils/demensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/revenue.entity.dart';

/// Trend chart section with a bar chart inside a
/// Card-on-Surface container.
///
/// Includes a section header with title and
/// "View Details" action link.
class RevenueTrendChart extends StatelessWidget {
  /// The trend data points to display.
  final List<RevenueDataPoint> data;

  const RevenueTrendChart({
    required this.data,
    super.key,
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
        children: [
          // Section header
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trend',
                style: tt.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'View Details',
                style: tt.labelMedium?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Chart
          SizedBox(
            height: 160,
            child: data.isEmpty
                ? Center(
                    child: Text(
                      'No data',
                      style: tt.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  )
                : _BarChartContent(data: data),
          ),
        ],
      ),
    );
  }
}

/// The fl_chart BarChart implementation with
/// gradient bars and tooltip on the latest bar.
class _BarChartContent extends StatelessWidget {
  final List<RevenueDataPoint> data;

  const _BarChartContent({required this.data});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final maxY = data
            .map((d) => d.amount)
            .reduce((a, b) => a > b ? a : b) *
        1.2;
    final fmt = NumberFormat.compactCurrency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    final lastIdx = data.length - 1;

    return BarChart(
      BarChartData(
        maxY: maxY,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBorderRadius:
                BorderRadius.circular(8),
            getTooltipItem: (
              group,
              gIdx,
              rod,
              rIdx,
            ) {
              return BarTooltipItem(
                fmt.format(rod.toY),
                tt.labelSmall?.copyWith(
                      color: cs.onInverseSurface,
                      fontWeight: FontWeight.w600,
                    ) ??
                    const TextStyle(),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i < 0 || i >= data.length) {
                  return const SizedBox.shrink();
                }
                final isLast = i == lastIdx;
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: Text(
                    data[i].label,
                    style: tt.labelSmall?.copyWith(
                      color: isLast
                          ? cs.primary
                          : cs.onSurfaceVariant,
                      fontWeight: isLast
                          ? FontWeight.bold
                          : FontWeight.w400,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        barGroups:
            data.asMap().entries.map((e) {
              final isLast = e.key == lastIdx;
              return BarChartGroupData(
                x: e.key,
                showingTooltipIndicators:
                    isLast ? [0] : [],
                barRods: [
                  BarChartRodData(
                    toY: e.value.amount,
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: isLast
                          ? [
                              cs.primary,
                              cs.primary.withValues(
                                alpha: 0.7,
                              ),
                            ]
                          : [
                              cs.primary.withValues(
                                alpha: 0.4,
                              ),
                              cs.primary.withValues(
                                alpha: 0.2,
                              ),
                            ],
                    ),
                    width: 16,
                    borderRadius:
                        const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }
}
