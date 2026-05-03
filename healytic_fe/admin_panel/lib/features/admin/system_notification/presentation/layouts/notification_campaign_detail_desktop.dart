import 'package:admin_panel/features/admin/system_notification/domain/notification_campaign.entity.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/widgets/notification_detail_cards.widget.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/widgets/notification_ui_helpers.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Desktop layout for viewing a single notification
/// campaign's full detail.
class NotificationCampaignDetailDesktop extends StatelessWidget {
  const NotificationCampaignDetailDesktop({super.key, required this.campaign});

  final NotificationCampaign campaign;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: AppDimens.paddingAllMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailHeader(campaign: campaign),
            AppDimens.verticalLarge,
            _StatusBanner(campaign: campaign),
            AppDimens.verticalLarge,
            _CardGrid(campaign: campaign),
          ],
        ),
      ),
    );
  }
}

/// Header row with campaign title and back button.
class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.campaign});

  final NotificationCampaign campaign;

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
                campaign.campaignName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: AppDimens.fontWeightBold,
                ),
              ),
              AppDimens.verticalSmall,
              Text(
                'Review campaign metadata, delivery '
                'context, and audit trail for this '
                'system notification.',
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
          child: const Text('Back'),
        ),
      ],
    );
  }
}

/// Colored banner showing the current campaign status.
class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.campaign});

  final NotificationCampaign campaign;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppDimens.paddingAllMediumLarge,
      decoration: BoxDecoration(
        color: notificationStatusBackground(
          context,
          campaign.status,
        ).withValues(alpha: 0.45),
        borderRadius: AppDimens.radiusMedium,
      ),
      child: Row(
        children: [
          NotificationStatusBadge(status: campaign.status),
          AppDimens.horizontalMediumSmall,
          Expanded(
            child: Text(
              campaign.status == NotificationCampaignStatus.sent
                  ? 'This campaign has been sent and is '
                        'available in the notification '
                        'audit stream.'
                  : 'This campaign remains in '
                        '${campaign.status.label.toLowerCase()} '
                        'state.',
            ),
          ),
        ],
      ),
    );
  }
}

/// Responsive 2-column grid of detail cards.
class _CardGrid extends StatelessWidget {
  const _CardGrid({required this.campaign});

  final NotificationCampaign campaign;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 1080;
        final meta = NotificationMetadataCard(campaign: campaign);
        final preview = NotificationPreviewCard(campaign: campaign);
        final audience = NotificationAudienceCard(campaign: campaign);
        final audit = NotificationAuditCard(campaign: campaign);

        if (isNarrow) {
          return Column(
            children: [
              meta,
              AppDimens.verticalLarge,
              preview,
              AppDimens.verticalLarge,
              audience,
              AppDimens.verticalLarge,
              audit,
            ],
          );
        }

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: meta),
                AppDimens.horizontalLarge,
                Expanded(child: preview),
              ],
            ),
            AppDimens.verticalLarge,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: audience),
                AppDimens.horizontalLarge,
                Expanded(child: audit),
              ],
            ),
          ],
        );
      },
    );
  }
}
