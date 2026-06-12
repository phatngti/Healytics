import 'package:admin_panel/core/keys/integration_test_keys.dart';
import 'package:admin_panel/features/common/widgets/table/management_table_controls.dart';
import 'package:admin_panel/features/partner/service_tags/presentation/providers/service_tag.provider.dart';
import 'package:common/widgets/table/function_button.dart';
import 'package:admin_panel/utils/device.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ServiceTagFunctionButtons {
  static List<TableFunctionButtonWidget> buildFunctionButtons(
    BuildContext context,
    WidgetRef ref,
    ServiceTagState state,
  ) => [
    _buildSortButton(context, ref, state),
    _buildFilterButton(context, ref, state),
  ];

  static TableFunctionButtonWidget _buildSortButton(
    BuildContext context,
    WidgetRef ref,
    ServiceTagState state,
  ) {
    final screenWidth = DeviceUtils.getScreenWidth(context);
    final notifier = ref.read(serviceTagProvider.notifier);

    return TableFunctionButtonWidget(
      key: keys.managementTables.serviceTagSortButton,
      offset: Offset(-screenWidth * 0.1 / 2, 40),
      label: 'Sort',
      prefixIcon: Icons.sort,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: TableFunctionButtonWidget.maxWidth,
        ),
        child: SizedBox(
          width: 220,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sortOption(
                label: 'Name',
                value: ServiceTagTableSort.name,
                state: state,
                onTap: notifier.setSort,
              ),
              _sortOption(
                label: 'Status',
                value: ServiceTagTableSort.status,
                state: state,
                onTap: notifier.setSort,
              ),
              _sortOption(
                label: 'Usage',
                value: ServiceTagTableSort.usage,
                state: state,
                onTap: notifier.setSort,
              ),
              _sortOption(
                label: 'Created At',
                value: ServiceTagTableSort.createdAt,
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
    BuildContext context,
    WidgetRef ref,
    ServiceTagState state,
  ) {
    final notifier = ref.read(serviceTagProvider.notifier);

    return TableFunctionButtonWidget(
      key: keys.managementTables.serviceTagFilterButton,
      label: 'Filter',
      prefixIcon: Icons.filter_alt,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: TableFunctionButtonWidget.maxWidth,
        ),
        child: SizedBox(
          width: 220,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _statusOption('All', ServiceTagStatusFilter.all, state, notifier),
              _statusOption(
                'Active',
                ServiceTagStatusFilter.active,
                state,
                notifier,
              ),
              _statusOption(
                'Inactive',
                ServiceTagStatusFilter.inactive,
                state,
                notifier,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _sortOption({
    required String label,
    required ServiceTagTableSort value,
    required ServiceTagState state,
    required ValueChanged<ServiceTagTableSort> onTap,
  }) {
    final isSelected = state.sortBy == value;
    final directionLabel = value == ServiceTagTableSort.createdAt
        ? (state.sortAscending ? 'Oldest' : 'Newest')
        : (state.sortAscending ? 'Asc' : 'Desc');
    return ManagementTableMenuOption(
      label: isSelected ? '$label ($directionLabel)' : label,
      selected: isSelected,
      icon: Icons.sort,
      onTap: () => onTap(value),
    );
  }

  static Widget _statusOption(
    String label,
    ServiceTagStatusFilter value,
    ServiceTagState state,
    ServiceTagNotifier notifier,
  ) {
    return ManagementTableMenuOption(
      label: label,
      selected: state.statusFilter == value,
      onTap: () => notifier.setStatusFilter(value),
    );
  }
}
