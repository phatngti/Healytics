import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_category_health.entity.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_panel.widget.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class AdminDashboardCategoryHealthPanel extends StatelessWidget {
  const AdminDashboardCategoryHealthPanel({
    super.key,
    required this.categoryHealth,
  });

  final AdminCategoryHealth categoryHealth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AdminDashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category Health',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppDimens.spaceSm),
          Text(
            'Category coverage and service mapping quality across the marketplace.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXl),
          Wrap(
            spacing: AppDimens.spaceMd,
            runSpacing: AppDimens.spaceMd,
            children: [
              _TinyMetric(
                label: 'Total',
                value: categoryHealth.totalCategories.toString(),
              ),
              _TinyMetric(
                label: 'Active',
                value: categoryHealth.activeCategories.toString(),
              ),
              _TinyMetric(
                label: 'Inactive',
                value: categoryHealth.inactiveCategories.toString(),
              ),
              _TinyMetric(
                label: 'Empty',
                value: categoryHealth.emptyCategories.toString(),
              ),
              _TinyMetric(
                label: 'Mapped Services',
                value: categoryHealth.totalMappedServices.toString(),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceXl),
          ...categoryHealth.topCategories.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.spaceMd),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    '${item.serviceCount} services',
                    style: theme.textTheme.labelLarge,
                  ),
                  AppDimens.horizontalMediumSmall,
                  Icon(
                    item.isActive ? Icons.check_circle : Icons.pause_circle,
                    color: item.isActive
                        ? (theme.extension<SemanticColors>()?.success ??
                              Colors.green)
                        : (theme.extension<SemanticColors>()?.warning ??
                              Colors.orange),
                    size: AppDimens.iconSmMd,
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

class _TinyMetric extends StatelessWidget {
  const _TinyMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 120,
      padding: AppDimens.paddingAllMediumSmall,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.42),
        borderRadius: AppDimens.radiusMediumSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          AppDimens.verticalExtraSmall,
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
