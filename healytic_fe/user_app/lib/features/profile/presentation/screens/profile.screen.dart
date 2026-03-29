import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/core/providers/auth_session.provider.dart';

import '../providers/profile.provider.dart';
import '../widgets/profile_header.widget.dart';
import '../widgets/profile_quick_stats.widget.dart';
import '../widgets/profile_settings_list.widget.dart';
import '../widgets/profile_logout_button.widget.dart';

/// Personal profile screen rendered inside the
/// bottom navigation shell.
///
/// Layout mirrors the HTML reference with sections:
/// 1. Profile Identity (avatar, name, email, edit)
/// 2. Quick Stats bento grid (orders, wishlist, pts)
/// 3. Settings list (payment, shipping, security…)
/// 4. Log Out action
class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountMeState = ref.watch(accountMeProvider);
    final userNameFallback = ref.watch(currentUserDisplayNameProvider);
    final hPadding = AppDimens.horizontalPadding(context);
    final bottomPadding = AppDimens.bottomScrollPadding(context);
    final sectionGap = AppDimens.sectionSpacing(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: SafeArea(
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(
              context,
            ).textScaler.clamp(minScaleFactor: 0.8, maxScaleFactor: 1.3),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              hPadding,
              AppDimens.spaceXl,
              hPadding,
              bottomPadding,
            ),
            child: Column(
              children: [
                // § 1 — Profile Identity
                accountMeState.when(
                  data: (user) => ProfileHeader(
                    displayName: user.displayName,
                    email: user.email,
                    onEditProfile: () => context.pushNamed('edit_profile'),
                  ),
                  loading: () => ProfileHeader(
                    displayName: userNameFallback ?? 'Loading...',
                    email: '',
                    onEditProfile: () => context.pushNamed('edit_profile'),
                  ),
                  error: (err, stack) => ProfileHeader(
                    displayName: userNameFallback ?? 'Guest',
                    email: 'Error loading profile',
                    onEditProfile: () => context.pushNamed('edit_profile'),
                  ),
                ),
                SizedBox(height: sectionGap * 1.5),

                // § 2 — Quick Stats
                const ProfileQuickStats(
                  ordersCount: 12,
                  wishlistCount: 48,
                  points: '2.4k',
                ),
                SizedBox(height: sectionGap * 1.5),

                // § 3 — Settings List
                const ProfileSettingsList(),
                SizedBox(height: sectionGap * 1.5),

                // § 4 — Log Out
                ProfileLogoutButton(
                  onPressed: () => _handleLogout(context, ref),
                ),
                SizedBox(height: sectionGap),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Shows a confirmation dialog, then clears
  /// the session and triggers redirect via the
  /// router guard.
  void _handleLogout(BuildContext context, WidgetRef ref) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).colorScheme.surfaceContainerHigh,
        title: Text(
          'Log Out',
          style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                color: Theme.of(ctx).colorScheme.onSurface,
              ),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                color: Theme.of(ctx).colorScheme.onSurfaceVariant,
              ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.onSurfaceVariant,
            ),
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Log Out'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        ref.read(authSessionStoreProvider).forceLogout();
      }
    });
  }
}
