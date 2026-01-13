import 'package:admin_panel/core/extension/local_key_ext.dart';
import 'package:admin_panel/router/partner_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductTableActions {
  static List<({IconData icon, void Function(LocalKey?) onPressed})>
  buildRowActionButtons(BuildContext context) => [
    (icon: Icons.info, onPressed: (key) => _onViewDetails(context, key)),
    (icon: Icons.edit, onPressed: (key) => _onEditProduct(context, key)),
    (icon: Icons.delete, onPressed: (key) => _onDeleteProduct(key)),
  ];

  static void _onViewDetails(BuildContext context, LocalKey? key) {
    final id = key?.toCleanString();
    if (id != null && id.isNotEmpty) {
      context.goNamed(ProductDetailsRoute.name, pathParameters: {'id': id});
    }
  }

  static void _onEditProduct(BuildContext context, LocalKey? key) {
    final id = key?.toCleanString();
    if (id != null && id.isNotEmpty) {
      context.goNamed(ProductEditRoute.name, pathParameters: {'id': id});
    }
  }

  static void _onDeleteProduct(LocalKey? key) {
    // TODO: Implement delete functionality
    print(key?.toCleanString());
  }
}
