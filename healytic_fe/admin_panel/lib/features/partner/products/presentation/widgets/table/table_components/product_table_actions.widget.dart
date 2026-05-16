import 'package:admin_panel/core/extension/local_key_ext.dart';
import 'package:admin_panel/features/common/widgets/table/management_table_controls.dart';
import 'package:admin_panel/features/partner/products/presentation/providers/product.provider.dart';
import 'package:admin_panel/router/partner_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductTableActions {
  static List<({IconData icon, void Function(LocalKey?) onPressed})>
  buildRowActionButtons(BuildContext context, WidgetRef ref) => [
    (icon: Icons.info, onPressed: (key) => _onViewDetails(context, key)),
    (icon: Icons.edit, onPressed: (key) => _onEditProduct(context, key)),
    (
      icon: Icons.delete,
      onPressed: (key) => _onDeleteProduct(context, ref, key),
    ),
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

  static Future<void> _onDeleteProduct(
    BuildContext context,
    WidgetRef ref,
    LocalKey? key,
  ) async {
    final id = key?.toCleanString();
    if (id == null || id.isEmpty) return;

    final confirmed = await confirmManagementTableDelete(
      context,
      title: 'Delete product?',
      message: 'This will delete the selected product record.',
    );
    if (!confirmed) return;

    try {
      await ref.read(productProvider.notifier).deleteOne(id);
      if (!context.mounted) return;
      showManagementTableSnackBar(context, message: 'Product deleted.');
    } catch (error) {
      if (!context.mounted) return;
      showManagementTableSnackBar(
        context,
        message: 'Failed to delete product: $error',
        isError: true,
      );
    }
  }
}
