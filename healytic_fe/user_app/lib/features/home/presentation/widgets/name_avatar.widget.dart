import 'package:flutter/material.dart';

/// A circular avatar displaying the user's initials with a
/// deterministic, theme-derived background colour.
class NameAvatar extends StatelessWidget {
  final String name;
  final double radius;
  final double? fontSize;

  const NameAvatar({
    super.key,
    required this.name,
    this.radius = 24.0,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CircleAvatar(
      radius: radius,
      backgroundColor: _getAvatarColor(context, name),
      child: Text(
        _getInitials(name),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: fontSize ?? (radius * 0.8),
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }

  /// Extracts up to two initials from [name].
  String _getInitials(String name) {
    if (name.isEmpty) return '?';

    final parts = name.trim().split(RegExp(r'\s+'));
    final first = parts.first[0].toUpperCase();

    if (parts.length > 1) {
      return first + parts.last[0].toUpperCase();
    }
    return first;
  }

  /// Returns a consistent colour derived from the theme's
  /// [ColorScheme]. The name's hash selects from a palette
  /// so that the same name always maps to the same colour.
  Color _getAvatarColor(BuildContext context, String name) {
    final cs = Theme.of(context).colorScheme;
    final palette = [
      cs.primary,
      cs.secondary,
      cs.tertiary,
      cs.error,
      cs.primaryContainer,
      cs.secondaryContainer,
      cs.tertiaryContainer,
      cs.errorContainer,
    ];
    return palette[name.hashCode.abs() % palette.length];
  }
}
