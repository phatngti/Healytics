import 'package:common/widgets/images/avatar.dart';
import 'package:common/utils/demensions.dart';
import 'package:admin_panel/utils/device.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Header extends HookConsumerWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        toolbarHeight: DeviceUtils.getAppBarHeight() * 0.8,
        leading: !DeviceUtils.isDesktopScreen(context)
            ? IconButton(
                onPressed: () {},
                icon: const Icon(Icons.admin_panel_settings_outlined, size: 16),
              )
            : null,
        title: null,
        actions: [
          // Notification
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, size: 16),
          ),
          AppDimens.horizontalSmall,
          // Profile
          Padding(
            padding: AppDimens.paddingHorizontalMedium,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AvatarImage(name: "John Doe", radius: 14),
                AppDimens.horizontalSmall,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "John Doe",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Admin',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(DeviceUtils.getAppBarHeight() + 5);
}
