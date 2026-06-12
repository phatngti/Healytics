import 'dart:async';

import 'package:flutter/material.dart';
import 'package:user_app/router/app_router.dart';

typedef RootOverlayToastBuilder = Widget Function(VoidCallback dismiss);

class RootOverlayToast {
  static OverlayEntry? _currentEntry;
  static Timer? _currentTimer;

  const RootOverlayToast._();

  static bool show({
    required RootOverlayToastBuilder builder,
    Duration duration = const Duration(seconds: 4),
  }) {
    final overlay = rootNavigatorKey.currentState?.overlay;
    if (overlay == null) {
      return false;
    }

    _dismissCurrent();

    late final OverlayEntry entry;
    var dismissed = false;

    void dismiss() {
      if (dismissed) return;
      dismissed = true;

      if (identical(_currentEntry, entry)) {
        _currentTimer?.cancel();
        _currentTimer = null;
        _currentEntry = null;
      }

      if (entry.mounted) {
        entry.remove();
      }
    }

    entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _AnimatedToastEntry(child: builder(dismiss)),
        );
      },
    );

    _currentEntry = entry;
    overlay.insert(entry);
    _currentTimer = Timer(duration, dismiss);
    return true;
  }

  static void _dismissCurrent() {
    _currentTimer?.cancel();
    _currentTimer = null;

    final entry = _currentEntry;
    _currentEntry = null;

    if (entry?.mounted ?? false) {
      entry!.remove();
    }
  }
}

class _AnimatedToastEntry extends StatefulWidget {
  const _AnimatedToastEntry({required this.child});

  final Widget child;

  @override
  State<_AnimatedToastEntry> createState() => _AnimatedToastEntryState();
}

class _AnimatedToastEntryState extends State<_AnimatedToastEntry>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.6)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(opacity: _fadeAnimation, child: widget.child),
    );
  }
}
