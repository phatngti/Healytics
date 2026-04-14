import 'package:admin_panel/features/admin/system_notification/domain/notification_campaign.entity.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/widgets/notification_ui_helpers.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Displays label–value metadata rows inside section cards.
class NotificationMetaRow extends StatelessWidget {
  const NotificationMetaRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimens.spaceMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          AppDimens.horizontalMediumSmall,
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: AppDimens.fontWeightSemiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows core campaign metadata (name, type, channels, etc.).
class NotificationMetadataCard extends StatelessWidget {
  const NotificationMetadataCard({super.key, required this.campaign});

  final NotificationCampaign campaign;

  @override
  Widget build(BuildContext context) {
    return NotificationSectionCard(
      title: 'Campaign Metadata',
      subtitle: 'Core operational details captured at send time.',
      child: Column(
        children: [
          NotificationMetaRow(label: 'Campaign', value: campaign.campaignName),
          NotificationMetaRow(label: 'Created by', value: campaign.createdBy),
          NotificationMetaRow(label: 'Type', value: campaign.typeLabel),
          NotificationMetaRow(
            label: 'Channels',
            value: campaign.channels.map((channel) => channel.label).join(', '),
          ),
          NotificationMetaRow(
            label: 'Created at',
            value: formatNotificationDateTime(campaign.createdAt),
          ),
          NotificationMetaRow(
            label: 'Updated at',
            value: formatNotificationDateTime(campaign.updatedAt),
          ),
          NotificationMetaRow(
            label: 'Sent at',
            value: campaign.sentAt == null
                ? 'Not sent'
                : formatNotificationDateTime(campaign.sentAt!),
          ),
        ],
      ),
    );
  }
}

/// Shows the rendered notification content preview.
class NotificationPreviewCard extends StatelessWidget {
  const NotificationPreviewCard({super.key, required this.campaign});

  final NotificationCampaign campaign;

  @override
  Widget build(BuildContext context) {
    return NotificationSectionCard(
      title: 'Rendered Content',
      subtitle: 'Final content preview used for system delivery.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            campaign.content.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: AppDimens.fontWeightBold,
            ),
          ),
          AppDimens.verticalMediumSmall,
          Text(campaign.content.body),
          if (campaign.content.previewText.isNotEmpty) ...[
            AppDimens.verticalMedium,
            NotificationMetaRow(
              label: 'Preview text',
              value: campaign.content.previewText,
            ),
          ],
          if (campaign.content.ctaLabel.isNotEmpty) ...[
            NotificationMetaRow(
              label: 'CTA label',
              value: campaign.content.ctaLabel,
            ),
          ],
          if (campaign.content.deepLinkTarget.isNotEmpty) ...[
            NotificationMetaRow(
              label: 'Deep link target',
              value: campaign.content.deepLinkTarget,
            ),
          ],
        ],
      ),
    );
  }
}

/// Displays frozen audience values for a campaign.
class NotificationAudienceCard extends StatelessWidget {
  const NotificationAudienceCard({super.key, required this.campaign});

  final NotificationCampaign campaign;

  @override
  Widget build(BuildContext context) {
    return NotificationSectionCard(
      title: 'Audience Snapshot',
      subtitle: 'Audience values frozen for this campaign state.',
      child: Column(
        children: [
          NotificationMetaRow(
            label: 'Preset',
            value: campaign.audience.presetLabel,
          ),
          NotificationMetaRow(
            label: 'Roles',
            value: campaign.audience.roles.map((role) => role.label).join(', '),
          ),
          NotificationMetaRow(
            label: 'Include segments',
            value: campaign.audience.includeSegmentIds.isEmpty
                ? 'None'
                : campaign.audience.includeSegmentIds
                      .map((id) => id.value)
                      .join(', '),
          ),
          NotificationMetaRow(
            label: 'Exclude segments',
            value: campaign.audience.excludeSegmentIds.isEmpty
                ? 'None'
                : campaign.audience.excludeSegmentIds
                      .map((id) => id.value)
                      .join(', '),
          ),
          NotificationMetaRow(
            label: 'Estimated reach',
            value:
                campaign.audience.estimatedReach?.toString() ?? 'Unavailable',
          ),
        ],
      ),
    );
  }
}

/// Displays operational audit trail events.
class NotificationAuditCard extends StatelessWidget {
  const NotificationAuditCard({super.key, required this.campaign});

  final NotificationCampaign campaign;

  @override
  Widget build(BuildContext context) {
    return NotificationSectionCard(
      title: 'Audit Trail',
      subtitle: 'Operational milestones and delivery events.',
      child: Column(
        children: campaign.auditTrail.map((event) {
          return _AuditEventRow(event: event);
        }).toList(),
      ),
    );
  }
}

/// A single audit trail event row.
class _AuditEventRow extends StatelessWidget {
  const _AuditEventRow({required this.event});

  final NotificationActivityEvent event;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: AppDimens.spaceMdLg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppDimens.avatarSm,
            height: AppDimens.avatarSm,
            decoration: BoxDecoration(
              color: event.isError
                  ? colorScheme.errorContainer
                  : colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              event.isError ? Icons.error_outline : Icons.check,
              size: AppDimens.iconSmMd,
              color: event.isError
                  ? colorScheme.onErrorContainer
                  : colorScheme.onPrimaryContainer,
            ),
          ),
          AppDimens.horizontalMediumSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: AppDimens.fontWeightBold,
                  ),
                ),
                AppDimens.verticalExtraSmall,
                Text(event.detail),
                AppDimens.verticalExtraSmall,
                Text(
                  formatNotificationDateTime(event.occurredAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
