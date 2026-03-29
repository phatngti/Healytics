import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Flat section container for the service manual.
///
/// Displays a bold section title and arbitrary [child]
/// content. No card decoration — the parent screen
/// uses dividers between sections.
class ManualSectionCard extends StatelessWidget {
  const ManualSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.padding,
  });

  /// Section heading text.
  final String title;

  /// Optional trailing widget (e.g. rating value).
  final Widget? trailing;

  /// Override for inner padding.
  final EdgeInsetsGeometry? padding;

  /// Section body content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectivePadding =
        padding ?? const EdgeInsets.only(top: AppDimens.spaceLg);

    return Padding(
      padding: effectivePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(title: title, trailing: trailing),
          AppDimens.verticalMedium,
          child,
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
