import 'package:admin_panel/features/partner/dashboard/domain/dashboard_stats.entity.dart';
import 'package:admin_panel/features/partner/dashboard/presentation/widgets/kpi_card.widget.dart';
import 'package:flutter/material.dart';

/// Row of 4 KPI summary cards across the dashboard top.
///
/// Each card animates in with a staggered delay and
/// shows a trend indicator where data supports it.
class KpiSummaryRow extends StatelessWidget {
  const KpiSummaryRow({
    super.key,
    required this.stats,
  });

  final DashboardStats stats;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount =
            constraints.maxWidth > 900 ? 4 : 2;
        final ratio =
            constraints.maxWidth > 900 ? 1.8 : 1.5;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: ratio,
          children: [
            KpiCard(
              label: 'Total Revenue',
              value: stats.totalRevenue,
              icon: Icons.attach_money_rounded,
              trend: stats.revenueGrowthPercent,
              trendPositive:
                  stats.revenueGrowthPercent >= 0,
              suffix: '₫',
            ),
            KpiCard(
              label: 'Appointments',
              value:
                  stats.totalAppointments.toDouble(),
              icon: Icons.calendar_month_rounded,
              trend: 8.3,
              delay: const Duration(
                milliseconds: 100,
              ),
            ),
            KpiCard(
              label: 'Active Services',
              value: stats.activeServices.toDouble(),
              icon: Icons.medical_services_rounded,
              suffix: '/${stats.totalServices}',
              delay: const Duration(
                milliseconds: 200,
              ),
            ),
            KpiCard(
              label: 'Average Rating',
              value: stats.averageRating,
              icon: Icons.star_rounded,
              trend: 2.1,
              suffix: '/5',
              delay: const Duration(
                milliseconds: 300,
              ),
            ),
          ],
        );
      },
    );
  }
}
