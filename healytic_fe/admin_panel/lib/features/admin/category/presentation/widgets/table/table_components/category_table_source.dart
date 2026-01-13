import 'package:admin_panel/features/admin/category/domain/category.entity.dart';
import 'package:admin_panel/features/admin/category/presentation/providers/category.provider.dart';
import 'package:admin_panel/features/common/widgets/table/helper.dart';
import 'package:admin_panel/features/admin/category/presentation/widgets/table/table_components/category_table_actions.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoryTableSource {
  static Future<int> getTotalRows(WidgetRef ref) async {
    final notifier = ref.read(categoryProvider.notifier);
    return notifier.getTotalRows();
  }

  static Future<List<DataRow>> getData(
    BuildContext context,
    WidgetRef ref,
    SetRowSelectionCallback setRowSelection,
    int startingAt,
    int count,
  ) async {
    final notifier = ref.read(categoryProvider.notifier);
    final categories = await notifier.getCategories(
      startingAt: startingAt,
      count: count,
    );

    final rows = categories.map((category) {
      return DataRow(
        key: ValueKey<String>(category.id.value),
        onSelectChanged: (value) {
          if (value != null) {
            setRowSelection(ValueKey<String>(category.id.value), value);
          }
        },
        cells: [
          // Icon
          DataCell(
            Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: category.color.withAlpha(51),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withAlpha(26),
                  ),
                ),
                child: Icon(category.icon, color: category.color, size: 20),
              ),
            ),
          ),
          // Category Name
          DataCell(
            Text(
              category.name,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          // Description
          DataCell(
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Text(
                category.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Total Services
          DataCell(
            Center(
              child: Container(
                padding: AppDimens.paddingHorizontalSmall.add(
                  AppDimens.paddingVerticalExtraSmall,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: AppDimens.radiusExtraSmall,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withAlpha(51),
                  ),
                ),
                child: Text(
                  '${category.serviceCount} Services',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          // Status
          DataCell(_buildStatusBadge(context, category.isVisible)),
        ],
      );
    }).toList();

    // Add action button cells to each row
    final actionButtons = CategoryTableActions.buildRowActionButtons(context);
    if (actionButtons.isNotEmpty) {
      for (final row in rows) {
        row.cells.add(
          DataCell(
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: actionButtons
                    .map(
                      (action) => IconButton(
                        onPressed: () => action.onPressed(row.key),
                        icon: Icon(action.icon, size: 20),
                        padding: AppDimens.paddingAllExtraSmall,
                        constraints: const BoxConstraints(),
                        style: IconButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );
      }
    }
    return rows;
  }

  static Widget _buildStatusBadge(BuildContext context, bool isVisible) {
    final semantic = Theme.of(context).extension<SemanticColors>();

    return Container(
      padding: AppDimens.paddingHorizontalSmall.add(
        AppDimens.paddingVerticalExtraSmall,
      ),
      decoration: BoxDecoration(
        color: isVisible
            ? semantic?.success?.withAlpha(26)
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(
          color: isVisible
              ? semantic?.success?.withAlpha(51) ??
                    Theme.of(context).colorScheme.outline.withAlpha(51)
              : Theme.of(context).colorScheme.outline.withAlpha(51),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isVisible
                  ? semantic?.success
                  : Theme.of(context).colorScheme.outline,
            ),
          ),
          AppDimens.horizontalSmall,
          Text(
            isVisible ? 'Visible' : 'Hidden',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isVisible
                  ? semantic?.success
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
