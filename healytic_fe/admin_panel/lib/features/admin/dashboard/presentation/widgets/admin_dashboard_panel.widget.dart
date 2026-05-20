import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Reusable card container for dashboard panels with
/// consistent surface color, border, shadow, and radius.
class AdminDashboardPanel extends StatelessWidget {
  const AdminDashboardPanel({
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
        borderRadius: const BorderRadius.all(
          Radius.circular(AppDimens.spaceXl),
        ),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: AppDimens.spaceXl,
            offset: const Offset(0, AppDimens.spaceSmMd),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
