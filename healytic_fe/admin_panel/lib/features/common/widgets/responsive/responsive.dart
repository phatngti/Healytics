import 'package:admin_panel/features/common/widgets/responsive/layout_scope.dart';
import 'package:admin_panel/features/common/widgets/responsive/layouts/header.dart';
import 'package:admin_panel/features/common/widgets/responsive/layouts/sidebar.dart';
import 'package:admin_panel/features/common/widgets/responsive/screens/desktop_layout.dart';
import 'package:admin_panel/features/common/widgets/responsive/screens/mobile_layout.dart';
import 'package:admin_panel/features/common/widgets/responsive/screens/tablet_layout.dart';
import 'package:flutter/material.dart';

class ResponsiveWrapper extends StatelessWidget {
  const ResponsiveWrapper({
    super.key,
    this.desktop,
    this.tablet,
    this.mobile,
    this.useLayout = false,
    this.sidebar,
    this.header,
  });

  final Widget? desktop;
  final Widget? tablet;
  final Widget? mobile;
  final bool? useLayout;
  final Widget? sidebar;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    return LayoutScope(
      sidebar: sidebar ?? const Sidebar(),
      header: header ?? const Header(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 1200) {
            return useLayout == true
                ? DesktopLayout(body: desktop ?? const SizedBox.shrink())
                : desktop ?? const SizedBox.shrink();
          } else if (constraints.maxWidth >= 800) {
            return useLayout == true
                ? TabletLayout(body: tablet ?? const SizedBox.shrink())
                : tablet ?? const SizedBox.shrink();
          } else {
            return useLayout == true
                ? MobileLayout(body: mobile ?? const SizedBox.shrink())
                : mobile ?? const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
