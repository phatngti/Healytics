import 'package:admin_panel/features/partner/service_tags/domain/service_tag.entity.dart';
import 'package:admin_panel/features/partner/service_tags/presentation/providers/service_tag.provider.dart';
import 'package:common/widgets/table/helper.dart';
import 'package:admin_panel/features/partner/service_tags/presentation/widgets/table/table_components/service_tag_table_actions.widget.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ServiceTagTableSource {
  /// Get total rows from provider state
  static Future<int> getTotalRows(BuildContext context, WidgetRef ref) async {
    final state = ref.watch(serviceTagProvider);
    return state.value?.totalCount ?? 0;
  }

  /// Get data rows from provider state
  static Future<List<DataRow>> getData(
    BuildContext context,
    WidgetRef ref,
    SetRowSelectionCallback setRowSelection,
    int startingAt,
    int count,
  ) async {
    final tags = await ref
        .read(serviceTagProvider.notifier)
        .getServiceTags(
          startingAt: startingAt,
          count: count,
          sortedBy: null,
          sortedAsc: true,
        );
    print("tags $tags");
    final rows = tags.map((tag) {
      return DataRow(
        key: ValueKey<String>(tag.id.value),
        onSelectChanged: (value) {
          if (value != null) {
            setRowSelection(ValueKey<String>(tag.id.value), value);
          }
        },
        cells: [
          // Tag Name
          DataCell(
            Text(
              tag.name,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          // Description
          DataCell(
            Text(
              tag.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Color Label
          DataCell(
            Container(
              height: 24,
              width: 64,
              decoration: BoxDecoration(
                color: tag.color,
                borderRadius: AppDimens.radiusSmall,
                boxShadow: [
                  BoxShadow(
                    color: tag.color.withAlpha(51),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          // Usage
          DataCell(
            Container(
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
                tag.usage.toString(),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ),
          // Status
          DataCell(_buildStatusBadge(context, tag.isActive)),
        ],
      );
    }).toList();

    // Add action button cells to each row
    final actionButtons = ServiceTagTableActions.buildRowActionButtons(context);
    if (actionButtons.isNotEmpty) {
      for (final row in rows) {
        row.cells.add(
          DataCell(
            Row(
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
        );
      }
    }
    return rows;
  }

  static Widget _buildStatusBadge(BuildContext context, bool isActive) {
    final semantic = Theme.of(context).extension<SemanticColors>();

    return Container(
      padding: AppDimens.paddingHorizontalSmall.add(
        AppDimens.paddingVerticalExtraSmall,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? semantic?.success?.withAlpha(26)
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(
          color: isActive
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
              color: isActive
                  ? semantic?.success
                  : Theme.of(context).colorScheme.outline,
            ),
          ),
          AppDimens.horizontalSmall,
          Text(
            isActive ? 'Active' : 'Inactive',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isActive
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
