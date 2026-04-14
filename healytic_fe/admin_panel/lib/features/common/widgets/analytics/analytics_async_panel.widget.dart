import 'package:admin_panel/features/common/widgets/analytics/analytics_panel.widget.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Loading, error, and empty panel states for analytics widgets.
class AnalyticsAsyncPanel extends StatelessWidget {
  const AnalyticsAsyncPanel.loading({super.key, required this.title})
    : description = 'Loading the latest analytics snapshot.',
      action = null,
      icon = Icons.stacked_line_chart_rounded;

  const AnalyticsAsyncPanel.empty({
    super.key,
    required this.title,
    required this.description,
    this.action,
  }) : icon = Icons.insights_outlined;

  const AnalyticsAsyncPanel.error({
    super.key,
    required this.title,
    required this.description,
    this.action,
  }) : icon = Icons.error_outline_rounded;

  final String title;
  final String description;
  final Widget? action;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnalyticsPanel(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppDimens.iconXxl, color: colorScheme.primary),
            AppDimens.verticalMedium,
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: AppDimens.fontWeightBold,
              ),
              textAlign: TextAlign.center,
            ),
            AppDimens.verticalExtraSmall,
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[AppDimens.verticalMedium, action!],
            if (icon == Icons.stacked_line_chart_rounded) ...[
              AppDimens.verticalMedium,
              const CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}
