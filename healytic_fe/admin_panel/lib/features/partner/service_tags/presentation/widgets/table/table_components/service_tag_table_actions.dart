import 'package:flutter/material.dart';

class ServiceTagTableActions {
  static List<({IconData icon, void Function(LocalKey?) onPressed})>
  buildRowActionButtons(BuildContext context) => [
    (icon: Icons.edit, onPressed: (key) => _onEditTag(context, key)),
    (icon: Icons.delete, onPressed: (key) => _onDeleteTag(context, key)),
  ];

  static void _onEditTag(BuildContext context, LocalKey? key) {
    // TODO: Implement edit tag functionality
    debugPrint('Edit tag: ${key?.toString()}');
  }

  static void _onDeleteTag(BuildContext context, LocalKey? key) {
    // TODO: Implement delete tag functionality
    debugPrint('Delete tag: ${key?.toString()}');
  }
}
