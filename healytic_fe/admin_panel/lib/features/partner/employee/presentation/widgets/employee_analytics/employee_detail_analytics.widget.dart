import 'package:admin_panel/features/common/widgets/analytics/analytics_async_panel.widget.dart';
import 'package:admin_panel/features/common/widgets/analytics/analytics_kpi_card.widget.dart';
import 'package:admin_panel/features/common/widgets/analytics/analytics_panel.widget.dart';
import 'package:admin_panel/features/common/widgets/analytics/analytics_period_filter.widget.dart';
import 'package:admin_panel/features/common/widgets/analytics/analytics_section_header.widget.dart';
import 'package:admin_panel/features/common/widgets/analytics/analytics_status_badge.widget.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_analytics.entity.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee_analytics.provider.dart';
import 'package:common/utils/demensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Full-width analytics block for employee detail pages.
class EmployeeDetailAnalyticsSection extends ConsumerWidget {
  const EmployeeDetailAnalyticsSection({super.key, required this.employee});

  final EmployeeEntity employee;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(
      employeeDetailAnalyticsProvider(employee.id.value),
    );

    return analyticsAsync.when(
      data: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnalyticsSectionHeader(
              title: '${_analyticsLabel(employee)} analytics',
              subtitle:
                  'Sessions, contribution, capacity load, and quality '
                  'signals for this profile.',
              icon: Icons.monitor_heart_rounded,
              trailing: AnalyticsPeriodFilter(
                selectedPeriod: state.selectedPeriod,
                onChanged: (period) {
                  ref
                      .read(
                        employeeDetailAnalyticsProvider(
                          employee.id.value,
                        ).notifier,
                      )
                      .setTimePeriod(period);
                },
              ),
            ),
            if (state.isRefreshing) ...[
              AppDimens.verticalSmall,
              const LinearProgressIndicator(),
            ],
            AppDimens.verticalLarge,
            _EmployeeDetailKpis(analytics: state.analytics),
            AppDimens.verticalLarge,
            _EmployeeDetailTopPanels(
              analytics: state.analytics,
              mixTitle: _mixTitle(employee),
            ),
            AppDimens.verticalLarge,
            _EmployeeQualityPanels(analytics: state.analytics),
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
            ref.invalidate(employeeDetailAnalyticsProvider(employee.id.value));
          },
          child: const Text('Retry'),
        ),
      ),
    );
  }
}

class _EmployeeDetailKpis extends StatelessWidget {
  const _EmployeeDetailKpis({required this.analytics});

  final EmployeeDetailAnalytics analytics;

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
              label: 'Completed sessions',
              value: analytics.completedSessions.toString(),
              helper: 'Completed services in the selected period',
              icon: Icons.task_alt_rounded,
              trend: analytics.sessionsDelta,
              trendPositive: true,
            ),
            AnalyticsKpiCard(
              label: 'Contribution',
              value: _currency(analytics.contributionValue),
              helper: 'Revenue or commission contribution estimate',
              icon: Icons.payments_rounded,
              trend: analytics.contributionDelta,
              trendPositive: true,
            ),
            AnalyticsKpiCard(
              label: 'Utilization',
              value: '${analytics.utilizationRate.toStringAsFixed(1)}%',
              helper: 'Booked hours divided by available hours',
              icon: Icons.schedule_rounded,
              trend: analytics.utilizationDelta,
              trendPositive: true,
            ),
            AnalyticsKpiCard(
              label: 'Average rating',
              value: '${analytics.averageRating.toStringAsFixed(1)}/5',
              helper: '${analytics.reviewCount} review submissions',
              icon: Icons.star_rounded,
              trend: 1.4,
              trendPositive: true,
              badgeLabel: 'Quality',
              badgeTone: AnalyticsStatusTone.warning,
            ),
          ],
        );
      },
    );
  }
}

class _EmployeeDetailTopPanels extends StatelessWidget {
  const _EmployeeDetailTopPanels({
    required this.analytics,
    required this.mixTitle,
  });

  final EmployeeDetailAnalytics analytics;
  final String mixTitle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1100;

        if (!isWide) {
          return Column(
            children: [
              _EmployeeTrendPanel(points: analytics.trendPoints),
              AppDimens.verticalLarge,
              _EmployeeMixPanel(title: mixTitle, items: analytics.mixMetrics),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: _EmployeeTrendPanel(points: analytics.trendPoints),
            ),
            AppDimens.horizontalLarge,
            Expanded(
              flex: 2,
              child: _EmployeeMixPanel(
                title: mixTitle,
                items: analytics.mixMetrics,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EmployeeTrendPanel extends StatelessWidget {
  const _EmployeeTrendPanel({required this.points});

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
            title: 'Sessions and value trend',
            subtitle: 'Monitor workload and financial contribution together.',
            icon: Icons.timeline_rounded,
          ),
          AppDimens.verticalLarge,
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
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
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                minX: 0,
                maxX: (points.length - 1).toDouble(),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (var i = 0; i < points.length; i++)
                        FlSpot(i.toDouble(), points[i].sessions),
                    ],
                    isCurved: true,
                    color: colorScheme.primary,
                    barWidth: 3,
                  ),
                  LineChartBarData(
                    spots: [
                      for (var i = 0; i < points.length; i++)
                        FlSpot(
                          i.toDouble(),
                          points[i].contributionValue / 1000000,
                        ),
                    ],
                    isCurved: true,
                    color: colorScheme.tertiary,
                    barWidth: 3,
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

class _EmployeeMixPanel extends StatelessWidget {
  const _EmployeeMixPanel({required this.title, required this.items});

  final String title;
  final List<EmployeeMixMetric> items;

  @override
  Widget build(BuildContext context) {
    return AnalyticsPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnalyticsSectionHeader(
            title: title,
            subtitle: 'Role-specific mix based on delivered work.',
            icon: Icons.filter_alt_rounded,
          ),
          AppDimens.verticalLarge,
          for (final item in items) ...[
            _MixRow(item: item),
            AppDimens.verticalMediumSmall,
          ],
        ],
      ),
    );
  }
}

class _EmployeeQualityPanels extends StatelessWidget {
  const _EmployeeQualityPanels({required this.analytics});

