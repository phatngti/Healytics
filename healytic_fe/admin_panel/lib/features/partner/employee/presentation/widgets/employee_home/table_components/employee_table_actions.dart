import 'package:admin_panel/core/extension/local_key_ext.dart';
import 'package:admin_panel/router/partner_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmployeeTableActions {
  static List<({IconData icon, void Function(LocalKey?) onPressed})>
  buildRowActionButtons(BuildContext context) => [
    (icon: Icons.info, onPressed: (key) => _onViewDetails(context, key)),
    (icon: Icons.edit, onPressed: (key) => _onEditEmployee(context, key)),
    (icon: Icons.delete, onPressed: (key) => _onDeleteEmployee(key)),
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

  static void _onDeleteEmployee(LocalKey? key) {
    // TODO: Implement delete functionality
    print(key?.toCleanString());
  }
}
