import 'package:admin_panel/features/partner/dashboard/presentation/widgets/dashboard_section_header.widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardSectionHeader(
              title: 'Quick Actions',
              icon: Icons.bolt_rounded,
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final useSingleColumn = constraints.maxWidth < 440;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _actions.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: useSingleColumn ? 1 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 56,
                  ),
                  itemBuilder: (context, index) {
                    return _ActionButton(action: _actions[index]);
                  },
                );
              },
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
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => context.go(action.route),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(action.icon, size: 20, color: colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  action.label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
