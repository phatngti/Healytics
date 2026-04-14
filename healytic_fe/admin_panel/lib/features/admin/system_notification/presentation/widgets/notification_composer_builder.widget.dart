import 'package:admin_panel/features/admin/system_notification/domain/notification_campaign.entity.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/providers/notification_campaign.provider.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/widgets/notification_ui_helpers.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Page header for the campaign composer screen.
class NotificationComposerHeader extends StatelessWidget {
  const NotificationComposerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Notification Campaign',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: AppDimens.fontWeightBold,
                ),
              ),
              AppDimens.verticalSmall,
              Text(
                'Compose a whole-system campaign using '
                'the same multi-section workflow found in '
                'leading messaging and ecommerce admin '
                'tools.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
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

/// Left-hand builder column containing the form sections
/// (Basics, Channels, Audience, Delivery, Content, Review).
class NotificationComposerBuilder extends StatelessWidget {
  const NotificationComposerBuilder({
    super.key,
    required this.state,
    required this.notifier,
    required this.capability,
    required this.segments,
  });

  final NotificationCampaignComposerState state;
  final NotificationCampaignComposerNotifier notifier;
  final NotificationCapability capability;
  final List<NotificationSegment> segments;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BasicsSection(state: state, notifier: notifier),
        AppDimens.verticalLarge,
        _ChannelsSection(
          state: state,
          notifier: notifier,
          capability: capability,
        ),
        AppDimens.verticalLarge,
        _AudienceSection(
          state: state,
          notifier: notifier,
          capability: capability,
          segments: segments,
        ),
        AppDimens.verticalLarge,
        _DeliverySection(
          state: state,
          notifier: notifier,
          capability: capability,
        ),
        AppDimens.verticalLarge,
        _ContentSection(state: state, notifier: notifier),
        AppDimens.verticalLarge,
        _ReviewSection(state: state, capability: capability),
      ],
    );
  }
}

class _BasicsSection extends StatelessWidget {
  const _BasicsSection({required this.state, required this.notifier});

  final NotificationCampaignComposerState state;
  final NotificationCampaignComposerNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return NotificationSectionCard(
      title: 'Basics',
      subtitle:
          'Set the internal campaign metadata and '
          'the user-facing title.',
      child: Column(
        children: [
          TextFormField(
            initialValue: state.draft.campaignName,
            decoration: const InputDecoration(labelText: 'Campaign name'),
            onChanged: notifier.updateCampaignName,
          ),
          AppDimens.verticalMedium,
          TextFormField(
            initialValue: state.draft.internalNote,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Internal note',
              hintText:
                  'Optional context for operators '
                  'and reviewers',
            ),
            onChanged: notifier.updateInternalNote,
          ),
          AppDimens.verticalMedium,
          TextFormField(
            initialValue: state.draft.content.title,
            decoration: const InputDecoration(labelText: 'Notification title'),
            onChanged: notifier.updateTitle,
          ),
        ],
      ),
    );
  }
}

class _ChannelsSection extends StatelessWidget {
  const _ChannelsSection({
    required this.state,
    required this.notifier,
    required this.capability,
  });

  final NotificationCampaignComposerState state;
  final NotificationCampaignComposerNotifier notifier;
  final NotificationCapability capability;

  @override
  Widget build(BuildContext context) {
    return NotificationSectionCard(
      title: 'Channels',
      subtitle:
          'Keep in-app active now while exposing future '
          'channels with capability gating.',
      child: Column(
        children: NotificationChannel.values.map((channel) {
          final supported = capability.supportsChannel(channel);
          final selected = state.draft.channels.contains(channel);
          return CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(channel.label),
            subtitle: Text(
              supported
                  ? 'Available for this environment.'
                  : 'Visible for future rollout, currently '
                        'disabled by backend capabilities.',
            ),
            value: selected,
            onChanged: supported
                ? (value) => notifier.toggleChannel(channel, value ?? false)
                : null,
          );
        }).toList(),
      ),
    );
  }
}

