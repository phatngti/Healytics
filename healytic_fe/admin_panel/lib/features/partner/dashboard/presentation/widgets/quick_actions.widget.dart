import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'dashboard_section_header.widget.dart';

/// Grid of quick action buttons for common tasks.
///
/// Each action navigates to the corresponding
/// feature route (add service, add employee, etc.).
class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  static const _actions = [
    _QuickAction(
      icon: Icons.add_circle_outline_rounded,
      label: 'Add Service',
      route: '/provider/products/add',
    ),
    _QuickAction(
      icon: Icons.person_add_alt_1_rounded,
      label: 'Add Employee',
      route: '/provider/employee/add',
    ),
    _QuickAction(
      icon: Icons.inventory_2_outlined,
      label: 'Manage Services',
      route: '/provider/products',
    ),
    _QuickAction(
      icon: Icons.chat_bubble_outline_rounded,
      label: 'Messages',
      route: '/provider/chat',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimens.radiusMediumSmall,
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: AppDimens.paddingAllMediumLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DashboardSectionHeader(
              title: 'Quick Actions',
              icon: Icons.bolt_rounded,
            ),
            Column(
              spacing: AppDimens.spaceSm,
              children: _actions.map((a) => _ActionButton(action: a)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.action});

  final _QuickAction action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: AppDimens.radiusSmall,
      child: InkWell(
        borderRadius: AppDimens.radiusSmall,
        onTap: () => context.go(action.route),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMd,
            vertical: AppDimens.spaceSmMd,
          ),
          child: Row(
            children: [
              Icon(
                action.icon,
                size: AppDimens.iconMd,
                color: colorScheme.primary,
              ),
              AppDimens.horizontalSmall,
              Expanded(
                child: Text(
                  action.label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: AppDimens.fontWeightMedium,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: AppDimens.iconXs,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
