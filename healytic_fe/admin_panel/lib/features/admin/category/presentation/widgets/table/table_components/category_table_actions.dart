import 'package:flutter/material.dart';

class CategoryTableActions {
  static List<({IconData icon, void Function(LocalKey?) onPressed})>
  buildRowActionButtons(BuildContext context) => [
    (icon: Icons.edit, onPressed: (key) => _onEditCategory(context, key)),
    (icon: Icons.delete, onPressed: (key) => _onDeleteCategory(context, key)),
  ];

  static void _onEditCategory(BuildContext context, LocalKey? key) {
    // TODO: Implement edit category functionality
    debugPrint('Edit category: ${key?.toString()}');
  }

  static void _onDeleteCategory(BuildContext context, LocalKey? key) {
    // TODO: Implement delete category functionality
    debugPrint('Delete category: ${key?.toString()}');
  }
}
