import 'package:admin_panel/core/extension/local_key_ext.dart';
import 'package:admin_panel/features/admin/category/presentation/providers/category.provider.dart';
import 'package:admin_panel/features/common/widgets/table/management_table_controls.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoryTableActions {
  static List<({IconData icon, void Function(LocalKey?) onPressed})>
  buildRowActionButtons(BuildContext context, WidgetRef ref) => [
    (icon: Icons.edit, onPressed: (key) => _onEditCategory(context, key)),
    (
      icon: Icons.delete,
      onPressed: (key) => _onDeleteCategory(context, ref, key),
    ),
  ];

  static void _onEditCategory(BuildContext context, LocalKey? key) {
    // TODO: Implement edit category functionality
    debugPrint('Edit category: ${key?.toString()}');
  }

  static Future<void> _onDeleteCategory(
    BuildContext context,
    WidgetRef ref,
    LocalKey? key,
  ) async {
    final id = key?.toCleanString();
    if (id == null || id.isEmpty) return;

    final confirmed = await confirmManagementTableDelete(
      context,
      title: 'Delete category?',
      message: 'This will delete the selected category record.',
    );
    if (!confirmed) return;

    try {
      await ref.read(categoryProvider.notifier).deleteOne(id);
      if (!context.mounted) return;
      showManagementTableSnackBar(context, message: 'Category deleted.');
    } catch (error) {
      if (!context.mounted) return;
      showManagementTableSnackBar(
        context,
        message: 'Failed to delete category: $error',
        isError: true,
      );
    }
  }
}
