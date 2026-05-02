import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:common/widgets/toast.dart';
import '../../../../core/entities/store.entity.dart';
import '../../../../core/keys/integration_test_keys.dart';
import '../../../../core/providers/auth_session.provider.dart';
import '../../../../router/routes.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSession = ref.watch(authSessionStoreProvider);
    final displayName = authSession.currentUserDisplayName ?? 'Employee';
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: tt.titleLarge),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Avatar
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: cs.primaryContainer,
              child: Text(
                displayName.isNotEmpty ? displayName[0].toUpperCase() : 'E',
                style: tt.headlineMedium?.copyWith(
                  color: cs.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              displayName,
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              'Healthcare Provider',
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 32),
          // Settings section
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: cs.outlineVariant, width: 0.5),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.person_outline,
                    color: cs.onSurfaceVariant,
                  ),
                  title: Text('Edit Profile', style: tt.bodyMedium),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: cs.onSurfaceVariant,
                  ),
                  onTap: () {
                    AppToast.info(context, 'Coming soon');
                  },
                ),
                Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: cs.outlineVariant,
                ),
                ListTile(
                  leading: Icon(
                    Icons.notifications_outlined,
                    color: cs.onSurfaceVariant,
                  ),
                  title: Text('Notifications', style: tt.bodyMedium),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: cs.onSurfaceVariant,
                  ),
                  onTap: () {
                    AppToast.info(context, 'Coming soon');
                  },
                ),
                Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: cs.outlineVariant,
                ),
                ListTile(
                  leading: Icon(Icons.help_outline, color: cs.onSurfaceVariant),
                  title: Text('Help & Support', style: tt.bodyMedium),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: cs.onSurfaceVariant,
                  ),
                  onTap: () {
                    AppToast.info(context, 'Coming soon');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Logout
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              key: keys.profilePage.logoutButton,
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Sign Out'),
                    content: const Text('Are you sure you want to sign out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Sign Out'),
                      ),
                    ],
                  ),
                );
                if (confirm != true || !context.mounted) return;
                await Store.clear();
                if (context.mounted) {
                  const SignInRoute().go(context);
                }
              },
              icon: Icon(Icons.logout, color: cs.error),
              label: Text('Sign Out', style: TextStyle(color: cs.error)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: cs.error),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Version 1.0.0',
              style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
