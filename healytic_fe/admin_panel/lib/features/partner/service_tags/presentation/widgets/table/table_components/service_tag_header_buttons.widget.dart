import 'package:admin_panel/core/keys/integration_test_keys.dart';
import 'package:admin_panel/features/common/widgets/table/management_table_controls.dart';
import 'package:admin_panel/features/partner/service_tags/presentation/providers/service_tag.provider.dart';
import 'package:admin_panel/features/partner/service_tags/presentation/widgets/add_service_tag_dialog.widget.dart';
import 'package:common/widgets/button/button.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Builds header action buttons for the service tags table.
class ServiceTagHeaderButtons {
  /// Returns a list of header buttons for the table.
  ///
  /// Requires [ref] so the dialog can interact with
  /// the [serviceTagProvider].
  static List<AppButton> buildTableButtons(
    BuildContext context,
    WidgetRef ref,
    ServiceTagState state,
  ) => [
    _buildAddButton(context, ref),
    _buildDeleteSelectedButton(context, ref, state),
  ];

  static AppButton _buildAddButton(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppButton(
      buttonType: ButtonType.elevated,
      onPressed: () async {
        final created = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => const AddServiceTagDialog(),
        );

        if (created == true) {
          ref.read(serviceTagProvider.notifier).refresh();
        }
      },
      child: Row(
        children: [
          Icon(Icons.add, color: colorScheme.onPrimary),
          AppDimens.horizontalSmall,
          Text(
            'Add New Tag',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary),
          ),
        ],
      ),
    );
  }

  static AppButton _buildDeleteSelectedButton(
    BuildContext context,
    WidgetRef ref,
    ServiceTagState state,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final selectedCount = state.selectedIds.length;

    return AppButton(
      key: keys.managementTables.serviceTagDeleteSelectedButton,
      buttonType: ButtonType.elevated,
      onPressed: selectedCount == 0
          ? null
          : () async {
              final confirmed = await confirmManagementTableDelete(
                context,
                title: 'Delete selected service tags?',
                message:
                    'This will delete $selectedCount selected service tag(s).',
              );
              if (!confirmed) return;

              try {
                await ref.read(serviceTagProvider.notifier).deleteSelected();
                if (!context.mounted) return;
                showManagementTableSnackBar(
                  context,
                  message: 'Deleted $selectedCount service tag(s).',
                );
              } catch (error) {
                if (!context.mounted) return;
                showManagementTableSnackBar(
                  context,
                  message: 'Failed to delete service tags: $error',
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
