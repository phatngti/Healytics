import 'package:common/widgets/table/table.dart';
import 'package:admin_panel/core/keys/integration_test_keys.dart';
import 'package:admin_panel/features/partner/products/presentation/providers/product.provider.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/table/table_components/product_function_buttons.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/table/table_components/product_header_buttons.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/table/table_components/product_table_columns.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/table/table_components/product_table_source.widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductTable extends HookConsumerWidget {
  const ProductTable({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableState = ref.watch(productProvider).value ?? const ProductState();
    final queryHash = Object.hash(
      tableState.searchQuery,
      tableState.sortBy,
      tableState.sortAscending,
      tableState.categoryFilter,
      tableState.statusFilter,
    );

    return SizedBox(
      height: height,
      child: AppTable(
        refreshToken: Object.hash(tableState.reloadToken, queryHash),
        columns: ProductTableColumns.columns.dataColumns(context),
        getTotalRows: () =>
            ref.read(productProvider.notifier).getVisibleTotalRows(),
        getData: (setRowSelection, startingAt, count) =>
            ProductTableSource.getData(
              context,
              ref,
              setRowSelection,
              startingAt,
              count,
            ),
        defaultRowsPerPage: 10,
        buttons: ProductHeaderButtons.buildTableButtons(
          context,
          ref,
          tableState,
        ),
        searchFieldKey: keys.managementTables.productSearchField,
        onSearchChanged: ref.read(productProvider.notifier).setSearchQuery,
        functionButtons: ProductFunctionButtons.buildFunctionButtons(
          context,
          ref,
          tableState,
        ),
      ),
    );
  }
}
