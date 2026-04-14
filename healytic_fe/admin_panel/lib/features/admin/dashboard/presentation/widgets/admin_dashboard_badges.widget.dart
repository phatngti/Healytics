import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_alert.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_notification.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_partner_ranking.entity.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class AdminStatusBadge extends StatelessWidget {
  const AdminStatusBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSmMd,
        vertical: AppDimens.spaceSm,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppDimens.radiusPill,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

AdminStatusBadge verificationStatusBadge(
  BuildContext context,
  AdminPartnerVerificationStatus status,
) {
  final semanticColors = Theme.of(context).extension<SemanticColors>();
  final colorScheme = Theme.of(context).colorScheme;

  return switch (status) {
    AdminPartnerVerificationStatus.approved => AdminStatusBadge(
      label: 'Approved',
      backgroundColor: (semanticColors?.success ?? Colors.green).withValues(
        alpha: 0.14,
      ),
      foregroundColor: semanticColors?.success ?? Colors.green,
    ),
    AdminPartnerVerificationStatus.pending => AdminStatusBadge(
      label: 'Pending',
      backgroundColor: (semanticColors?.warning ?? Colors.orange).withValues(
        alpha: 0.16,
      ),
      foregroundColor: semanticColors?.warning ?? Colors.orange,
    ),
    AdminPartnerVerificationStatus.changesRequired => AdminStatusBadge(
      label: 'Changes Required',
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
    ),
    AdminPartnerVerificationStatus.rejected => AdminStatusBadge(
      label: 'Rejected',
      backgroundColor: colorScheme.errorContainer,
      foregroundColor: colorScheme.onErrorContainer,
    ),
  };
}

AdminStatusBadge notificationPriorityBadge(
  BuildContext context,
  AdminDashboardNotificationPriority priority,
) {
  final colorScheme = Theme.of(context).colorScheme;
  final semanticColors = Theme.of(context).extension<SemanticColors>();
  return switch (priority) {
    AdminDashboardNotificationPriority.low => AdminStatusBadge(
      label: 'Low',
      backgroundColor: colorScheme.surfaceContainerHighest,
      foregroundColor: colorScheme.onSurfaceVariant,
    ),
    AdminDashboardNotificationPriority.medium => AdminStatusBadge(
      label: 'Medium',
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
    ),
    AdminDashboardNotificationPriority.high => AdminStatusBadge(
      label: 'High',
      backgroundColor: (semanticColors?.warning ?? Colors.orange).withValues(
        alpha: 0.16,
      ),
      foregroundColor: semanticColors?.warning ?? Colors.orange,
    ),
    AdminDashboardNotificationPriority.critical => AdminStatusBadge(
      label: 'Critical',
      backgroundColor: colorScheme.errorContainer,
      foregroundColor: colorScheme.onErrorContainer,
    ),
  };
}

Color alertSeverityColor(
  BuildContext context,
  AdminDashboardAlertSeverity severity,
) {
  final colorScheme = Theme.of(context).colorScheme;
  final semanticColors = Theme.of(context).extension<SemanticColors>();

  return switch (severity) {
    AdminDashboardAlertSeverity.success =>
      semanticColors?.success ?? Colors.green,
    AdminDashboardAlertSeverity.info =>
      semanticColors?.info ?? colorScheme.primary,
    AdminDashboardAlertSeverity.warning =>
      semanticColors?.warning ?? Colors.orange,
    AdminDashboardAlertSeverity.critical => colorScheme.error,
  };
}
