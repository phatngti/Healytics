import 'package:common/widgets/table/helper.dart';
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
            Text(
              employee.id.value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          DataCell(
            CircleAvatar(
              radius: 20,
              backgroundImage: employee.avatar.isNotEmpty
                  ? NetworkImage(employee.avatar)
                  : null,
              onBackgroundImageError: employee.avatar.isNotEmpty
                  ? (_, __) {}
                  : null,
              child: employee.avatar.isEmpty
                  ? Text(
                      _getInitials(employee.fullName),
                      style: Theme.of(context).textTheme.labelMedium,
                    )
                  : null,
            ),
          ),
          DataCell(
            Text(
              employee.fullName,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          DataCell(
            Text(
              employee.position,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          DataCell(
            Text(
              employee.rating.toStringAsFixed(1),
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          DataCell(
            Text(
              employee.reviewCount.toString(),
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          DataCell(
            Text(
              employee.status,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      );
    }).toList();

    // Add action button cells to each row
    final actionButtons = EmployeeTableActions.buildRowActionButtons(context);
    if (actionButtons.isNotEmpty) {
      for (final row in rows) {
        row.cells.add(
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: actionButtons
                  .map(
                    (action) => IconButton(
                      onPressed: () => action.onPressed(row.key),
                      icon: Icon(action.icon, size: 20),
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      style: IconButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      }
    }
    return rows;
  }

  static String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
}
