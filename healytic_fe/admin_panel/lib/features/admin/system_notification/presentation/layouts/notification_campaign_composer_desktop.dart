import 'package:admin_panel/features/admin/system_notification/presentation/providers/notification_campaign.provider.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/widgets/notification_ui_helpers.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Send-now form for creating a system notification.
class NotificationCampaignComposerDesktop extends ConsumerWidget {
  const NotificationCampaignComposerDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationCampaignComposerProvider);
    final notifier = ref.read(notificationCampaignComposerProvider.notifier);

    return SingleChildScrollView(
      child: Padding(
        padding: AppDimens.paddingAllMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ComposerHeader(),
            AppDimens.verticalLarge,
            LayoutBuilder(
              builder: (context, constraints) {
                final form = _NotificationForm(
                  state: state,
                  notifier: notifier,
                );
                final preview = _NotificationPreview(state: state);

                if (constraints.maxWidth < 980) {
                  return Column(
                    children: [form, AppDimens.verticalLarge, preview],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: form),
                    AppDimens.horizontalLarge,
                    SizedBox(width: 360, child: preview),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ComposerHeader extends StatelessWidget {
  const _ComposerHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            'Create System Notification',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: AppDimens.fontWeightBold,
            ),
          ),
        ),
        AppDimens.horizontalLarge,
        AppButton(
          buttonType: ButtonType.text,
          onPressed: () {
            context.goNamed(AdminNotificationCampaignIndexRoute.name);
          },
          icon: const Icon(Icons.arrow_back),
          child: const Text('Back to campaigns'),
        ),
      ],
    );
  }
}

class _NotificationForm extends ConsumerWidget {
  const _NotificationForm({required this.state, required this.notifier});

  final NotificationCampaignComposerState state;
  final NotificationCampaignComposerNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NotificationSectionCard(
      title: 'Message',
      subtitle: 'Send an in-app broadcast to all users.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: state.title,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Title'),
            onChanged: notifier.updateTitle,
          ),
          AppDimens.verticalMedium,
          TextFormField(
            initialValue: state.body,
            minLines: 5,
            maxLines: 8,
            decoration: const InputDecoration(labelText: 'Body'),
            onChanged: notifier.updateBody,
          ),
          if (state.errorMessage != null) ...[
            AppDimens.verticalMedium,
            Text(
              state.errorMessage!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
          AppDimens.verticalLarge,
          Align(
            alignment: Alignment.centerRight,
            child: AppButton(
              isLoading: state.isSubmitting,
              onPressed: state.isSubmitting
                  ? null
                  : () => _sendNotification(context, ref),
              icon: const Icon(Icons.send_outlined),
              child: const Text('Send Now'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendNotification(BuildContext context, WidgetRef ref) async {
    final issues = state.validationIssues();
    if (issues.isNotEmpty) {
      try {
        await notifier.sendBroadcast();
      } catch (_) {
        return;
      }
    }

    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send notification now'),
        content: const Text(
          'This will immediately send the notification to all users.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.send_outlined),
            label: const Text('Send'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final sent = await notifier.sendBroadcast();
      ref.read(notificationCampaignIndexProvider.notifier).bumpReload();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('System notification sent.')),
      );
      context.goNamed(
        AdminNotificationCampaignDetailRoute.name,
        pathParameters: {'id': sent.id.value},
      );
    } catch (_) {
      return;
    }
  }
}

class _NotificationPreview extends StatelessWidget {
  const _NotificationPreview({required this.state});

  final NotificationCampaignComposerState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return NotificationSectionCard(
      title: 'Preview',
      subtitle: 'In-app notification',
      child: Container(
        padding: AppDimens.paddingAllMedium,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: AppDimens.radiusMedium,
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.45),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: AppDimens.ctaButtonMd,
              height: AppDimens.ctaButtonMd,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: AppDimens.radiusMediumSmall,
              ),
              child: Icon(
                Icons.notifications_active_outlined,
                color: colorScheme.primary,
              ),
            ),
            AppDimens.horizontalMediumSmall,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.title.trim().isEmpty
                        ? 'Notification title'
                        : state.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: AppDimens.fontWeightBold,
                    ),
                  ),
                  AppDimens.verticalSmall,
                  Text(
                    state.body.trim().isEmpty
                        ? 'Notification body preview appears here.'
                        : state.body,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
