import 'package:admin_panel/features/common/widgets/table/helper.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee.provider.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_home/table_components/employee_table_actions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EmployeeTableSource {
  static Future<List<DataRow>> getData(
    BuildContext context,
    WidgetRef ref,
    SetRowSelectionCallback setRowSelection,
    int startingAt,
    int count,
  ) async {
    final employees = await ref
        .read(employeeProvider.notifier)
        .getEmployees(
          startingAt: startingAt,
          count: count,
          search: null,
          sortAscending: false,
        );

    final rows = employees.map((employee) {
      return DataRow(
        key: ValueKey<String>(employee.id.value),
        onSelectChanged: (value) {
          if (value != null) {
            setRowSelection(ValueKey<String>(employee.id.value), value);
          }
        },
        cells: [
          DataCell(
            Center(
              child: Text(
                employee.id.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          DataCell(
            Center(
              child: ClipOval(
                child: employee.avatar.isNotEmpty
                    ? Image.network(
                        employee.avatar,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const CircleAvatar(child: Icon(Icons.person));
                        },
                      )
                    : const CircleAvatar(child: Icon(Icons.person)),
              ),
            ),
          ),
          DataCell(Center(child: Text(employee.fullName))),
          DataCell(Center(child: Text(employee.position))),
          DataCell(Center(child: Text(employee.rating.toStringAsFixed(1)))),
          DataCell(Center(child: Text(employee.reviewCount.toString()))),
          DataCell(Center(child: Text(employee.status))),
        ],
      );
    }).toList();

    // Add action button cells to each row
    final actionButtons = EmployeeTableActions.buildRowActionButtons(context);
    if (actionButtons.isNotEmpty) {
      for (final row in rows) {
        row.cells.add(
          DataCell(
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: actionButtons
                    .map(
                      (action) => IconButton(
                        onPressed: () => action.onPressed(row.key),
                        icon: Icon(action.icon),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );
      }
    }
    return rows;
  }
}
