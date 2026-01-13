import 'package:admin_panel/features/common/widgets/table/table.dart';
import 'package:admin_panel/features/partner/products/presentation/providers/product.provider.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/table/table_components/product_function_buttons.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/table/table_components/product_header_buttons.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/table/table_components/product_table_columns.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/table/table_components/product_table_source.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductTable extends HookConsumerWidget {
  const ProductTable({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: height,
      child: AppTable(
        columns: ProductTableColumns.columns.dataColumns(context),
        getTotalRows: () => ref.read(productProvider.notifier).getTotalRows(),
        getData: (setRowSelection, startingAt, count) =>
            ProductTableSource.getData(
              context,
              ref,
              setRowSelection,
              startingAt,
              count,
            ),
        defaultRowsPerPage: 10,
        buttons: ProductHeaderButtons.buildTableButtons(context),
        onSearchChanged: (value) {
          // TODO: Implement search functionality
        },
        functionButtons: ProductFunctionButtons.buildFunctionButtons(context),
      ),
    );
  }
}
