import 'package:admin_panel/features/common/widgets/responsive/layout_scope.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    final layoutScope = LayoutScope.of(context);
    final sidebar = layoutScope?.sidebar ?? const SizedBox.shrink();
    final header = layoutScope?.header ?? const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        title: header,
        automaticallyImplyLeading: true, // Shows hamburger menu for drawer
      ),
      drawer: sidebar,
      body: Padding(padding: AppDimens.paddingAllSmall, child: body),
    );
  }
}
