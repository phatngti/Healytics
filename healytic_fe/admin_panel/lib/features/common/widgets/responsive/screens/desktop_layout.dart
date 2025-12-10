import 'package:admin_panel/features/common/widgets/responsive/layout_scope.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    final layoutScope = LayoutScope.of(context);
    final sidebar = layoutScope?.sidebar ?? const SizedBox.shrink();
    final header = layoutScope?.header ?? const SizedBox.shrink();

    return Scaffold(
      body: Row(
        children: [
          Expanded(child: sidebar),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsetsGeometry.only(
                    right: AppDimens.paddingHorizontalSmall.right,
                  ),
                  child: header,
                ),
                // Body
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    child: body,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
