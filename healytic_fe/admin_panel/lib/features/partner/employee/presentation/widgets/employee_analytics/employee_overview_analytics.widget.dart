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

    final totalSessions = points.fold<double>(
      0,
      (value, point) => value + point.sessions,
    );
    final totalContribution = points.fold<double>(
      0,
      (value, point) => value + point.contributionValue,
    );
    final averageValuePerSession = totalSessions == 0
        ? 0.0
        : totalContribution / totalSessions;
    final bestValuePoint = points.reduce(
      (current, next) =>
          _valuePerSession(next) > _valuePerSession(current) ? next : current,
    );
    final maxSessions = points.fold<double>(
      0,
      (maxValue, point) =>
          point.sessions > maxValue ? point.sessions : maxValue,
    );

    return AnalyticsPanel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final chartHeight = constraints.maxWidth >= 760 ? 260.0 : 220.0;
          final titleStyle = theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AnalyticsSectionHeader(
                title: 'Workload efficiency',
                subtitle:
                    'Sessions, revenue yield, and peak workload by month.',
                icon: Icons.stacked_bar_chart_rounded,
              ),
              AppDimens.verticalMedium,
              Wrap(
                spacing: AppDimens.spaceSm,
                runSpacing: AppDimens.spaceSm,
                children: [
                  _WorkloadMetricChip(
                    label: 'Sessions',
                    value: totalSessions.toStringAsFixed(0),
                    icon: Icons.event_available_rounded,
                  ),
                  _WorkloadMetricChip(
                    label: 'Contribution',
                    value: _currency(totalContribution),
                    icon: Icons.payments_rounded,
                  ),
                  _WorkloadMetricChip(
                    label: 'Value / session',
                    value: _currency(averageValuePerSession),
                    icon: Icons.trending_up_rounded,
                  ),
                  _WorkloadMetricChip(
                    label: 'Best yield',
                    value: bestValuePoint.label,
                    icon: Icons.insights_rounded,
                  ),
                ],
              ),
              AppDimens.verticalLarge,
              SizedBox(
                height: chartHeight,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxSessions == 0 ? 1 : maxSessions * 1.25,
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
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: _chartInterval(maxSessions),
                          getTitlesWidget: (value, meta) {
                            if (value == 0) return const SizedBox.shrink();
                            return Text(
                              value.toInt().toString(),
                              style: titleStyle,
                            );
                          },
                        ),
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
                          barRods: [
                            BarChartRodData(
                              toY: points[i].sessions,
                              color: _workloadColor(
                                context,
                                _valuePerSession(points[i]),
                                averageValuePerSession,
                              ),
                              width: 20,
                              borderRadius: AppDimens.radiusSmall,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              AppDimens.verticalMedium,
              const _WorkloadLegend(),
            ],
          );
        },
      ),
    );
  }
}

class _WorkloadMetricChip extends StatelessWidget {
  const _WorkloadMetricChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: AppDimens.paddingHorizontalSmall.add(
        AppDimens.paddingVerticalExtraSmall,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(90),
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.primary),
          AppDimens.horizontalExtraSmall,
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          AppDimens.horizontalExtraSmall,
          Text(
            value,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: AppDimens.fontWeightBold,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkloadLegend extends StatelessWidget {
  const _WorkloadLegend();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: AppDimens.spaceMd,
      runSpacing: AppDimens.spaceXs,
      children: [
        _LegendPill(color: colorScheme.tertiary, label: 'Above avg yield'),
        _LegendPill(color: colorScheme.primary, label: 'Near avg yield'),
        _LegendPill(color: colorScheme.error, label: 'Below avg yield'),
      ],
    );
  }
}

