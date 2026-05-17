import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/core/providers/auth_session.provider.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/core/widgets/main_screen_layout.widget.dart';
import 'package:user_app/router/routes.dart';

import '../providers/profile.provider.dart';
import '../widgets/profile_header.widget.dart';
import '../widgets/profile_quick_stats.widget.dart';
import '../widgets/profile_logout_button.widget.dart';

/// Personal profile screen rendered inside the
/// bottom navigation shell.
///
/// Uses [MainScreenLayout] for consistent
/// header/background across navigation tabs.
///
/// Layout mirrors the HTML reference with sections:
/// 1. Profile Identity (avatar, name, email, edit)
/// 2. Quick Stats bento grid (orders, wishlist, pts)
/// 3. Log Out action
///
/// Auto-refreshes both [accountMeProvider] and
/// [profileSummaryProvider] on first access.
/// Supports pull-to-refresh for manual reload.
class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Auto-refresh every time the tab becomes
    // visible. Ensures profile data (name, avatar,
    // stats) stays fresh after edits or actions
    // on other screens (e.g. new orders).
    useEffect(() {
      Future.microtask(() {
        if (context.mounted) {
          ref.invalidate(accountMeProvider);
          ref.invalidate(profileSummaryProvider);
        }
      });
      return null;
    }, const []);

    final accountMeState = ref.watch(accountMeProvider);
    final profileSummaryState = ref.watch(
      profileSummaryProvider,
    );
    final userNameFallback = ref.watch(
      currentUserDisplayNameProvider,
    );
    final hPadding = AppDimens.horizontalPadding(
      context,
    );
    final bottomPadding = AppDimens.bottomScrollPadding(
      context,
    );
    final sectionGap = AppDimens.sectionSpacing(
      context,
    );

    return MainScreenLayout(
      title: 'Profile',
      body: RefreshIndicator(
        onRefresh: () => _refreshAll(ref),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                  avatarUrl: user.avatarUrl,
                  onEditProfile: () => context
                      .pushNamed('edit_profile'),
                ),
                loading: () => ProfileHeader(
                  displayName:
                      userNameFallback ?? 'Loading...',
                  email: '',
                  onEditProfile: () => context
                      .pushNamed('edit_profile'),
                ),
                error: (err, stack) => ProfileHeader(
                  displayName:
                      userNameFallback ?? 'Guest',
                  email: 'Error loading profile',
                  onEditProfile: () => context
                      .pushNamed('edit_profile'),
                ),
              ),
              SizedBox(height: sectionGap * 1.5),

              profileSummaryState.when(
                data: (summary) => ProfileQuickStats(
                  ordersCount: summary.ordersCount,
                  wishlistCount: summary.wishlistCount,
                  points: summary.pointsLabel,
                  onOrdersTap: () =>
                      const OrderApprovedRoute()
                          .go(context),
                ),
                loading: () =>
                    const ProfileQuickStats(),
                error: (_, _) => ProfileQuickStats(
                  onOrdersTap: () =>
                      const OrderApprovedRoute()
                          .go(context),
                ),
              ),
              SizedBox(height: sectionGap * 1.5),

              // § 4 — Log Out
              ProfileLogoutButton(
                onPressed: () => _handleLogout(
                  context,
                  ref,
                ),
              ),
              SizedBox(height: sectionGap),
            ],
          ),
        ),
      ),
    );
  }

  /// Invalidates both profile providers, causing
  /// a fresh API fetch. Used for pull-to-refresh.
  Future<void> _refreshAll(WidgetRef ref) async {
    ref.invalidate(accountMeProvider);
    ref.invalidate(profileSummaryProvider);
    // Wait for both providers to settle before
    // the refresh indicator dismisses.
    await Future.wait([
      ref.read(accountMeProvider.future),
      ref.read(profileSummaryProvider.future),
    ]);
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
            key: keys.logoutDialog.cancelButton,
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.onSurfaceVariant,
            ),
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            key: keys.logoutDialog.confirmButton,
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
