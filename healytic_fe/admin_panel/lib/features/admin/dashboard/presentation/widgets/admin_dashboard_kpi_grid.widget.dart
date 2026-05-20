import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_overview.entity.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_formatters.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_panel.widget.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class AdminDashboardKpiGrid extends StatelessWidget {
  const AdminDashboardKpiGrid({super.key, required this.overview});

  final AdminDashboardOverview overview;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 1200
            ? 4
            : constraints.maxWidth >= 700
            ? 2
            : 1;
        final ratio = constraints.maxWidth >= 1200 ? 2.2 : 2.8;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppDimens.spaceLg,
          mainAxisSpacing: AppDimens.spaceLg,
          childAspectRatio: ratio,
          children: [
            _KpiTile(
              title: 'Gross Revenue',
              value: formatAdminCurrency(overview.grossRevenue),
              hint: formatAdminCurrencyFull(overview.netRevenue),
              icon: Icons.payments_outlined,
            ),
            _KpiTile(
              title: 'Successful Transactions',
              value: overview.successfulTransactions.toString(),
              hint: '${overview.pendingTransactions} pending',
              icon: Icons.receipt_long_rounded,
            ),
            _KpiTile(
              title: 'Total Partners',
              value: overview.totalPartners.toString(),
              hint: '${overview.pendingPartnerReviews} pending reviews',
              icon: Icons.health_and_safety_outlined,
            ),
            _KpiTile(
              title: 'Booking Success Rate',
              value: formatAdminPercent(overview.bookingSuccessRate),
              hint: '${formatAdminPercent(overview.bookingFailedRate)} failed',
              icon: Icons.task_alt_rounded,
            ),
            _KpiTile(
              title: 'Booking Failed Rate',
              value: formatAdminPercent(overview.bookingFailedRate),
              hint: 'Payments and booking retries',
              icon: Icons.error_outline_rounded,
            ),
            _KpiTile(
              title: 'Booking Canceled Rate',
              value: formatAdminPercent(overview.bookingCanceledRate),
              hint: 'Canceled appointments/orders',
              icon: Icons.cancel_outlined,
            ),
            _KpiTile(
              title: 'Average Booking Value',
              value: formatAdminCurrency(overview.averageBookingValue),
              hint: 'Per successful booking',
              icon: Icons.stacked_line_chart_rounded,
            ),
            _KpiTile(
              title: 'Notification Volume',
              value: overview.notificationVolume.toString(),
              hint: 'Recent operational signals',
              icon: Icons.notifications_active_outlined,
            ),
          ],
        );
      },
    );
  }
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({
    required this.title,
    required this.value,
    required this.hint,
    required this.icon,
  });

  final String title;
  final String value;
  final String hint;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AdminDashboardPanel(
      padding: AppDimens.paddingAllMediumLarge,
      child: Row(
        children: [
          Container(
            height: AppDimens.ctaButtonMd,
            width: AppDimens.ctaButtonMd,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: AppDimens.radiusMediumSmall,
            ),
            child: Icon(icon, color: colorScheme.primary),
          ),
          AppDimens.horizontalMediumSmall,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                AppDimens.verticalExtraSmall,
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                AppDimens.verticalExtraSmall,
                Text(
                  hint,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
