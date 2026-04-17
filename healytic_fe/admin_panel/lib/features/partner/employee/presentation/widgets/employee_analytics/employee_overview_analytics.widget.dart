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
        final childAspectRatio = constraints.maxWidth >= 1320
            ? 1.22
            : constraints.maxWidth >= 760
            ? 1.08
            : 0.96;

        return GridView.extent(
          maxCrossAxisExtent: 320,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppDimens.spaceLg,
          mainAxisSpacing: AppDimens.spaceLg,
          childAspectRatio: childAspectRatio,
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
        final isWideDesktop = constraints.maxWidth >= 1180;

        if (!isWideDesktop) {
          return Column(
            children: [
              _RoleDistributionPanel(items: analytics.roleDistribution),
              AppDimens.verticalLarge,
              _WorkloadTrendPanel(points: analytics.trendPoints),
              AppDimens.verticalLarge,
              _TopPerformersPanel(items: analytics.topPerformers),
              AppDimens.verticalLarge,
              _CompliancePanel(items: analytics.complianceItems),
            ],
          );
        }

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _RoleDistributionPanel(
                    items: analytics.roleDistribution,
                  ),
                ),
                AppDimens.horizontalLarge,
                Expanded(
                  child: _WorkloadTrendPanel(points: analytics.trendPoints),
                ),
              ],
            ),
            AppDimens.verticalLarge,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _TopPerformersPanel(items: analytics.topPerformers),
                ),
                AppDimens.horizontalLarge,
                Expanded(
                  child: _CompliancePanel(items: analytics.complianceItems),
                ),
              ],
            ),
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

    if (items.isEmpty) {
      return const AnalyticsAsyncPanel.empty(
        title: 'No role distribution data',
        description:
            'Role distribution will appear once employee records are available.',
      );
    }

    return AnalyticsPanel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 760;
          final chart = SizedBox(
            height: isWide ? 220 : 240,
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
          );

          final legend = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < items.length; i++) ...[
                _LegendRow(
                  color: colors[i % colors.length],
                  label: items[i].role,
                  value: items[i].count.toString(),
                ),
                if (i != items.length - 1) AppDimens.verticalMediumSmall,
              ],
            ],
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AnalyticsSectionHeader(
                title: 'Role distribution',
                subtitle: 'Balance workforce capacity across care roles.',
                icon: Icons.pie_chart_rounded,
              ),
              AppDimens.verticalLarge,
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: chart),
                    AppDimens.horizontalLarge,
                    Expanded(child: legend),
                  ],
                )
              else ...[
                chart,
                AppDimens.verticalLarge,
                legend,
              ],
            ],
          );
        },
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

    if (points.isEmpty) {
      return const AnalyticsAsyncPanel.empty(
        title: 'No workload trend data',
        description:
            'Workload trends will appear once bookings and contribution data are available.',
      );
    }

    final maxY = points.fold<double>(0, (maxValue, point) {
      final pointPeak = point.sessions > point.contributionValue / 1000000
          ? point.sessions
          : point.contributionValue / 1000000;
      return pointPeak > maxValue ? pointPeak : maxValue;
    });

    return AnalyticsPanel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final chartHeight = constraints.maxWidth >= 760 ? 260.0 : 220.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AnalyticsSectionHeader(
                title: 'Workload trend',
                subtitle:
                    'Session volume and contribution move across the period.',
                icon: Icons.stacked_bar_chart_rounded,
              ),
              AppDimens.verticalLarge,
              SizedBox(
                height: chartHeight,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxY == 0 ? 1 : maxY * 1.2,
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: colorScheme.outlineVariant,
                        strokeWidth: 1,
                      ),
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
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= points.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: AppDimens.paddingTopSmall,
                              child: Text(
                                points[index].label,
                                style: theme.textTheme.labelMedium,
                              ),
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
          );
        },
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

    if (topItems.isEmpty) {
      return const AnalyticsAsyncPanel.empty(
        title: 'No top performers yet',
        description:
            'Performance rankings will appear after staff accumulate ratings and bookings.',
      );
    }

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
    if (items.isEmpty) {
      return const AnalyticsAsyncPanel.empty(
        title: 'No compliance summary yet',
        description:
            'Compliance checks will appear after the workforce profile data is evaluated.',
      );
    }

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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              AppDimens.verticalExtraSmall,
              Text(
                '${item.roleLabel} • '
                '${item.utilizationRate.toStringAsFixed(1)}% utilization',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        AppDimens.horizontalMedium,
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
