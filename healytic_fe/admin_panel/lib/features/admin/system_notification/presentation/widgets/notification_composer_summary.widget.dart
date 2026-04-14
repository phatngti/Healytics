import 'package:admin_panel/features/admin/system_notification/domain/notification_campaign.entity.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/providers/notification_campaign.provider.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/widgets/notification_ui_helpers.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Right-hand summary column showing audience, channel,
/// live preview, and action buttons.
class NotificationComposerSummary extends ConsumerWidget {
  const NotificationComposerSummary({
    super.key,
    required this.state,
    required this.capability,
  });

  final NotificationCampaignComposerState state;
  final NotificationCapability capability;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(notificationCampaignComposerProvider.notifier);

    return Column(
      children: [
        _AudienceSummary(state: state),
        AppDimens.verticalLarge,
        _ChannelSummary(state: state),
        AppDimens.verticalLarge,
        _LivePreview(state: state),
        AppDimens.verticalLarge,
        _ActionsCard(state: state, capability: capability, notifier: notifier),
      ],
    );
  }
}

class _AudienceSummary extends StatelessWidget {
  const _AudienceSummary({required this.state});

  final NotificationCampaignComposerState state;

  @override
  Widget build(BuildContext context) {
    return NotificationSectionCard(
      title: 'Audience Summary',
      subtitle: 'Current recipients and targeting posture.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Preset: ${state.draft.audience.presetLabel}'),
          AppDimens.verticalSmall,
          Text(
            'Roles: ${state.draft.audience.roles.map((role) => role.label).join(', ')}',
          ),
          AppDimens.verticalSmall,
          Text(
            'Estimated reach: '
            '${state.draft.audience.estimatedReach ?? 'Unavailable'}',
          ),
        ],
      ),
    );
  }
}

class _ChannelSummary extends StatelessWidget {
  const _ChannelSummary({required this.state});

  final NotificationCampaignComposerState state;

  @override
  Widget build(BuildContext context) {
    return NotificationSectionCard(
      title: 'Channel Summary',
      subtitle: 'Enabled delivery surfaces.',
      child: Wrap(
        spacing: AppDimens.spaceSm,
        runSpacing: AppDimens.spaceSm,
        children: state.draft.channels
            .map((channel) => Chip(label: Text(channel.label)))
            .toList(),
      ),
    );
  }
}

class _LivePreview extends StatelessWidget {
  const _LivePreview({required this.state});

  final NotificationCampaignComposerState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return NotificationSectionCard(
      title: 'Live Preview',
      subtitle: 'A compact in-app notification preview.',
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
                    state.draft.content.title.isEmpty
                        ? 'Notification title'
                        : state.draft.content.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: AppDimens.fontWeightBold,
                    ),
                  ),
                  AppDimens.verticalSmall,
                  Text(
                    state.draft.content.body.isEmpty
                        ? 'Notification body preview '
                              'appears here.'
                        : state.draft.content.body,
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

class _ActionsCard extends StatelessWidget {
  const _ActionsCard({
    required this.state,
    required this.capability,
    required this.notifier,
  });

  final NotificationCampaignComposerState state;
  final NotificationCapability capability;
  final NotificationCampaignComposerNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return NotificationSectionCard(
      title: 'Actions',
      subtitle: 'Save, schedule, or launch the campaign.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state.errorMessage != null) ...[
            Text(
              state.errorMessage!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            AppDimens.verticalMediumSmall,
          ],
          _SaveDraftButton(
            state: state,
            capability: capability,
            notifier: notifier,
          ),
          AppDimens.verticalMediumSmall,
          _ScheduleButton(
            state: state,
            capability: capability,
            notifier: notifier,
          ),
          AppDimens.verticalMediumSmall,
          _SendNowButton(
            state: state,
            capability: capability,
            notifier: notifier,
          ),
        ],
      ),
    );
  }
}

class _SaveDraftButton extends ConsumerWidget {
  const _SaveDraftButton({
    required this.state,
    required this.capability,
    required this.notifier,
  });

  final NotificationCampaignComposerState state;
  final NotificationCapability capability;
  final NotificationCampaignComposerNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppButton(
      buttonType: ButtonType.outline,
      isLoading: state.isSubmitting,
      onPressed: capability.supportsDrafts && !state.isSubmitting
          ? () async {
              await notifier.saveDraft();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Campaign draft saved.')),
                );
              }
            }
          : null,
      child: const Text('Save Draft'),
    );
  }
}

class _ScheduleButton extends ConsumerWidget {
  const _ScheduleButton({
    required this.state,
    required this.capability,
    required this.notifier,
  });

  final NotificationCampaignComposerState state;
  final NotificationCapability capability;
  final NotificationCampaignComposerNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppButton(
      buttonType: ButtonType.outline,
      isLoading: state.isSubmitting,
      onPressed: capability.supportsScheduling && !state.isSubmitting
          ? () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Schedule campaign'),
                  content: const Text(
                    'This will store the campaign for '
                    'future delivery.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Schedule'),
                    ),
                  ],
                ),
              );
              if (confirmed != true) return;
              final scheduled = await notifier.scheduleDraft(capability);
              ref.read(notificationCampaignIndexProvider.notifier).bumpReload();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Campaign scheduled successfully.'),
                  ),
                );
                context.goNamed(
                  AdminNotificationCampaignDetailRoute.name,
                  pathParameters: {'id': scheduled.id.value},
                );
              }
            }
          : null,
      child: const Text('Schedule'),
    );
  }
}

class _SendNowButton extends ConsumerWidget {
  const _SendNowButton({
    required this.state,
    required this.capability,
    required this.notifier,
  });

  final NotificationCampaignComposerState state;
  final NotificationCapability capability;
  final NotificationCampaignComposerNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppButton(
      isLoading: state.isSubmitting,
      onPressed: !state.isSubmitting
          ? () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Send notification now'),
                  content: const Text(
                    'This will immediately deliver the '
                    'current campaign to the available '
                    'whole-system notification channel.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Send now'),
                    ),
                  ],
                ),
              );
              if (confirmed != true) return;
              final sent = await notifier.sendNow(capability);
              ref.read(notificationCampaignIndexProvider.notifier).bumpReload();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('System notification sent.')),
                );
                context.goNamed(
                  AdminNotificationCampaignDetailRoute.name,
                  pathParameters: {'id': sent.id.value},
                );
              }
            }
          : null,
      child: const Text('Send Now'),
    );
  }
}
