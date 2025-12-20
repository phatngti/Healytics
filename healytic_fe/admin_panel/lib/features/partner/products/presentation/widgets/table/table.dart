import 'package:admin_panel/core/extension/local_key_ext.dart';
import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:admin_panel/features/common/widgets/table/function_button.dart';
import 'package:admin_panel/features/common/widgets/table/helper.dart';
import 'package:admin_panel/features/common/widgets/table/table.dart';
import 'package:admin_panel/features/partner/products/presentation/providers/product.provider.dart';
import 'package:admin_panel/router/partner_routes.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:admin_panel/utils/device.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductTable extends HookConsumerWidget {
  const ProductTable({super.key, required this.height});

  final double height;

  // Column definitions
  static const List<Map<String, dynamic>> _columnDefinitions = [
    {'label': 'Name', 'prefixIcon': Icons.person},
    {'label': 'Price'},
    {'label': 'Description'},
    {'label': 'Image'},
    {'label': 'Category'},
  ];

  TableColumns get _columns => TableColumns(
    columns: _columnDefinitions
        .map(
          (column) => TableColumnData(
            label: column['label'].toString(),
            prefixIcon: column['prefixIcon'] as IconData?,
          ),
        )
        .toList(),
  );

  // Action buttons for each row
  List<({IconData icon, void Function(LocalKey?) onPressed})>
  _buildRowActionButtons(BuildContext context) => [
    (icon: Icons.edit, onPressed: (key) => _onEditProduct(context, key)),
    (icon: Icons.delete, onPressed: (key) => _onDeleteProduct(key)),
  ];

  void _onEditProduct(BuildContext context, LocalKey? key) {
    final id = int.tryParse(key?.toCleanString() ?? '');
    if (id != null) {
      context.goNamed(
        ProductDetailsRoute.name,
        pathParameters: {'id': id.toString()},
      );
    }
  }

  void _onDeleteProduct(LocalKey? key) {
    // TODO: Implement delete functionality
    print(key?.toCleanString());
  }

  // Table header buttons
  List<AppButton> _buildTableButtons(BuildContext context) => [
    _buildAddButton(context),
    _buildDeleteAllButton(context),
  ];

  AppButton _buildAddButton(BuildContext context) {
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

  AppButton _buildDeleteAllButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppButton(
      buttonType: ButtonType.elevated,
      onPressed: () {
        // TODO: Implement delete all functionality
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
            'Delete All',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onError),
          ),
        ],
      ),
    );
  }

  // Function buttons (Sort, Filter)
  List<TableFunctionButtonWidget> _buildFunctionButtons(BuildContext context) =>
      [_buildSortButton(context), _buildFilterButton(context)];

  TableFunctionButtonWidget _buildSortButton(BuildContext context) {
    final screenWidth = DeviceUtils.getScreenWidth(context);
    final screenHeight = DeviceUtils.getScreenHeight(context);

    return TableFunctionButtonWidget(
      offset: Offset(-screenWidth * 0.1 / 2, 40),
      label: 'Sort',
      prefixIcon: Icons.sort,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: TableFunctionButtonWidget.maxWidth,
        ),
        child: SizedBox(
          height: screenHeight * 0.2,
          width: screenWidth * 0.1,
          child: const Column(
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
    );
  }

  TableFunctionButtonWidget _buildFilterButton(BuildContext context) {
    final screenHeight = DeviceUtils.getScreenHeight(context);

    return TableFunctionButtonWidget(
      label: 'Filter',
      prefixIcon: Icons.filter_alt,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: TableFunctionButtonWidget.maxWidth,
        ),
        child: SizedBox(
          height: screenHeight * 0.2,
          child: const Column(
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
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: height,
      child: AppTable(
        actionButtons: true,
        columns: _columns.dataColumns(context),
        getTotalRows: () => ref.read(productProvider.notifier).getTotalRows(),
        getData: (setRowSelection, startingAt, count) async {
          final rows = await ref
              .read(productProvider.notifier)
              .getProducts(
                setRowSelection: setRowSelection,
                startingAt: startingAt,
                count: count,
                search: null,
                sortAscending: false,
              );
          // Add action button cells to each row
          final actionButtons = _buildRowActionButtons(context);
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
                              icon: Icon(action.icon),
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
        },
        defaultRowsPerPage: 10,
        buttons: _buildTableButtons(context),
        onSearchChanged: (value) {
          // TODO: Implement search functionality
        },
        functionButtons: _buildFunctionButtons(context),
      ),
    );
  }
}
