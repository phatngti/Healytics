import 'dart:ui';

import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatefulWidget {
  const AppBackButton({required this.onTap});

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
            size: 16,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
    );
  }
}
