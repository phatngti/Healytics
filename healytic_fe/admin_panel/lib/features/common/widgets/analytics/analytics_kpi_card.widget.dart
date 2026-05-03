import 'package:admin_panel/features/common/widgets/analytics/analytics_status_badge.widget.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// KPI card for analytics pages.
class AnalyticsKpiCard extends StatelessWidget {
  const AnalyticsKpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.helper,
    required this.icon,
    this.trend,
    this.trendPositive = true,
    this.badgeLabel,
    this.badgeTone = AnalyticsStatusTone.neutral,
  });

  final String label;
  final String value;
  final String helper;
  final IconData icon;
  final double? trend;
  final bool trendPositive;
  final String? badgeLabel;
  final AnalyticsStatusTone badgeTone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final semantic = theme.extension<SemanticColors>();
    final trendColor = trendPositive
        ? semantic?.success ?? colorScheme.primary
        : semantic?.error ?? colorScheme.error;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(
          color: colorScheme.outlineVariant
              .withValues(alpha: 0.55),
        ),
      ),
      padding: AppDimens.paddingAllMedium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: AppDimens.paddingAllSmall,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer
                      .withValues(alpha: 0.4),
                  borderRadius: AppDimens.radiusMediumSmall,
                ),
                child: Icon(
                  icon,
                  size: AppDimens.iconMd,
                  color: colorScheme.primary,
                ),
              ),
              const Spacer(),
              if (badgeLabel != null)
                AnalyticsStatusBadge(
                  label: badgeLabel!,
                  tone: badgeTone,
                ),
            ],
          ),
          AppDimens.verticalSmall,
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: AppDimens.fontWeightBold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          AppDimens.verticalExtraSmall,
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          if (trend != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  trendPositive
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  size: AppDimens.iconSm,
                  color: trendColor,
                ),
                AppDimens.horizontalExtraSmall,
                Text(
                  '${trend!.toStringAsFixed(1)}%',
                  style:
                      theme.textTheme.labelLarge?.copyWith(
                    color: trendColor,
                    fontWeight: AppDimens.fontWeightSemiBold,
                  ),
                ),
              ],
            ),
          Text(
            helper,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
