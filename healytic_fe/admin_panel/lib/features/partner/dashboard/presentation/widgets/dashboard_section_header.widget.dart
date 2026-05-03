import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

import 'dashboard_constants.dart';

/// Reusable section header for dashboard panels.
///
/// Displays a title with an optional trailing action
/// button (e.g., "View All", "See Details").
class DashboardSectionHeader extends StatelessWidget {
  const DashboardSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.icon,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: AppDimens.spaceLg.paddingBottom,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                if (icon != null) ...[
                  Container(
                    width: DashboardSizes.sectionIconContainer,
                    height: DashboardSizes.sectionIconContainer,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.10),
                      borderRadius: AppDimens.radiusMediumSmall,
                    ),
                    child: Icon(
                      icon,
                      size: AppDimens.iconSmMd,
                      color: colorScheme.primary,
                    ),
                  ),
                  AppDimens.horizontalMediumSmall,
                ],
                Flexible(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: AppDimens.fontWeightBold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (actionLabel != null)
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMd,
                  vertical: AppDimens.spaceSm,
                ),
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: AppDimens.radiusMediumSmall,
                ),
              ),
              onPressed: onAction,
              child: Text(
                actionLabel!,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: AppDimens.fontWeightSemiBold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
