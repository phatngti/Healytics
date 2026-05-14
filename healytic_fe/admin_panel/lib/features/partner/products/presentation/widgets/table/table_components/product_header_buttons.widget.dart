import 'package:admin_panel/core/keys/integration_test_keys.dart';
import 'package:admin_panel/features/common/widgets/table/management_table_controls.dart';
import 'package:admin_panel/features/partner/products/presentation/providers/product.provider.dart';
import 'package:common/widgets/button/button.dart';
import 'package:admin_panel/router/partner_routes.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductHeaderButtons {
  static List<AppButton> buildTableButtons(
    BuildContext context,
    WidgetRef ref,
    ProductState state,
  ) => [
    _buildAddButton(context),
    _buildDeleteSelectedButton(context, ref, state),
  ];

  static AppButton _buildAddButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppButton(
      buttonType: ButtonType.elevated,
      onPressed: () => context.goNamed(ProductAddRoute.name),
      child: Row(
        children: [
          Icon(Icons.add, color: colorScheme.onPrimary),
          AppDimens.horizontalSmall,
          Text(
            'Add Product',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary),
          ),
        ],
      ),
    );
  }

  static AppButton _buildDeleteSelectedButton(
    BuildContext context,
    WidgetRef ref,
    ProductState state,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final selectedCount = state.selectedIds.length;

    return AppButton(
      key: keys.managementTables.productDeleteSelectedButton,
      buttonType: ButtonType.elevated,
      onPressed: selectedCount == 0
          ? null
          : () async {
              final confirmed = await confirmManagementTableDelete(
                context,
                title: 'Delete selected products?',
                message:
                    'This will delete $selectedCount selected product record(s).',
              );
              if (!confirmed) return;

              try {
                await ref.read(productProvider.notifier).deleteSelected();
                if (!context.mounted) return;
                showManagementTableSnackBar(
                  context,
                  message: 'Deleted $selectedCount product record(s).',
                );
              } catch (error) {
                if (!context.mounted) return;
                showManagementTableSnackBar(
                  context,
                  message: 'Failed to delete products: $error',
                  isError: true,
                );
              }
            },
      customStyle: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(colorScheme.error),
        foregroundColor: WidgetStatePropertyAll(colorScheme.onError),
      ),
      child: Row(
        children: [
          Icon(Icons.delete, color: colorScheme.onError),
          AppDimens.horizontalSmall,
          Text(
            selectedCount == 0 ? 'Delete Selected' : 'Delete $selectedCount',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onError),
          ),
        ],
      ),
    );
  }
}
