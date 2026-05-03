import 'package:admin_panel/features/partner/dashboard/domain/dashboard_time_period.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Period selector used across analytics views.
class AnalyticsPeriodFilter extends StatelessWidget {
  const AnalyticsPeriodFilter({
    super.key,
    required this.selectedPeriod,
    required this.onChanged,
  });

  final DashboardTimePeriod selectedPeriod;
  final ValueChanged<DashboardTimePeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: AppDimens.paddingHorizontalSmall.add(
        AppDimens.paddingVerticalExtraSmall,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: AppDimens.radiusPill,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DashboardTimePeriod>(
          value: selectedPeriod,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: AppDimens.iconMd,
            color: colorScheme.onSurfaceVariant,
          ),
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: AppDimens.fontWeightMedium,
          ),
          borderRadius: AppDimens.radiusMedium,
          dropdownColor: colorScheme.surface,
          items: DashboardTimePeriod.values
              .map(
                (period) => DropdownMenuItem<DashboardTimePeriod>(
                  value: period,
                  child: Text(period.displayName),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }
}
