import 'package:admin_panel/core/utils/user_role_helper.dart';
import 'package:common/widgets/images/circular.dart';
import 'package:admin_panel/features/common/widgets/responsive/layouts/widgets/menu_item.dart';
import 'package:admin_panel/router/app_router.dart';
import 'package:common/utils/demensions.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key, this.width});

  final double? width;

  @override
  Widget build(BuildContext context) {
    final isAdmin = UserRoleHelper.isAdmin();

    return Drawer(
      width: width ?? AppDimens.sidebarWidth,
      shape: BeveledRectangleBorder(),
      child: Container(
        padding: AppDimens.paddingVerticalMedium,
        color: Theme.of(context).colorScheme.onPrimary,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircularImage(
                image: AssetImage('assets/images/intro.png'),
                size: 35,
              ),
              AppDimens.verticalLarge,
              Padding(
                padding: AppDimens.paddingHorizontalMedium,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children:
                      (isAdmin ? adminSlideMenuItems : providerSlideMenuItems)
                          .map((item) => _SidebarItem(item: item))
                          .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    // This lookup will now only cause _SidebarItem to rebuild, not the whole Sidebar
    final String itemRoute = item['route'];
    final String currentRoute = GoRouterState.of(context).uri.toString();
    final isSelected =
        currentRoute == itemRoute || currentRoute.startsWith('$itemRoute/');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HoverContainer(
          label: item['label'],
          icon: item['icon'],
          onTap: () {
            context.go(item['route']);
          },
          isSelected: isSelected,
        ),
        AppDimens.verticalSmall,
      ],
    );
  }
}
