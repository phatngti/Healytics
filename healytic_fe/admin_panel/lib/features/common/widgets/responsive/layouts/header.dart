import 'package:admin_openapi/api.dart';
import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/features/common/providers/account_me.provider.dart';
import 'package:admin_panel/features/common/providers/authen_token.provider.dart';
import 'package:admin_panel/core/utils/user_role_helper.dart';
import 'package:common/widgets/images/avatar.dart';
import 'package:common/utils/demensions.dart';
import 'package:admin_panel/utils/device.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:admin_panel/router/partner_routes.dart';
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
    await UserRoleHelper.clearPartnerFlags();
    if (context.mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final accountAsync = ref.watch(accountMeProvider);
    final account = accountAsync.value;
    final displayName = _buildDisplayName(account);
    final roleName = _buildRoleName(account);

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
            onPressed: () {
              if (UserRoleHelper.isAdmin()) {
                const AdminNotificationCampaignIndexRoute().go(context);
              }
            },
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
              if (value == 'edit_profile') {
                const ProfileEditRoute().go(context);
              } else if (value == 'logout') {
                _logout(context, ref);
              }
            },
            itemBuilder: (_) => [
              if (UserRoleHelper.isProvider())
                PopupMenuItem<String>(
                  value: 'edit_profile',
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: colorScheme.onSurface,
                      ),
                      AppDimens.horizontalSmall,
                      Text('Edit Profile', style: textTheme.bodyMedium),
                    ],
                  ),
                ),
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
                  AvatarImage(name: displayName, radius: 14),
                  AppDimens.horizontalSmall,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        displayName,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        roleName,
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

  /// Builds a human-readable display name from the
  /// account profile. Falls back to email, then a
  /// generic placeholder.
  String _buildDisplayName(AccountMeResponseDto? account) {
    if (account == null) return 'Loading...';
    final profile = account.userProfile;
    if (profile != null) {
      final first = profile.firstName ?? '';
      final last = profile.lastName ?? '';
      final full = '$first $last'.trim();
      if (full.isNotEmpty) return full;
    }
    if (account.username != null && account.username!.isNotEmpty) {
      return account.username!;
    }
    return account.email;
  }

  /// Maps the role enum value to a user-friendly label.
  String _buildRoleName(AccountMeResponseDto? account) {
    if (account == null) return '';
    final role = account.role.value;
    return role
        .split('_')
        .map(
          (word) => word.isEmpty
              ? ''
              : '${word[0].toUpperCase()}'
                    '${word.substring(1)}',
        )
        .join(' ');
  }

  @override
  Size get preferredSize => Size.fromHeight(DeviceUtils.getAppBarHeight() + 5);
}
