import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Header row for analytics sections and panels.
class AnalyticsSectionHeader extends StatelessWidget {
  const AnalyticsSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final leading = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Container(
            padding: AppDimens.paddingAllSmall,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.45),
              borderRadius: AppDimens.radiusMediumSmall,
            ),
            child: Icon(
              icon,
              size: AppDimens.iconMd,
              color: colorScheme.primary,
            ),
          ),
          AppDimens.horizontalMedium,
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: AppDimens.fontWeightBold,
                ),
              ),
              if (subtitle != null) ...[
                AppDimens.verticalExtraSmall,
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final shouldStackTrailing =
            trailing != null && constraints.maxWidth < 920;

        if (shouldStackTrailing) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leading,
              AppDimens.verticalMedium,
              Align(alignment: Alignment.centerLeft, child: trailing!),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: leading),
            if (trailing != null) ...[AppDimens.horizontalMedium, trailing!],
          ],
        );
      },
    );
  }
}
