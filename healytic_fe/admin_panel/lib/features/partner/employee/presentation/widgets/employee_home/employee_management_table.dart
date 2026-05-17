import 'package:common/widgets/table/table.dart';
import 'package:admin_panel/core/keys/integration_test_keys.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee.provider.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_home/table_components/employee_function_buttons.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_home/table_components/employee_header_buttons.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_home/table_components/employee_table_columns.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_home/table_components/employee_table_source.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EmployeeManagementTable extends HookConsumerWidget {
  const EmployeeManagementTable({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableState =
        ref.watch(employeeProvider).value ?? const EmployeeState();
    final queryHash = Object.hash(
      tableState.searchQuery,
      tableState.sortBy,
      tableState.sortAscending,
      tableState.roleFilter,
      tableState.statusFilter,
    );

    return SizedBox(
      height: height,
      child: AppTable(
        refreshToken: Object.hash(tableState.reloadToken, queryHash),
        columns: EmployeeTableColumns.columns.dataColumns(context),
        getTotalRows: () =>
            ref.read(employeeProvider.notifier).getVisibleTotalRows(),
        getData: (setRowSelection, startingAt, count) =>
            EmployeeTableSource.getData(
              context,
              ref,
              setRowSelection,
              startingAt,
              count,
            ),
        defaultRowsPerPage: 10,
        buttons: EmployeeHeaderButtons.buildTableButtons(
          context,
          ref,
          tableState,
        ),
        searchFieldKey: keys.managementTables.employeeSearchField,
        onSearchChanged: ref.read(employeeProvider.notifier).setSearchQuery,
        functionButtons: EmployeeFunctionButtons.buildFunctionButtons(
          context,
          ref,
          tableState,
        ),
      ),
    );
  }
}