class _LegendPill extends StatelessWidget {
  const _LegendPill({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppDimens.spaceSm,
          height: AppDimens.spaceSm,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        AppDimens.horizontalExtraSmall,
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _TopPerformersPanel extends StatelessWidget {
  const _TopPerformersPanel({required this.items});

  final List<EmployeePerformanceSummary> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final topItems = items.take(4).toList();

    if (topItems.isEmpty) {
      return const AnalyticsAsyncPanel.empty(
        title: 'No top performers yet',
        description:
            'Performance rankings will appear after staff accumulate ratings and bookings.',
      );
    }

    return AnalyticsPanel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 640;
          final maxUtilization = topItems.fold<double>(
            0,
            (maxValue, item) => item.utilizationRate > maxValue
                ? item.utilizationRate
                : maxValue,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnalyticsSectionHeader(
                title: 'Top performers',
                subtitle: 'Ranked by quality, utilization, and contribution.',
                icon: Icons.workspace_premium_rounded,
                trailing: Container(
                  padding: AppDimens.paddingHorizontalSmall.add(
                    AppDimens.paddingVerticalExtraSmall,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: AppDimens.radiusPill,
                  ),
                  child: Text(
                    'Top ${topItems.length}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: AppDimens.fontWeightBold,
                    ),
                  ),
                ),
              ),
              AppDimens.verticalLarge,
              if (!isCompact) const _TopPerformerTableHeader(),
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outlineVariant),
                  borderRadius: AppDimens.radiusMediumSmall,
                ),
                child: Column(
                  children: [
                    for (var index = 0; index < topItems.length; index++) ...[
                      _TopPerformerRow(
                        item: topItems[index],
                        rank: index + 1,
                        maxUtilization: maxUtilization,
                        isCompact: isCompact,
                      ),
                      if (index != topItems.length - 1)
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: colorScheme.outlineVariant,
                        ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TopPerformerTableHeader extends StatelessWidget {
  const _TopPerformerTableHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final style = theme.textTheme.labelSmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
      fontWeight: AppDimens.fontWeightBold,
    );

    return Container(
      padding: AppDimens.paddingHorizontalMedium.add(
        AppDimens.paddingVerticalSmall,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.42),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(flex: 5, child: Text('Staff member', style: style)),
          Expanded(flex: 3, child: Text('Utilization', style: style)),
          SizedBox(
            width: 84,
            child: Text('Rating', style: style, textAlign: TextAlign.right),
          ),
          SizedBox(
            width: 112,
            child: Text(
              'Contribution',
              style: style,
              textAlign: TextAlign.right,
            ),
          ),
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
  const _TopPerformerRow({
    required this.item,
    required this.rank,
    required this.maxUtilization,
    required this.isCompact,
  });

  final EmployeePerformanceSummary item;
  final int rank;
  final double maxUtilization;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final utilizationShare = maxUtilization <= 0
        ? 0.0
        : (item.utilizationRate / maxUtilization).clamp(0.0, 1.0);
    final details = _TopPerformerIdentity(item: item, rank: rank);
    final utilization = _UtilizationMetric(
      value: item.utilizationRate,
      share: utilizationShare,
    );
    final rating = _RatingMetric(value: item.rating);
    final contribution = _ContributionMetric(value: item.contributionValue);

    if (isCompact) {
      return Padding(
        padding: AppDimens.paddingAllMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            details,
            AppDimens.verticalMedium,
            utilization,
            AppDimens.verticalMediumSmall,
            Row(
              children: [
                Expanded(child: rating),
                AppDimens.horizontalMedium,
                contribution,
              ],
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: AppDimens.paddingHorizontalMedium.add(
        AppDimens.paddingVerticalMediumSmall,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 5, child: details),
          AppDimens.horizontalMedium,
          Expanded(flex: 3, child: utilization),
          AppDimens.horizontalMedium,
          SizedBox(width: 84, child: rating),
          AppDimens.horizontalMedium,
          SizedBox(width: 112, child: contribution),
        ],
      ),
    );
  }
}

class _TopPerformerIdentity extends StatelessWidget {
  const _TopPerformerIdentity({required this.item, required this.rank});

  final EmployeePerformanceSummary item;
  final int rank;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: rank == 1
                ? colorScheme.primary
                : colorScheme.surfaceContainerHighest,
            borderRadius: AppDimens.radiusPill,
          ),
          child: Text(
            '#$rank',
            style: theme.textTheme.labelMedium?.copyWith(
              color: rank == 1
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
              fontWeight: AppDimens.fontWeightBold,
            ),
          ),
        ),
        AppDimens.horizontalMedium,
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
                item.roleLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UtilizationMetric extends StatelessWidget {
  const _UtilizationMetric({required this.value, required this.share});

  final double value;
  final double share;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${value.toStringAsFixed(1)}%',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: AppDimens.fontWeightBold,
              ),
            ),
            AppDimens.horizontalSmall,
            Expanded(
              child: Text(
                'capacity',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        AppDimens.verticalExtraSmall,
        ClipRRect(
          borderRadius: AppDimens.radiusPill,
          child: LinearProgressIndicator(
            value: share,
            minHeight: 6,
            color: colorScheme.primary,
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),
        ),
      ],
    );
  }
}

class _RatingMetric extends StatelessWidget {
  const _RatingMetric({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: 18, color: colorScheme.tertiary),
        AppDimens.horizontalExtraSmall,
        Text(
          value.toStringAsFixed(1),
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: AppDimens.fontWeightBold,
          ),
        ),
        Text(
          '/5',
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ContributionMetric extends StatelessWidget {
  const _ContributionMetric({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _currency(value),
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: AppDimens.fontWeightBold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        AppDimens.verticalExtraSmall,
        Text(
          'Revenue',
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
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

Color _workloadColor(
  BuildContext context,
  double valuePerSession,
  double averageValuePerSession,
) {
  final colorScheme = Theme.of(context).colorScheme;
  if (averageValuePerSession == 0) return colorScheme.primary;
  if (valuePerSession >= averageValuePerSession * 1.08) {
    return colorScheme.tertiary;
  }
  if (valuePerSession <= averageValuePerSession * 0.92) {
    return colorScheme.error;
  }
  return colorScheme.primary;
}

double _valuePerSession(EmployeeTrendPoint point) {
  if (point.sessions == 0) return 0;
  return point.contributionValue / point.sessions;
}

double _chartInterval(double maxValue) {
  if (maxValue <= 5) return 1;
  if (maxValue <= 20) return 5;
  if (maxValue <= 50) return 10;
  return 25;
}

String _currency(double value) {
  final compact = value >= 1000000
      ? '${(value / 1000000).toStringAsFixed(1)}M'
      : '${(value / 1000).toStringAsFixed(0)}K';
  return '$compact₫';
}
