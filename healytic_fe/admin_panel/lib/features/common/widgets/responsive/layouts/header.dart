import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/features/common/providers/authen_token.provider.dart';
import 'package:common/widgets/images/avatar.dart';
import 'package:common/utils/demensions.dart';
import 'package:admin_panel/utils/device.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Header extends HookConsumerWidget implements PreferredSizeWidget {
  const Header({super.key});

  /// Clears auth tokens and navigates to the login page.
  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(authenTokenProvider.notifier).removeToken();
    await Store.delete(StoreKey.accessToken);
    await Store.delete(StoreKey.refreshToken);
    if (context.mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      child: AppBar(
        backgroundColor: colorScheme.onPrimary,
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
          // Profile with logout popup
          PopupMenuButton<String>(
            offset: const Offset(0, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onSelected: (value) {
              if (value == 'logout') {
                _logout(context, ref);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 18, color: colorScheme.error),
                    AppDimens.horizontalSmall,
                    Text(
                      'Logout',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            child: Padding(
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
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Admin',
                        style: textTheme.bodySmall?.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(DeviceUtils.getAppBarHeight() + 5);
}
