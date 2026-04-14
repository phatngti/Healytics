import 'package:admin_panel/features/common/widgets/analytics/analytics_async_panel.widget.dart';
import 'package:admin_panel/features/common/widgets/analytics/analytics_kpi_card.widget.dart';
import 'package:admin_panel/features/common/widgets/analytics/analytics_panel.widget.dart';
import 'package:admin_panel/features/common/widgets/analytics/analytics_period_filter.widget.dart';
import 'package:admin_panel/features/common/widgets/analytics/analytics_section_header.widget.dart';
import 'package:admin_panel/features/common/widgets/analytics/analytics_status_badge.widget.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_analytics.entity.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee_analytics.provider.dart';
import 'package:common/utils/demensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Analytics overview for the employee index page.
class EmployeeOverviewAnalyticsSection extends ConsumerWidget {
  const EmployeeOverviewAnalyticsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(employeeOverviewAnalyticsProvider);

    return analyticsAsync.when(
      data: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnalyticsSectionHeader(
              title: 'Team Performance',
              subtitle:
                  'Utilization, quality, and compliance views across the '
                  'care team.',
              icon: Icons.groups_rounded,
              trailing: AnalyticsPeriodFilter(
                selectedPeriod: state.selectedPeriod,
                onChanged: (period) {
                  ref
                      .read(employeeOverviewAnalyticsProvider.notifier)
                      .setTimePeriod(period);
                },
              ),
            ),
            if (state.isRefreshing) ...[
              AppDimens.verticalSmall,
              const LinearProgressIndicator(),
            ],
            AppDimens.verticalLarge,
            _EmployeeOverviewKpis(analytics: state.analytics),
            AppDimens.verticalLarge,
            _EmployeeOverviewPanels(analytics: state.analytics),
          ],
        );
      },
      loading: () => const AnalyticsAsyncPanel.loading(
        title: 'Loading employee analytics',
      ),
      error: (error, _) => AnalyticsAsyncPanel.error(
        title: 'Unable to load employee analytics',
        description: error.toString(),
        action: TextButton(
          onPressed: () {
            ref.invalidate(employeeOverviewAnalyticsProvider);
          },
          child: const Text('Retry'),
        ),
      ),
    );
  }
}

class _EmployeeOverviewKpis extends StatelessWidget {
  const _EmployeeOverviewKpis({required this.analytics});

  final EmployeeOverviewAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 1200
            ? 4
            : constraints.maxWidth >= 720
            ? 2
            : 1;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppDimens.spaceLg,
          mainAxisSpacing: AppDimens.spaceLg,
          childAspectRatio: 1.15,
          children: [
            AnalyticsKpiCard(
              label: 'Total staff',
              value: analytics.totalEmployees.toString(),
              helper: '${analytics.activeEmployees} active teammates',
              icon: Icons.badge_rounded,
              trend: 2.2,
              trendPositive: true,
            ),
            AnalyticsKpiCard(
              label: 'Active / on leave',
              value:
                  '${analytics.activeEmployees} / ${analytics.onLeaveEmployees}',
              helper: '${analytics.inactiveEmployees} inactive profiles',
              icon: Icons.person_search_rounded,
              trend: 1.8,
              trendPositive: true,
            ),
            AnalyticsKpiCard(
              label: 'Utilization',
              value: '${analytics.utilizationRate.toStringAsFixed(1)}%',
              helper: 'Booked hours divided by scheduled capacity',
              icon: Icons.schedule_rounded,
              trend: analytics.utilizationDelta,
              trendPositive: true,
            ),
            AnalyticsKpiCard(
              label: 'Quality signal',
              value: '${analytics.averageRating.toStringAsFixed(1)}/5',
              helper: '${analytics.reviewCount} reviews across the roster',
              icon: Icons.star_rounded,
              trend: analytics.ratingDelta,
              trendPositive: true,
              badgeLabel: 'Reviews',
              badgeTone: AnalyticsStatusTone.warning,
            ),
          ],
        );
      },
    );
  }
}

class _EmployeeOverviewPanels extends StatelessWidget {
  const _EmployeeOverviewPanels({required this.analytics});

  final EmployeeOverviewAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 1200 ? 2 : 1;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppDimens.spaceLg,
          mainAxisSpacing: AppDimens.spaceLg,
          childAspectRatio: constraints.maxWidth >= 1200 ? 1.45 : 1.1,
          children: [
            _RoleDistributionPanel(items: analytics.roleDistribution),
            _WorkloadTrendPanel(points: analytics.trendPoints),
            _TopPerformersPanel(items: analytics.topPerformers),
            _CompliancePanel(items: analytics.complianceItems),
          ],
        );
      },
    );
  }
}

