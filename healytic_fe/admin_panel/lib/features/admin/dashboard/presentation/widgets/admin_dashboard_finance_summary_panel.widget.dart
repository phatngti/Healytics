import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_overview.entity.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_formatters.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_panel.widget.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class AdminDashboardFinanceSummaryPanel extends StatelessWidget {
  const AdminDashboardFinanceSummaryPanel({super.key, required this.overview});

  final AdminDashboardOverview overview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AdminDashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Finance Summary',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppDimens.spaceSm),
          Text(
            'Core monetization and loss indicators.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXl),
          _SummaryRow(
            label: 'Net Revenue',
            value: formatAdminCurrencyFull(overview.netRevenue),
          ),
          _SummaryRow(
            label: 'Refund Volume',
            value: formatAdminCurrencyFull(overview.refundAmount),
          ),
          _SummaryRow(
            label: 'Failed Payment Volume',
            value: formatAdminCurrencyFull(overview.failedPaymentAmount),
          ),
          _SummaryRow(
            label: 'Average Booking Value',
            value: formatAdminCurrencyFull(overview.averageBookingValue),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceSmMd),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spaceLg),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
