import 'package:admin_panel/features/admin/system_notification/domain/notification_campaign.entity.dart';
import 'package:admin_panel/features/partner/transactions/presentation/widgets/finance_ui_helpers.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Formats a [DateTime] as 'dd MMM yyyy'.
String formatNotificationDate(DateTime value) {
  return DateFormat('dd MMM yyyy').format(value);
}

/// Formats a [DateTime] as 'dd MMM yyyy, HH:mm'.
String formatNotificationDateTime(DateTime value) {
  return DateFormat('dd MMM yyyy, HH:mm').format(value);
}

/// Maps [NotificationCampaignStatus] to a background
/// colour using the shared finance helpers.
Color notificationStatusBackground(
  BuildContext context,
  NotificationCampaignStatus status,
) {
  return financeStatusBackground(context, status.label);
}

/// Maps [NotificationCampaignStatus] to a foreground
/// colour using the shared finance helpers.
Color notificationStatusForeground(
  BuildContext context,
  NotificationCampaignStatus status,
) {
  return financeStatusForeground(context, status.label);
}

/// Pill badge showing the current campaign status.
class NotificationStatusBadge extends StatelessWidget {
  const NotificationStatusBadge({super.key, required this.status});

  final NotificationCampaignStatus status;

  @override
  Widget build(BuildContext context) {
    return FinanceStatusBadge(
      label: status.label,
      backgroundColor: notificationStatusBackground(context, status),
      foregroundColor: notificationStatusForeground(context, status),
    );
  }
}

/// Metric card showing a KPI value with icon, label, and
/// caption. Used in the stats row.
class NotificationMetricCard extends StatelessWidget {
  const NotificationMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.caption,
    required this.icon,
  });

  final String label;
  final String value;
  final String caption;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 240,
      padding: AppDimens.paddingAllMediumLarge,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppDimens.ctaButtonMd,
            height: AppDimens.ctaButtonMd,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: AppDimens.radiusMediumSmall,
            ),
            child: Icon(icon, color: colorScheme.primary),
          ),
          AppDimens.verticalMedium,
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          AppDimens.verticalSmall,
          Text(
            value,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: AppDimens.fontWeightBold,
            ),
          ),
          AppDimens.verticalExtraSmall,
          Text(
            caption,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable section card with title, subtitle,
/// optional trailing widget, and content area.
class NotificationSectionCard extends StatelessWidget {
  const NotificationSectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: AppDimens.paddingAllMediumLarge,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: AppDimens.fontWeightBold,
                      ),
                    ),
                    AppDimens.verticalExtraSmall,
                    Text(
                      subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          AppDimens.verticalLarge,
          child,
        ],
      ),
    );
  }
}

/// Hint banner shown when a capability is disabled.
class NotificationCapabilityHint extends StatelessWidget {
  const NotificationCapabilityHint({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceSmMd,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock_outline,
            size: AppDimens.iconSmMd,
            color: colorScheme.primary,
          ),
          AppDimens.horizontalSmall,
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}