class _RoleDistributionPanel extends StatelessWidget {
  const _RoleDistributionPanel({required this.items});

  final List<EmployeeRoleDistribution> items;

  @override
  Widget build(BuildContext context) {
    final colors = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.tertiary,
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.primaryContainer,
    ];

    return AnalyticsPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AnalyticsSectionHeader(
            title: 'Role distribution',
            subtitle: 'Balance workforce capacity across care roles.',
            icon: Icons.pie_chart_rounded,
          ),
          AppDimens.verticalLarge,
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                      sections: [
                        for (var i = 0; i < items.length; i++)
                          PieChartSectionData(
                            value: items[i].count.toDouble(),
                            color: colors[i % colors.length],
                            title: items[i].count.toString(),
                            radius: 52,
                          ),
                      ],
                    ),
                  ),
                ),
                AppDimens.horizontalLarge,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < items.length; i++) ...[
                        _LegendRow(
                          color: colors[i % colors.length],
                          label: items[i].role,
                          value: items[i].count.toString(),
                        ),
                        AppDimens.verticalMediumSmall,
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkloadTrendPanel extends StatelessWidget {
  const _WorkloadTrendPanel({required this.points});

  final List<EmployeeTrendPoint> points;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnalyticsPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AnalyticsSectionHeader(
            title: 'Workload trend',
            subtitle: 'Session volume and contribution move across the period.',
            icon: Icons.stacked_bar_chart_rounded,
          ),
          AppDimens.verticalLarge,
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: colorScheme.outlineVariant, strokeWidth: 1),
                ),
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
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= points.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          points[index].label,
                          style: theme.textTheme.labelMedium,
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < points.length; i++)
                    BarChartGroupData(
                      x: i,
                      barsSpace: AppDimens.spaceXs,
                      barRods: [
                        BarChartRodData(
                          toY: points[i].sessions,
                          color: colorScheme.primary,
                          width: 14,
                          borderRadius: AppDimens.radiusSmall,
                        ),
                        BarChartRodData(
                          toY: points[i].contributionValue / 1000000,
                          color: colorScheme.tertiary,
                          width: 14,
                          borderRadius: AppDimens.radiusSmall,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopPerformersPanel extends StatelessWidget {
  const _TopPerformersPanel({required this.items});

  final List<EmployeePerformanceSummary> items;

  @override
  Widget build(BuildContext context) {
    final topItems = items.take(4).toList();

    return AnalyticsPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AnalyticsSectionHeader(
            title: 'Top performers',
            subtitle: 'High-rating team members with strong utilization.',
            icon: Icons.workspace_premium_rounded,
          ),
          AppDimens.verticalLarge,
          for (final item in topItems) ...[
            _TopPerformerRow(item: item),
            AppDimens.verticalMediumSmall,
          ],
        ],
      ),
    );
  }
}

class _CompliancePanel extends StatelessWidget {
  const _CompliancePanel({required this.items});

  final List<EmployeeComplianceItem> items;

  @override
  Widget build(BuildContext context) {
    return AnalyticsPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AnalyticsSectionHeader(
            title: 'Compliance posture',
            subtitle: 'Credential and emergency readiness across profiles.',
            icon: Icons.verified_user_rounded,
          ),
          AppDimens.verticalLarge,
          for (final item in items) ...[
            AnalyticsStatusBadge(label: item.title, tone: item.tone),
            AppDimens.verticalExtraSmall,
            Text(item.detail),
            AppDimens.verticalMedium,
          ],
        ],
      ),
    );
  }
}

class _TopPerformerRow extends StatelessWidget {
  const _TopPerformerRow({required this.item});

  final EmployeePerformanceSummary item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.employeeName,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: AppDimens.fontWeightBold,
                ),
              ),
              AppDimens.verticalExtraSmall,
              Text(
                '${item.roleLabel} • '
                '${item.utilizationRate.toStringAsFixed(1)}% utilization',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${item.rating.toStringAsFixed(1)}/5'),
            AppDimens.verticalExtraSmall,
            Text(_currency(item.contributionValue)),
          ],
        ),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppDimens.spaceMd,
          height: AppDimens.spaceMd,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppDimens.radiusSmall,
          ),
        ),
        AppDimens.horizontalSmall,
        Expanded(child: Text(label)),
        Text(value),
      ],
    );
  }
}

String _currency(double value) {
  final compact = value >= 1000000
      ? '${(value / 1000000).toStringAsFixed(1)}M'
      : '${(value / 1000).toStringAsFixed(0)}K';
  return '$compact₫';
}
