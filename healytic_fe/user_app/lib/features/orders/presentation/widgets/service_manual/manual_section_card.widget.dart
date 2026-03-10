import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Reusable card container for service manual sections.
///
/// Shows a leading icon in a circle, a section title,
/// and arbitrary [child] content — matching the HTML
/// reference's section card pattern.
class ManualSectionCard extends StatelessWidget {
  const ManualSectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    this.trailing,
    this.padding,
  });

  /// Leading icon displayed in a tinted circle.
  final IconData icon;

  /// Section heading text.
  final String title;

  /// Optional trailing widget (e.g. rating value).
  final Widget? trailing;

  /// Override for inner padding — defaults to 20.
  final EdgeInsetsGeometry? padding;

  /// Section body content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final effectivePadding = padding ?? AppDimens.paddingAllMediumLarge;

    return Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.03),
            blurRadius: AppDimens.spaceXl,
            offset: const Offset(0, AppDimens.spaceXs),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(icon: icon, title: title, trailing: trailing),
          AppDimens.verticalMedium,
          child,
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.icon, required this.title, this.trailing});

  final IconData icon;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: AppDimens.ctaButtonMd,
          height: AppDimens.ctaButtonMd,
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: AppDimens.iconMd, color: colors.primary),
        ),
        AppDimens.horizontalMediumSmall,
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
