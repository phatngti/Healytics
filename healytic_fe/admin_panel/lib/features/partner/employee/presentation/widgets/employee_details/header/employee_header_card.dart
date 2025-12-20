import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

import 'employee_avatar_section.dart';
import 'employee_role_branch_section.dart';
import 'employee_stats_actions_section.dart';

class EmployeeHeaderCard extends StatelessWidget {
  const EmployeeHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const EmployeeAvatarSection(),
          AppDimens.horizontalLarge,
          const Expanded(child: EmployeeRoleBranchSection()),
          const EmployeeStatsActionsSection(),
        ],
      ),
    );
  }
}
