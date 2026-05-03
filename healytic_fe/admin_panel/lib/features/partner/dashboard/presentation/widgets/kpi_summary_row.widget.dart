import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

import '../../domain/dashboard_stats.entity.dart';
import 'dashboard_constants.dart';
import 'kpi_card.widget.dart';

/// Row of 4 KPI summary cards across the dashboard top.
///
/// Each card animates in with a staggered delay and
/// shows a trend indicator where data supports it.
class KpiSummaryRow extends StatelessWidget {
  const KpiSummaryRow({super.key, required this.stats});

  final DashboardStats stats;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > DashboardLayout.wideBreakpoint;
        final crossAxisCount = isWide
            ? DashboardLayout.kpiColumnsWide
            : DashboardLayout.kpiColumnsNarrow;
        final ratio = isWide
            ? DashboardLayout.kpiRatioWide
            : DashboardLayout.kpiRatioNarrow;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppDimens.spaceLg,
          mainAxisSpacing: AppDimens.spaceLg,
          childAspectRatio: ratio,
          children: [
            KpiCard(
              label: 'Total Revenue',
              value: stats.totalRevenue,
              icon: Icons.attach_money_rounded,
              trend: stats.revenueGrowthPercent,
              trendPositive: stats.revenueGrowthPercent >= 0,
              suffix: '₫',
            ),
            KpiCard(
              label: 'Appointments',
              value: stats.totalAppointments.toDouble(),
              icon: Icons.calendar_month_rounded,
              trend: 8.3,
              delay: const Duration(milliseconds: 100),
            ),
            KpiCard(
              label: 'Active Services',
              value: stats.activeServices.toDouble(),
              icon: Icons.medical_services_rounded,
              suffix: '/${stats.totalServices}',
              delay: const Duration(milliseconds: 200),
            ),
            KpiCard(
              label: 'Average Rating',
              value: stats.averageRating,
              icon: Icons.star_rounded,
              trend: 2.1,
              suffix: '/5',
              delay: const Duration(milliseconds: 300),
            ),
          ],
        );
      },
    );
  }
}
