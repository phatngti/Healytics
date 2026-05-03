import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_period.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Tab bar for workspace tabs (Overview, Ledger, etc.).
class AdminFinanceStatusTabs extends StatelessWidget {
  const AdminFinanceStatusTabs({
    super.key,
    required this.activeTab,
    required this.onChanged,
  });

  final AdminFinanceWorkspaceTab activeTab;
  final ValueChanged<AdminFinanceWorkspaceTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: AdminFinanceWorkspaceTab.values.map(
          (tab) {
            final isActive = tab == activeTab;
            return Padding(
              padding: const EdgeInsets.only(
                right: AppDimens.spaceSmMd,
              ),
              child: FilterChip(
                selected: isActive,
                label: Text(tab.label),
                showCheckmark: false,
                onSelected: (_) => onChanged(tab),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
