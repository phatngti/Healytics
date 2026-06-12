import 'package:admin_panel/core/keys/integration_test_keys.dart';
import 'package:admin_panel/features/common/widgets/table/management_table_controls.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee.provider.dart';
import 'package:common/widgets/table/function_button.dart';
import 'package:common/utils/demensions.dart';
import 'package:admin_panel/utils/device.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EmployeeFunctionButtons {
  static List<TableFunctionButtonWidget> buildFunctionButtons(
    BuildContext context,
    WidgetRef ref,
    EmployeeState state,
  ) => [
    _buildSortButton(context, ref, state),
    _buildFilterButton(context, ref, state),
  ];

  static TableFunctionButtonWidget _buildSortButton(
    BuildContext context,
    WidgetRef ref,
    EmployeeState state,
  ) {
    final screenWidth = DeviceUtils.getScreenWidth(context);
    final notifier = ref.read(employeeProvider.notifier);

    return TableFunctionButtonWidget(
      key: keys.managementTables.employeeSortButton,
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
                value: EmployeeTableSort.name,
                state: state,
                onTap: notifier.setSort,
              ),
              _sortOption(
                label: 'Position',
                value: EmployeeTableSort.position,
                state: state,
                onTap: notifier.setSort,
              ),
              _sortOption(
                label: 'Rating',
                value: EmployeeTableSort.rating,
                state: state,
                onTap: notifier.setSort,
              ),
              _sortOption(
                label: 'Review Count',
                value: EmployeeTableSort.reviewCount,
                state: state,
                onTap: notifier.setSort,
              ),
              _sortOption(
                label: 'Status',
                value: EmployeeTableSort.status,
                state: state,
                onTap: notifier.setSort,
              ),
              _sortOption(
                label: 'Created At',
                value: EmployeeTableSort.createdAt,
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
    EmployeeState state,
  ) {
    final notifier = ref.read(employeeProvider.notifier);

    return TableFunctionButtonWidget(
      key: keys.managementTables.employeeFilterButton,
      label: 'Filter',
      prefixIcon: Icons.filter_alt,
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
              ManagementTableMenuSection(
                title: 'Role',
                children: [
                  _roleOption(
                    'All Roles',
                    EmployeeRoleFilter.all,
                    state,
                    notifier,
                  ),
                  _roleOption(
                    'Doctor',
                    EmployeeRoleFilter.doctor,
                    state,
                    notifier,
                  ),
                  _roleOption(
                    'Therapist',
                    EmployeeRoleFilter.therapist,
                    state,
                    notifier,
                  ),
                  _roleOption(
                    'Receptionist',
                    EmployeeRoleFilter.receptionist,
                    state,
                    notifier,
                  ),
                  _roleOption(
                    'Manager',
                    EmployeeRoleFilter.manager,
                    state,
                    notifier,
                  ),
                ],
              ),
              AppDimens.verticalSmall,
              ManagementTableMenuSection(
                title: 'Status',
                children: [
                  _statusOption(
                    'All Statuses',
                    EmployeeStatusFilter.all,
                    state,
                    notifier,
                  ),
                  _statusOption(
                    'Active',
                    EmployeeStatusFilter.active,
                    state,
                    notifier,
                  ),
                  _statusOption(
                    'Inactive',
                    EmployeeStatusFilter.inactive,
                    state,
                    notifier,
                  ),
                  _statusOption(
                    'On Leave',
                    EmployeeStatusFilter.onLeave,
                    state,
                    notifier,
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
    required EmployeeTableSort value,
    required EmployeeState state,
    required ValueChanged<EmployeeTableSort> onTap,
  }) {
    final isSelected = state.sortBy == value;
    final directionLabel = value == EmployeeTableSort.createdAt
        ? (state.sortAscending ? 'Oldest' : 'Newest')
        : (state.sortAscending ? 'A-Z' : 'Z-A');
    return ManagementTableMenuOption(
      label: isSelected ? '$label ($directionLabel)' : label,
      selected: isSelected,
      icon: Icons.sort,
      onTap: () => onTap(value),
    );
  }

  static Widget _roleOption(
    String label,
    EmployeeRoleFilter value,
    EmployeeState state,
    EmployeeNotifier notifier,
  ) {
    return ManagementTableMenuOption(
      label: label,
      selected: state.roleFilter == value,
      onTap: () => notifier.setRoleFilter(value),
    );
  }

  static Widget _statusOption(
    String label,
    EmployeeStatusFilter value,
    EmployeeState state,
    EmployeeNotifier notifier,
  ) {
    return ManagementTableMenuOption(
      label: label,
      selected: state.statusFilter == value,
      onTap: () => notifier.setStatusFilter(value),
    );
  }
}
