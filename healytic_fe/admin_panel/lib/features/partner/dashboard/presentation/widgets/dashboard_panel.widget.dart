import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

import 'dashboard_constants.dart';

/// Standard panel shell used across dashboard sections.
class DashboardPanel extends StatelessWidget {
  const DashboardPanel({
    super.key,
    required this.child,
    this.padding = AppDimens.paddingAllMediumLarge,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: DashboardSizes.panelBlurRadius,
            offset: DashboardSizes.panelShadowOffset,
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
