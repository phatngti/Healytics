import 'package:flutter/material.dart';

/// Uppercase label for detail card sections.
///
/// Renders the HTML `label-caps` token: uppercase,
/// 600w, outline color, 0.5px letter-spacing.
class DetailSectionHeader extends StatelessWidget {
  /// The section title text (uppercased automatically).
  final String title;

  const DetailSectionHeader({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context)
          .textTheme
          .labelSmall
          ?.copyWith(
            color: Theme.of(context).colorScheme.outline,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
    );
  }
}
