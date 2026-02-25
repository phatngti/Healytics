import 'dart:ui';

import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// A styled back/navigation button with press animation feedback.
///
/// Renders a left-arrow icon inside a rounded container that
/// visually responds to tap gestures by changing its background color.
/// Uses responsive icon sizing from [AppDimens].
///
/// ```dart
/// AppBackButton(
///   onTap: () => Navigator.of(context).pop(),
/// )
/// ```
class AppBackButton extends StatefulWidget {
  /// Creates an [AppBackButton].
  ///
  /// - [onTap] — Callback invoked when the button is tapped (e.g. pop navigation).
  const AppBackButton({required this.onTap});

  /// Callback triggered when the user taps the back button.
  final VoidCallback onTap;

  @override
  State<AppBackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<AppBackButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          padding: AppDimens.paddingAllSmall,
          decoration: BoxDecoration(
            color: _isPressed
                ? Theme.of(context).colorScheme.surfaceDim
                : Theme.of(context).colorScheme.surface,
            shape: BoxShape.rectangle,
            borderRadius: AppDimens.radiusSmall,
            border: Border.all(color: Theme.of(context).colorScheme.surfaceDim),
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: AppDimens.responsiveIconSize(context),
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
    );
  }
}
