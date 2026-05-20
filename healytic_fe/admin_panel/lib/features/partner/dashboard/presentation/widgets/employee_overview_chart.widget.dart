import 'package:common/utils/demensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../domain/employee_distribution.entity.dart';
import 'dashboard_constants.dart';
import 'dashboard_section_header.widget.dart';

/// Donut chart showing employee distribution by role.
class EmployeeOverviewChart extends StatelessWidget {
  const EmployeeOverviewChart({super.key, required this.distribution});

  final List<EmployeeDistribution> distribution;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final total = distribution.fold<int>(0, (sum, d) => sum + d.count);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimens.radiusMediumSmall,
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: AppDimens.paddingAllMediumLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DashboardSectionHeader(
              title: 'Employee Overview',
              icon: Icons.people_alt_rounded,
            ),
            Row(
              children: [
                SizedBox(
                  height: DashboardSizes.donutChartSize,
                  width: DashboardSizes.donutChartSize,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: AppDimens.spaceXxs,
                      centerSpaceRadius: DashboardSizes.donutCenterRadius,
                      sections: distribution.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final d = entry.value;
                        final color =
                            DashboardColors.roleColors[idx %
                                DashboardColors.roleColors.length];
                        return PieChartSectionData(
                          value: d.count.toDouble(),
                          color: color,
                          radius: DashboardSizes.donutSectionRadius,
                          showTitle: false,
                        );
                      }).toList(),
                    ),
                  ),
                ),
                AppDimens.horizontalLarge,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: distribution.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final d = entry.value;
                      final color = DashboardColors
                          .roleColors[idx % DashboardColors.roleColors.length];
                      final pct = total > 0
                          ? (d.count / total * 100).toStringAsFixed(0)
                          : '0';
                      return _LegendItem(
                        color: color,
                        label: d.role,
                        count: d.count,
                        percentage: pct,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.count,
    required this.percentage,
  });

  final Color color;
  final String label;
  final int count;
  final String percentage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: AppDimens.spaceSm.paddingBottom,
      child: Row(
        children: [
          Container(
            width: DashboardSizes.legendDotSize,
            height: DashboardSizes.legendDotSize,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          AppDimens.horizontalSmall,
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '$count ($percentage%)',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: AppDimens.fontWeightSemiBold,
            ),
          ),
        ],
      ),
    );
  }
}
