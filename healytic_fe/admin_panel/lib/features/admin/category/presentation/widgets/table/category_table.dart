import 'package:common/widgets/table/table.dart';
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
    return SizedBox(
      height: height,
      child: AppTable(
        columns: CategoryTableColumns.columns.dataColumns(context),
        getTotalRows: () => CategoryTableSource.getTotalRows(ref),
        getData: (setRowSelection, startingAt, count) =>
            CategoryTableSource.getData(
              context,
              ref,
              setRowSelection,
              startingAt,
              count,
            ),
        defaultRowsPerPage: 10,
        buttons: CategoryHeaderButtons.buildTableButtons(context),
        onSearchChanged: (value) {
          // TODO: Implement search functionality
        },
        functionButtons: CategoryFunctionButtons.buildFunctionButtons(context),
      ),
    );
  }
}
