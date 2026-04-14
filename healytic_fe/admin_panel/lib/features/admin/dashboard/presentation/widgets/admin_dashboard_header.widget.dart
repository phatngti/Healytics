import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_period.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_formatters.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class AdminDashboardHeader extends StatelessWidget {
  const AdminDashboardHeader({
    super.key,
    required this.selectedPeriod,
    required this.lastUpdatedAt,
    required this.isRefreshing,
    required this.onPeriodChanged,
    required this.onRefresh,
    required this.onOpenProviderQueue,
    required this.onManageCategories,
  });

  final AdminDashboardPeriod selectedPeriod;
  final DateTime lastUpdatedAt;
  final bool isRefreshing;
  final ValueChanged<AdminDashboardPeriod> onPeriodChanged;
  final VoidCallback onRefresh;
  final VoidCallback onOpenProviderQueue;
  final VoidCallback onManageCategories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Wrap(
      spacing: AppDimens.spaceLg,
      runSpacing: AppDimens.spaceLg,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin Dashboard',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              AppDimens.verticalSmall,
              Text(
                'Track marketplace revenue, booking outcomes, partner performance, and platform health in one workspace.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              AppDimens.verticalMediumSmall,
              Text(
                isRefreshing
                    ? 'Refreshing latest dashboard data...'
                    : 'Last updated ${formatAdminDateTime(lastUpdatedAt)}',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Wrap(
            spacing: AppDimens.spaceMd,
            runSpacing: AppDimens.spaceMd,
            alignment: WrapAlignment.end,
            children: [
              SegmentedButton<AdminDashboardPeriod>(
                segments: AdminDashboardPeriod.values
                    .map(
                      (item) =>
                          ButtonSegment(value: item, label: Text(item.label)),
                    )
                    .toList(),
                selected: {selectedPeriod},
                onSelectionChanged: (value) => onPeriodChanged(value.first),
              ),
              FilledButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Refresh'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
