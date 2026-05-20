import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Animated KPI card displaying a metric with trend.
///
/// Features:
/// - Animated count-up from 0 to the target value
/// - Trend indicator (up/down arrow with %)
/// - Stagger-ready via [delay] parameter
class KpiCard extends StatelessWidget {
  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.trend,
    this.trendPositive = true,
    this.prefix = '',
    this.suffix = '',
    this.delay = Duration.zero,
  });

  final String label;
  final double value;
  final IconData icon;
  final double? trend;
  final bool trendPositive;
  final String prefix;
  final String suffix;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimens.radiusMediumSmall,
            side: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Padding(
            padding: AppDimens.paddingAllMedium,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: AppDimens.paddingAllSmall,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(
                          alpha: 0.3,
                        ),
                        borderRadius: AppDimens.radiusSmall,
                      ),
                      child: Icon(
                        icon,
                        size: AppDimens.iconMd,
                        color: colorScheme.primary,
                      ),
                    ),
                    if (trend != null)
                      _TrendBadge(trend: trend!, isPositive: trendPositive),
                  ],
                ),
                const Spacer(),
                Text(
                  '$prefix'
                  '${_formatValue(animatedValue)}'
                  '$suffix',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: AppDimens.fontWeightBold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppDimens.verticalExtraSmall,
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatValue(double val) {
    if (val >= 1000000) {
      return '${(val / 1000000).toStringAsFixed(1)}M';
    }
    if (val >= 1000) {
      return '${(val / 1000).toStringAsFixed(1)}K';
    }
    if (val == val.roundToDouble()) {
      return val.toInt().toString();
    }
    return val.toStringAsFixed(1);
  }
}

class _TrendBadge extends StatelessWidget {
  const _TrendBadge({required this.trend, required this.isPositive});

  final double trend;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semanticColors = theme.extension<SemanticColors>();
    final color = isPositive
        ? semanticColors?.success ?? theme.colorScheme.primary
        : theme.colorScheme.error;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSm,
        vertical: AppDimens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppDimens.radiusMediumSmall,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            size: AppDimens.iconXs,
            color: color,
          ),
          AppDimens.horizontalExtraSmall,
          Text(
            '${trend.toStringAsFixed(1)}%',
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: AppDimens.fontWeightSemiBold,
            ),
          ),
        ],
      ),
    );
  }
}
