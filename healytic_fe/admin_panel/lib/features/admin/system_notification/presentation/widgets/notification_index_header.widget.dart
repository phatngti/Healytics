import 'package:admin_panel/router/admin_routes.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Page header for the notification campaign index screen.
///
/// Displays the title, description, and a CTA to create
/// a new campaign.
class NotificationIndexHeader extends StatelessWidget {
  const NotificationIndexHeader({super.key});

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
                'System Notification Control Center',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: AppDimens.fontWeightBold,
                ),
              ),
              AppDimens.verticalSmall,
              Text(
                'Manage campaign-style system messages for '
                'the whole platform with a workspace inspired '
                'by modern ecommerce and notification products.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        AppDimens.horizontalLarge,
        AppButton(
          buttonType: ButtonType.elevated,
          onPressed: () {
            context.goNamed(AdminNotificationCampaignNewRoute.name);
          },
          icon: const Icon(Icons.campaign_outlined),
          child: const Text('Create Campaign'),
        ),
      ],
    );
  }
}
