import 'package:admin_panel/core/extension/local_key_ext.dart';
import 'package:admin_panel/features/common/widgets/table/management_table_controls.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee.provider.dart';
import 'package:admin_panel/router/partner_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EmployeeTableActions {
  static List<({IconData icon, void Function(LocalKey?) onPressed})>
  buildRowActionButtons(BuildContext context, WidgetRef ref) => [
    (icon: Icons.info, onPressed: (key) => _onViewDetails(context, key)),
    (icon: Icons.edit, onPressed: (key) => _onEditEmployee(context, key)),
    (
      icon: Icons.delete,
      onPressed: (key) => _onDeleteEmployee(context, ref, key),
    ),
  ];

  static void _onViewDetails(BuildContext context, LocalKey? key) {
    final id = key?.toCleanString();
    if (id != null) {
      context.goNamed(EmployeeDetailsRoute.name, pathParameters: {'id': id});
    }
  }

  static void _onEditEmployee(BuildContext context, LocalKey? key) {
    final id = key?.toCleanString();
    if (id != null) {
      context.goNamed(EmployeeEditRoute.name, pathParameters: {'id': id});
    }
  }

  static Future<void> _onDeleteEmployee(
    BuildContext context,
    WidgetRef ref,
    LocalKey? key,
  ) async {
    final id = key?.toCleanString();
    if (id == null || id.isEmpty) return;

    final confirmed = await confirmManagementTableDelete(
      context,
      title: 'Delete employee?',
      message: 'This will delete the selected employee record.',
    );
    if (!confirmed) return;

    try {
      await ref.read(employeeProvider.notifier).deleteOne(id);
      if (!context.mounted) return;
      showManagementTableSnackBar(context, message: 'Employee deleted.');
    } catch (error) {
      if (!context.mounted) return;
      showManagementTableSnackBar(
        context,
        message: 'Failed to delete employee: $error',
        isError: true,
      );
    }
  }
}
