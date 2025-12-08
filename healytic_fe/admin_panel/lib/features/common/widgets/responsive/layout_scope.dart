import 'package:flutter/material.dart';

class LayoutScope extends InheritedWidget {
  const LayoutScope({
    super.key,
    required this.sidebar,
    required this.header,
    required super.child,
  });

  final Widget sidebar;
  final Widget header;

  static LayoutScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LayoutScope>();
  }

  @override
  bool updateShouldNotify(LayoutScope oldWidget) {
    return sidebar != oldWidget.sidebar || header != oldWidget.header;
  }
}