class _AudienceSection extends StatelessWidget {
  const _AudienceSection({
    required this.state,
    required this.notifier,
    required this.capability,
    required this.segments,
  });

  final NotificationCampaignComposerState state;
  final NotificationCampaignComposerNotifier notifier;
  final NotificationCapability capability;
  final List<NotificationSegment> segments;

  @override
  Widget build(BuildContext context) {
    return NotificationSectionCard(
      title: 'Audience',
      subtitle:
          'Target roles and segments like a market-standard '
          'campaign builder.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!capability.supportsSegments)
            const NotificationCapabilityHint(
              message:
                  'Segment editing is visible for roadmap '
                  'clarity, but the current backend only '
                  'supports whole-platform broadcast '
                  'delivery.',
            ),
          if (!capability.supportsSegments) AppDimens.verticalMedium,
          Wrap(
            spacing: AppDimens.spaceSm,
            runSpacing: AppDimens.spaceSm,
            children: NotificationRecipientRole.values.map((role) {
              final selected = state.draft.audience.roles.contains(role);
              return FilterChip(
                label: Text(role.label),
                selected: selected,
                onSelected: capability.supportsSegments
                    ? (value) {
                        final nextRoles = [...state.draft.audience.roles];
                        if (value) {
                          if (!nextRoles.contains(role)) {
                            nextRoles.add(role);
                          }
                        } else {
                          nextRoles.remove(role);
                        }
                        notifier.updateAudience(
                          roles: nextRoles.isEmpty
                              ? const [NotificationRecipientRole.allUsers]
                              : nextRoles,
                          presetLabel: nextRoles.length == 1
                              ? nextRoles.first.label
                              : 'Custom selection',
                        );
                      }
                    : null,
              );
            }).toList(),
          ),
          AppDimens.verticalMedium,
          DropdownButtonFormField<NotificationSegmentId?>(
            initialValue: state.draft.audience.includeSegmentIds.isEmpty
                ? null
                : state.draft.audience.includeSegmentIds.first,
            decoration: const InputDecoration(labelText: 'Include segment'),
            items: [
              const DropdownMenuItem<NotificationSegmentId?>(
                value: null,
                child: Text('No segment'),
              ),
              ...segments.map(
                (segment) => DropdownMenuItem<NotificationSegmentId?>(
                  value: segment.id,
                  child: Text(segment.name),
                ),
              ),
            ],
            onChanged: capability.supportsSegments
                ? (value) => notifier.updateAudience(
                    presetLabel: value == null
                        ? 'Custom selection'
                        : segments.firstWhere((s) => s.id == value).name,
                    includeSegments: value == null ? [] : [value],
                    estimatedReach: value == null
                        ? null
                        : segments
                              .firstWhere((s) => s.id == value)
                              .estimatedReach,
                  )
                : null,
          ),
          AppDimens.verticalMedium,
          DropdownButtonFormField<NotificationSegmentId?>(
            initialValue: state.draft.audience.excludeSegmentIds.isEmpty
                ? null
                : state.draft.audience.excludeSegmentIds.first,
            decoration: const InputDecoration(labelText: 'Exclude segment'),
            items: [
              const DropdownMenuItem<NotificationSegmentId?>(
                value: null,
                child: Text('No exclusions'),
              ),
              ...segments.map(
                (segment) => DropdownMenuItem<NotificationSegmentId?>(
                  value: segment.id,
                  child: Text(segment.name),
                ),
              ),
            ],
            onChanged: capability.supportsSegments
                ? (value) => notifier.updateAudience(
                    excludeSegments: value == null ? [] : [value],
                  )
                : null,
          ),
          AppDimens.verticalMedium,
          Text(
            state.draft.audience.estimatedReach == null
                ? 'Estimated reach will be available when '
                      'audience estimation is supported.'
                : 'Estimated reach: '
                      '${state.draft.audience.estimatedReach}',
          ),
        ],
      ),
    );
  }
}

class _DeliverySection extends StatelessWidget {
  const _DeliverySection({
    required this.state,
    required this.notifier,
    required this.capability,
  });

