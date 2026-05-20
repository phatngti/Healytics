import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/inventory_alert.entity.dart';
import 'dashboard_constants.dart';
import 'dashboard_panel.widget.dart';
import 'dashboard_section_header.widget.dart';

/// Inventory alert cards showing low-stock items.
class InventoryAlertsWidget extends StatelessWidget {
  const InventoryAlertsWidget({super.key, required this.alerts});

  final List<InventoryAlert> alerts;

  @override
  Widget build(BuildContext context) {
    return DashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardSectionHeader(
            title: 'Inventory Alerts',
            icon: Icons.inventory_rounded,
          ),
          if (alerts.isEmpty)
            const _InventoryEmptyState()
          else
            ...alerts.map(
              (a) => Padding(
                padding: AppDimens.spaceMd.paddingBottom,
                child: _AlertItem(alert: a),
              ),
            ),
        ],
      ),
    );
  }
}

class _AlertItem extends StatelessWidget {
  const _AlertItem({required this.alert});

  final InventoryAlert alert;

  Color _severityColor(ColorScheme cs) => switch (alert.severity) {
    'critical' => cs.error,
    'warning' => DashboardColors.pending,
    _ => cs.primary,
  };

  String get _severityLabel => switch (alert.severity) {
    'critical' => 'Critical',
    'warning' => 'Warning',
    _ => 'Info',
  };

  String get _alertTypeLabel => switch (alert.alertType) {
    'low_stock' => 'Low Stock',
    'expiring' => 'Expiring Soon',
    'out_of_stock' => 'Out of Stock',
    _ => 'Inventory',
  };

  IconData get _icon => switch (alert.alertType) {
    'low_stock' => Icons.trending_down_rounded,
    'expiring' => Icons.timer_rounded,
    'out_of_stock' => Icons.remove_shopping_cart_rounded,
    _ => Icons.warning_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = _severityColor(colorScheme);

    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMdLg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: DashboardSizes.iconContainer,
            height: DashboardSizes.iconContainer,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: AppDimens.radiusMediumSmall,
            ),
            child: Icon(_icon, size: AppDimens.iconMd, color: color),
          ),
          AppDimens.horizontalMediumSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        alert.productName,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: AppDimens.fontWeightBold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AppDimens.horizontalMediumSmall,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.spaceSmMd,
                        vertical: AppDimens.spaceXs + 1,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: AppDimens.radiusPill,
                      ),
                      child: Text(
                        _severityLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: color,
                          fontWeight: AppDimens.fontWeightBold,
                        ),
                      ),
                    ),
                  ],
                ),
                AppDimens.verticalSmall,
                Text(
                  alert.message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                AppDimens.spaceSmMd.verticalSpace,
                Wrap(
                  spacing: AppDimens.spaceSm,
                  runSpacing: AppDimens.spaceSm,
                  children: [
                    _MetaPill(
                      label: _alertTypeLabel,
                      color: colorScheme.onSurfaceVariant,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                    ),
                    _MetaPill(
                      label: _formatTime(alert.createdAt),
                      color: colorScheme.onSurfaceVariant,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }
    return DateFormat('MMM d').format(dt);
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.label,
    required this.color,
    required this.backgroundColor,
  });

  final String label;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSmMd,
        vertical: AppDimens.spaceXs + 1,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppDimens.radiusPill,
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: AppDimens.fontWeightSemiBold,
        ),
      ),
    );
  }
}

class _InventoryEmptyState extends StatelessWidget {
  const _InventoryEmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: AppDimens.paddingAllMediumLarge,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Text(
        'Inventory is currently within '
        'safe stock thresholds.',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
