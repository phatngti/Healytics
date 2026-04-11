import 'package:admin_panel/features/partner/dashboard/domain/employee_distribution.entity.dart';
import 'package:admin_panel/features/partner/dashboard/presentation/widgets/dashboard_section_header.widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Donut chart showing employee distribution by role.
class EmployeeOverviewChart extends StatelessWidget {
  const EmployeeOverviewChart({
    super.key,
    required this.distribution,
  });

  final List<EmployeeDistribution> distribution;

  static const _roleColors = [
    Color(0xFF4F46E5), // Doctor
    Color(0xFF0EA5E9), // Spa Therapist
    Color(0xFF10B981), // Massage Therapist
    Color(0xFFF59E0B), // Receptionist
    Color(0xFFEF4444), // On Leave
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final total = distribution.fold<int>(
      0,
      (sum, d) => sum + d.count,
    );

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
            DashboardSectionHeader(
              title: 'Employee Overview',
              icon: Icons.people_alt_rounded,
            ),
            Row(
              children: [
                SizedBox(
                  height: 160,
                  width: 160,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: distribution
                          .asMap()
                          .entries
                          .map((entry) {
                            final idx = entry.key;
                            final d = entry.value;
                            final color =
                                _roleColors[
                                    idx %
                                        _roleColors
                                            .length];
                            return PieChartSectionData(
                              value:
                                  d.count.toDouble(),
                              color: color,
                              radius: 28,
                              showTitle: false,
                            );
                          })
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: distribution
                        .asMap()
                        .entries
                        .map((entry) {
                          final idx = entry.key;
                          final d = entry.value;
                          final color =
                              _roleColors[
                                  idx %
                                      _roleColors
                                          .length];
                          final pct =
                              total > 0
                                  ? (d.count /
                                          total *
                                          100)
                                      .toStringAsFixed(
                                        0,
                                      )
                                  : '0';
                          return _LegendItem(
                            color: color,
                            label: d.role,
                            count: d.count,
                            percentage: pct,
                          );
                        })
                        .toList(),
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '$count ($percentage%)',
            style: theme.textTheme.bodySmall
                ?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
