import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

enum AnalyticsStatusTone { neutral, positive, warning, critical }

/// Compact badge for status and risk messaging.
class AnalyticsStatusBadge extends StatelessWidget {
  const AnalyticsStatusBadge({
    super.key,
    required this.label,
    this.tone = AnalyticsStatusTone.neutral,
  });

  final String label;
  final AnalyticsStatusTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final semantic = theme.extension<SemanticColors>();

    final Color backgroundColor;
    final Color foregroundColor;

    switch (tone) {
      case AnalyticsStatusTone.positive:
        foregroundColor = semantic?.success ?? colorScheme.primary;
        backgroundColor = foregroundColor.withValues(alpha: 0.14);
      case AnalyticsStatusTone.warning:
        foregroundColor = semantic?.warning ?? Colors.orange;
        backgroundColor = foregroundColor.withValues(alpha: 0.16);
      case AnalyticsStatusTone.critical:
        foregroundColor = semantic?.error ?? colorScheme.error;
        backgroundColor = foregroundColor.withValues(alpha: 0.14);
      case AnalyticsStatusTone.neutral:
        foregroundColor = colorScheme.onSurfaceVariant;
        backgroundColor = colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.55,
        );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppDimens.radiusPill,
      ),
      child: Padding(
        padding: AppDimens.paddingHorizontalSmall.add(
          AppDimens.paddingVerticalExtraSmall,
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: foregroundColor,
            fontWeight: AppDimens.fontWeightSemiBold,
          ),
        ),
      ),
    );
  }
}
