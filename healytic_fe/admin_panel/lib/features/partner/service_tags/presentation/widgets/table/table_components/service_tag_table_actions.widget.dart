import 'package:admin_panel/core/extension/local_key_ext.dart';
import 'package:admin_panel/features/common/widgets/table/management_table_controls.dart';
import 'package:admin_panel/features/partner/service_tags/presentation/providers/service_tag.provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ServiceTagTableActions {
  static List<({IconData icon, void Function(LocalKey?) onPressed})>
  buildRowActionButtons(BuildContext context, WidgetRef ref) => [
    (icon: Icons.edit, onPressed: (key) => _onEditTag(context, key)),
    (icon: Icons.delete, onPressed: (key) => _onDeleteTag(context, ref, key)),
  ];

  static void _onEditTag(BuildContext context, LocalKey? key) {
    // TODO: Implement edit tag functionality
    debugPrint('Edit tag: ${key?.toString()}');
  }

  static Future<void> _onDeleteTag(
    BuildContext context,
    WidgetRef ref,
    LocalKey? key,
  ) async {
    final id = key?.toCleanString();
    if (id == null || id.isEmpty) return;

    final confirmed = await confirmManagementTableDelete(
      context,
      title: 'Delete service tag?',
      message: 'This will delete the selected service tag.',
    );
    if (!confirmed) return;

    try {
      await ref.read(serviceTagProvider.notifier).deleteOne(id);
      if (!context.mounted) return;
      showManagementTableSnackBar(context, message: 'Service tag deleted.');
    } catch (error) {
      if (!context.mounted) return;
      showManagementTableSnackBar(
        context,
        message: 'Failed to delete service tag: $error',
        isError: true,
      );
    }
  }
}
