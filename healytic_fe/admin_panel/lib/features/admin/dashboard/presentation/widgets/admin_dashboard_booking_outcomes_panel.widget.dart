import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_booking_outcome.entity.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_formatters.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_panel.widget.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class AdminDashboardBookingOutcomesPanel extends StatelessWidget {
  const AdminDashboardBookingOutcomesPanel({super.key, required this.summary});

  final AdminDashboardBookingOutcomeSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AdminDashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Outcomes',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          AppDimens.verticalExtraSmall,
          Text(
            '${summary.totalBookings} total bookings in the selected period.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXl),
          _OutcomeRow(
            label: 'Successful',
            count: summary.success.count,
            rate: summary.success.rate,
            color:
                Theme.of(context).extension<SemanticColors>()?.success ??
                Colors.green,
          ),
          _OutcomeRow(
            label: 'Failed',
            count: summary.failed.count,
            rate: summary.failed.rate,
            color: colorScheme.error,
          ),
          _OutcomeRow(
            label: 'Canceled',
            count: summary.canceled.count,
            rate: summary.canceled.rate,
            color:
                Theme.of(context).extension<SemanticColors>()?.warning ??
                Colors.orange,
          ),
        ],
      ),
    );
  }
}

class _OutcomeRow extends StatelessWidget {
  const _OutcomeRow({
    required this.label,
    required this.count,
    required this.rate,
    required this.color,
  });

  final String label;
  final int count;
  final double rate;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '$count • ${formatAdminPercent(rate)}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          AppDimens.verticalSmall,
          ClipRRect(
            borderRadius: AppDimens.radiusPill,
            child: LinearProgressIndicator(
              value: rate / 100,
              minHeight: 10,
              color: color,
              backgroundColor: color.withValues(alpha: 0.12),
            ),
          ),
        ],
      ),
    );
  }
}