  final NotificationCampaignComposerState state;
  final NotificationCampaignComposerNotifier notifier;
  final NotificationCapability capability;

  @override
  Widget build(BuildContext context) {
    return NotificationSectionCard(
      title: 'Delivery',
      subtitle:
          'Choose send now or reserve a scheduled '
          'launch slot.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!capability.supportsScheduling)
            const NotificationCapabilityHint(
              message:
                  'Scheduling is intentionally visible but '
                  'disabled until backend support is '
                  'available.',
            ),
          if (!capability.supportsScheduling) AppDimens.verticalMedium,
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment<bool>(
                value: true,
                label: Text('Send now'),
                icon: Icon(Icons.send_outlined),
              ),
              ButtonSegment<bool>(
                value: false,
                label: Text('Schedule'),
                icon: Icon(Icons.schedule_outlined),
              ),
            ],
            selected: {state.draft.schedule.sendNow},
            onSelectionChanged: capability.supportsScheduling
                ? (selection) => notifier.updateScheduleMode(selection.first)
                : null,
          ),
          AppDimens.verticalMedium,
          InkWell(
            onTap: capability.supportsScheduling
                ? () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2027),
                      initialDate:
                          state.draft.schedule.scheduledAt ?? DateTime.now(),
                    );
                    if (picked != null && context.mounted) {
                      notifier.updateScheduledAt(
                        DateTime(picked.year, picked.month, picked.day, 9, 0),
                      );
                    }
                  }
                : null,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Scheduled send time',
              ),
              child: Text(
                state.draft.schedule.scheduledAt == null
                    ? 'Schedule unavailable in current mode'
                    : formatNotificationDateTime(
                        state.draft.schedule.scheduledAt!,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  const _ContentSection({required this.state, required this.notifier});

  final NotificationCampaignComposerState state;
  final NotificationCampaignComposerNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return NotificationSectionCard(
      title: 'Content',
      subtitle:
          'Configure body copy and future-ready CTA/'
          'deep link fields.',
      child: Column(
        children: [
          TextFormField(
            initialValue: state.draft.content.body,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'Body'),
            onChanged: notifier.updateBody,
          ),
          AppDimens.verticalMedium,
          TextFormField(
            initialValue: state.draft.content.previewText,
            decoration: const InputDecoration(labelText: 'Preview text'),
            onChanged: notifier.updatePreviewText,
          ),
          AppDimens.verticalMedium,
          TextFormField(
            initialValue: state.draft.content.ctaLabel,
            decoration: const InputDecoration(labelText: 'CTA label'),
            onChanged: notifier.updateCtaLabel,
          ),
          AppDimens.verticalMedium,
          TextFormField(
            initialValue: state.draft.content.deepLinkTarget,
            enabled: false,
            decoration: const InputDecoration(
              labelText: 'Deep link target',
              hintText:
                  'Locked until structured data support '
                  'is available',
            ),
            onChanged: notifier.updateDeepLinkTarget,
          ),
        ],
      ),
    );
  }
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({required this.state, required this.capability});

  final NotificationCampaignComposerState state;
  final NotificationCapability capability;

  @override
  Widget build(BuildContext context) {
    final issues = state.validationIssues(capability);

    return NotificationSectionCard(
      title: 'Review',
      subtitle:
          'Confirm validation and capability constraints '
          'before launch.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...issues.map(
            (issue) => Padding(
              padding: EdgeInsets.only(bottom: AppDimens.spaceSm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.error_outline, size: AppDimens.iconSmMd),
                  AppDimens.horizontalSmall,
                  Expanded(child: Text(issue)),
                ],
              ),
            ),
          ),
          if (issues.isEmpty)
            Row(
              children: [
                Icon(Icons.check_circle_outline, size: AppDimens.iconSmMd),
                AppDimens.horizontalSmall,
                const Expanded(
                  child: Text(
                    'The campaign is structurally valid '
                    'for the currently enabled '
                    'capabilities.',
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