  final EmployeeDetailAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1100;

        if (!isWide) {
          return Column(
            children: [
              _ScheduleLoadPanel(items: analytics.scheduleLoad),
              AppDimens.verticalLarge,
              _QualityAndCompliancePanel(analytics: analytics),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: _ScheduleLoadPanel(items: analytics.scheduleLoad),
            ),
            AppDimens.horizontalLarge,
            Expanded(
              flex: 2,
              child: _QualityAndCompliancePanel(analytics: analytics),
            ),
          ],
        );
      },
    );
  }
}

class _ScheduleLoadPanel extends StatelessWidget {
  const _ScheduleLoadPanel({required this.items});

  final List<EmployeeScheduleLoad> items;

  @override
  Widget build(BuildContext context) {
    return AnalyticsPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AnalyticsSectionHeader(
            title: 'Booked vs available hours',
            subtitle: 'Weekly heat-style load view for the current profile.',
            icon: Icons.grid_view_rounded,
          ),
          AppDimens.verticalLarge,
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth >= 800 ? 3 : 2;

              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: AppDimens.spaceLg,
                mainAxisSpacing: AppDimens.spaceLg,
                childAspectRatio: 1.8,
                children: [
                  for (final item in items) _ScheduleLoadTile(item: item),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _QualityAndCompliancePanel extends StatelessWidget {
  const _QualityAndCompliancePanel({required this.analytics});

  final EmployeeDetailAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    return AnalyticsPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AnalyticsSectionHeader(
            title: 'Quality and compliance',
            subtitle: 'Service quality and readiness checks for this profile.',
            icon: Icons.fact_check_rounded,
          ),
          AppDimens.verticalLarge,
          for (final item in analytics.qualityMetrics) ...[
            AnalyticsStatusBadge(label: item.label, tone: item.tone),
            AppDimens.verticalExtraSmall,
            Text('${item.value} • ${item.detail}'),
            AppDimens.verticalMedium,
          ],
          Divider(color: Theme.of(context).colorScheme.outlineVariant),
          AppDimens.verticalMedium,
          for (final item in analytics.complianceItems) ...[
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

class _MixRow extends StatelessWidget {
  const _MixRow({required this.item});

  final EmployeeMixMetric item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: AppDimens.fontWeightBold,
                ),
              ),
            ),
            Text('${(item.share * 100).toStringAsFixed(0)}%'),
          ],
        ),
        AppDimens.verticalExtraSmall,
        ClipRRect(
          borderRadius: AppDimens.radiusPill,
          child: LinearProgressIndicator(
            value: item.share,
            minHeight: AppDimens.spaceMd,
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),
        ),
        AppDimens.verticalExtraSmall,
        Text(
          '${item.value} sessions',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ScheduleLoadTile extends StatelessWidget {
  const _ScheduleLoadTile({required this.item});

  final EmployeeScheduleLoad item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final utilization = item.availableHours == 0
        ? 0.0
        : item.bookedHours / item.availableHours;

    return Container(
      padding: AppDimens.paddingAllMedium,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
        borderRadius: AppDimens.radiusMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.label,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: AppDimens.fontWeightBold,
            ),
          ),
          AppDimens.verticalExtraSmall,
          Text(
            '${item.bookedHours.toStringAsFixed(1)}h booked',
            style: theme.textTheme.bodyMedium,
          ),
          AppDimens.verticalExtraSmall,
          Text(
            '${item.availableHours.toStringAsFixed(1)}h available',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          AppDimens.verticalMediumSmall,
          ClipRRect(
            borderRadius: AppDimens.radiusPill,
            child: LinearProgressIndicator(
              value: utilization,
              minHeight: AppDimens.spaceMd,
              backgroundColor: colorScheme.surface,
            ),
          ),
        ],
      ),
    );
  }
}

String _analyticsLabel(EmployeeEntity employee) {
  return switch (employee) {
    DoctorEntity _ => 'Doctor',
    SpaTherapistEntity _ => 'Spa therapist',
    MassageTherapistEntity _ => 'Massage therapist',
    BasicEmployeeEntity _ => 'Employee',
  };
}

String _mixTitle(EmployeeEntity employee) {
  return switch (employee) {
    DoctorEntity _ => 'Consultation and procedure mix',
    SpaTherapistEntity _ => 'Treatment and device mix',
    MassageTherapistEntity _ => 'Session and demand mix',
    BasicEmployeeEntity _ => 'Workload mix',
  };
}

String _currency(double value) {
  final compact = value >= 1000000
      ? '${(value / 1000000).toStringAsFixed(1)}M'
      : '${(value / 1000).toStringAsFixed(0)}K';
  return '$compact₫';
}
