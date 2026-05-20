import 'package:common/widgets/table/table.dart';
import 'package:admin_panel/core/keys/integration_test_keys.dart';
import 'package:admin_panel/features/admin/category/presentation/providers/category.provider.dart';
import 'package:admin_panel/features/admin/category/presentation/widgets/table/table_components/category_function_buttons.dart';
import 'package:admin_panel/features/admin/category/presentation/widgets/table/table_components/category_header_buttons.dart';
import 'package:admin_panel/features/admin/category/presentation/widgets/table/table_components/category_table_columns.dart';
import 'package:admin_panel/features/admin/category/presentation/widgets/table/table_components/category_table_source.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoryTable extends HookConsumerWidget {
  const CategoryTable({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableState =
        ref.watch(categoryProvider).value ?? const CategoryState();
    final queryHash = Object.hash(
      tableState.searchQuery,
      tableState.sortBy,
      tableState.sortAscending,
      tableState.visibilityFilter,
    );

    return SizedBox(
      height: height,
      child: AppTable(
        refreshToken: Object.hash(tableState.reloadToken, queryHash),
        columns: CategoryTableColumns.columns.dataColumns(context),
        getTotalRows: () =>
            ref.read(categoryProvider.notifier).getVisibleTotalRows(),
        getData: (setRowSelection, startingAt, count) =>
            CategoryTableSource.getData(
              context,
              ref,
              setRowSelection,
              startingAt,
              count,
            ),
        defaultRowsPerPage: 10,
        buttons: CategoryHeaderButtons.buildTableButtons(
          context,
          ref,
          tableState,
        ),
        searchFieldKey: keys.managementTables.categorySearchField,
        onSearchChanged: ref.read(categoryProvider.notifier).setSearchQuery,
        functionButtons: CategoryFunctionButtons.buildFunctionButtons(
          context,
          ref,
          tableState,
        ),
      ),
    );
  }
}
