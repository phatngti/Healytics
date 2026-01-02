import 'package:admin_panel/features/common/widgets/table/table.dart';
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
    return SizedBox(
      height: height,
      child: AppTable(
        columns: EmployeeTableColumns.columns.dataColumns(context),
        getTotalRows: () => ref.read(employeeProvider.notifier).getTotalRows(),
        getData: (setRowSelection, startingAt, count) =>
            EmployeeTableSource.getData(
              context,
              ref,
              setRowSelection,
              startingAt,
              count,
            ),
        defaultRowsPerPage: 10,
        buttons: EmployeeHeaderButtons.buildTableButtons(context),
        onSearchChanged: (value) {
          // ref.read(employeeProvider.notifier).searchEmployees(value);
        },
        functionButtons: EmployeeFunctionButtons.buildFunctionButtons(context),
      ),
    );
  }
}
