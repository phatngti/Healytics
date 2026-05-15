import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/providers/partner_manager.provider.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/providers/partner_manager_state.dart';
import 'package:admin_panel/features/common/widgets/table/management_table_controls.dart';
import 'package:admin_panel/utils/device.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/table/function_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Function buttons for the partner verification table
class PartnerFunctionButtons {
  static List<TableFunctionButtonWidget> buildFunctionButtons(
    BuildContext context,
    WidgetRef ref,
    PartnerManagerState state,
  ) => [_buildSortButton(context, ref, state), _buildFilterButton(ref, state)];

  static TableFunctionButtonWidget _buildSortButton(
    BuildContext context,
    WidgetRef ref,
    PartnerManagerState state,
  ) {
    final screenWidth = DeviceUtils.getScreenWidth(context);
    final notifier = ref.read(partnerManagerWorkspaceProvider.notifier);

    return TableFunctionButtonWidget(
      offset: Offset(-screenWidth * 0.1 / 2, 40),
      label: 'Sort',
      prefixIcon: Icons.sort,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: TableFunctionButtonWidget.maxWidth,
        ),
        child: SizedBox(
          width: 260,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _sortOption(
                label: 'Date Submitted (Newest)',
                sortBy: 'submittedAt',
                sortAsc: false,
                state: state,
                onTap: notifier.setSort,
              ),
              _sortOption(
                label: 'Date Submitted (Oldest)',
                sortBy: 'submittedAt',
                sortAsc: true,
                state: state,
                onTap: notifier.setSort,
              ),
              _sortOption(
                label: 'Priority (High to Low)',
                sortBy: 'priority',
                sortAsc: false,
                state: state,
                onTap: notifier.setSort,
              ),
              _sortOption(
                label: 'Name (A-Z)',
                sortBy: 'name',
                sortAsc: true,
                state: state,
                onTap: notifier.setSort,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static TableFunctionButtonWidget _buildFilterButton(
    WidgetRef ref,
    PartnerManagerState state,
  ) {
    final notifier = ref.read(partnerManagerWorkspaceProvider.notifier);

    return TableFunctionButtonWidget(
      label: 'Filter',
      prefixIcon: Icons.filter_alt,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: TableFunctionButtonWidget.maxWidth,
        ),
        child: SizedBox(
          width: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ManagementTableMenuSection(
                title: 'Status',
                children: [
                  _statusOption(
                    label: 'All Statuses',
                    value: null,
                    state: state,
                    onTap: notifier.setStatusFilter,
                  ),
                  _statusOption(
                    label: 'Pending',
                    value: PartnerVerificationStatus.pending,
                    state: state,
                    onTap: notifier.setStatusFilter,
                  ),
                  _statusOption(
                    label: 'Changes Required',
                    value: PartnerVerificationStatus.requiredResubmit,
                    state: state,
                    onTap: notifier.setStatusFilter,
                  ),
                  _statusOption(
                    label: 'Approved',
                    value: PartnerVerificationStatus.approved,
                    state: state,
                    onTap: notifier.setStatusFilter,
                  ),
                  _statusOption(
                    label: 'Rejected',
                    value: PartnerVerificationStatus.rejected,
                    state: state,
                    onTap: notifier.setStatusFilter,
                  ),
                ],
              ),
              AppDimens.verticalSmall,
              ManagementTableMenuSection(
                title: 'Priority',
                children: [
                  ManagementTableMenuOption(
                    label: 'High Priority',
                    selected:
                        state.quickFilter ==
                        PartnerManagerQuickFilter.highPriority,
                    icon: Icons.flag,
                    onTap: () {
                      notifier.setQuickFilter(
                        state.quickFilter ==
                                PartnerManagerQuickFilter.highPriority
                            ? null
                            : PartnerManagerQuickFilter.highPriority,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _sortOption({
    required String label,
    required String sortBy,
    required bool sortAsc,
    required PartnerManagerState state,
    required void Function(String sortBy, bool sortAsc) onTap,
  }) {
    return ManagementTableMenuOption(
      label: label,
      selected: state.sortBy == sortBy && state.sortAsc == sortAsc,
      icon: Icons.sort,
      onTap: () => onTap(sortBy, sortAsc),
    );
  }

  static Widget _statusOption({
    required String label,
    required PartnerVerificationStatus? value,
    required PartnerManagerState state,
    required ValueChanged<PartnerVerificationStatus?> onTap,
  }) {
    return ManagementTableMenuOption(
      label: label,
      selected: state.statusFilter == value && state.quickFilter == null,
      onTap: () => onTap(value),
    );
  }
}
