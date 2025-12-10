import 'package:admin_panel/core/extension/local_key_ext.dart';
import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:admin_panel/features/common/widgets/table/function_button.dart';
import 'package:admin_panel/features/common/widgets/table/helper.dart';
import 'package:admin_panel/features/common/widgets/table/table.dart';
import 'package:admin_panel/features/partner/products/presentation/providers/product.provider.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:admin_panel/utils/device.dart';
import 'package:admin_panel/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductTable extends HookConsumerWidget {
  const ProductTable({super.key, required this.height});
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('build table');
    final TableColumns columns = TableColumns(
      columns:
          [
                {'label': 'Name', 'prefixIcon': Icons.person},
                {'label': 'Price'},
                {'label': 'Description'},
                {'label': 'Image'},
                {'label': 'Category'},
              ]
              .map(
                (column) => TableColumnData(
                  label: column['label'].toString(),
                  prefixIcon: column['prefixIcon'] as IconData?,
                ),
              )
              .toList(),
    );
    return SizedBox(
      height: height,
      child: AppTable(
        actionButtons: true,
        columns: columns.dataColumns(context),
        getTotalRows: () => ref.read(productProvider.notifier).getTotalRows(),
        getData: (setRowSelection, startingAt, count) => ref
            .read(productProvider.notifier)
            .getProducts(
              actionButtons: [
                (
                  icon: Icons.edit,
                  onPressed: (key) {
                    final id = int.tryParse(key?.toCleanString() ?? '');
                    if (id != null) {
                      context.goNamed(
                        ProductDetailsRoute.name,
                        pathParameters: {'id': id.toString()},
                      );
                    }
                  },
                ),
                (
                  icon: Icons.delete,
                  onPressed: (key) {
                    print(key?.toCleanString());
                  },
                ),
              ],
              setRowSelection: setRowSelection,
              startingAt: startingAt,
              count: count,
              search: null,
              sortAscending: false,
            ),
        defaultRowsPerPage: 10,
        buttons: [
          AppButton(
            buttonType: ButtonType.elevated,
            onPressed: () {
              context.goNamed(ProductAddRoute.name);
            },
            child: Row(
              children: [
                Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
                AppDimens.horizontalSmall,
                Text(
                  'Add Product',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          AppButton(
            buttonType: ButtonType.elevated,
            onPressed: () {},
            customStyle: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.error,
              ),
              foregroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.onError,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.onError,
                ),
                AppDimens.horizontalSmall,
                Text(
                  'Deleted All',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onError,
                  ),
                ),
              ],
            ),
          ),
        ],
        onSearchChanged: (value) {},
        functionButtons: [
          TableFunctionButtonWidget(
            offset: Offset(-DeviceUtils.getScreenWidth(context) * 0.1 / 2, 40),
            label: "Sort",
            prefixIcon: Icons.sort,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: TableFunctionButtonWidget.maxWidth,
              ),
              child: SizedBox(
                height: DeviceUtils.getScreenHeight(context) * 0.2,
                width: DeviceUtils.getScreenWidth(context) * 0.1,
                child: Column(
                  children: [
                    Text('Sort'),
                    AppDimens.verticalSmall,
                    Text('Sort'),
                    AppDimens.verticalSmall,
                    Text('Sort'),
                  ],
                ),
              ),
            ),
          ),
          TableFunctionButtonWidget(
            label: "Filter",
            prefixIcon: Icons.filter_alt,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: TableFunctionButtonWidget.maxWidth,
              ),
              child: SizedBox(
                height: DeviceUtils.getScreenHeight(context) * 0.2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Filter'),
                    AppDimens.verticalSmall,
                    Text('Filter'),
                    AppDimens.verticalSmall,
                    Text('Filter'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
