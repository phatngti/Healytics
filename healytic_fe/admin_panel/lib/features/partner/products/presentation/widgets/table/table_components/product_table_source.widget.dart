import 'package:common/widgets/table/helper.dart';
import 'package:admin_panel/features/partner/products/presentation/providers/product.provider.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/table/table_components/product_table_actions.widget.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductTableSource {
  static Future<List<DataRow>> getData(
    BuildContext context,
    WidgetRef ref,
    SetRowSelectionCallback setRowSelection,
    int startingAt,
    int count,
  ) async {
    final products = await ref
        .read(productProvider.notifier)
        .getProducts(
          startingAt: startingAt,
          count: count,
          search: null,
          sortAscending: false,
        );

    final rows = products.map((product) {
      return DataRow(
        key: ValueKey<String>(product.id.value),
        onSelectChanged: (value) {
          if (value != null) {
            setRowSelection(ValueKey<String>(product.id.value), value);
          }
        },
        cells: [
          DataCell(
            Center(
              child: Text(
                product.id.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          DataCell(
            Center(
              child: product.images.isNotEmpty && product.images[0].isNotEmpty
                  ? SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.network(
                        product.images[0],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 24),
                      ),
                    )
                  : const SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(Icons.image_not_supported, size: 24),
                    ),
            ),
          ),
          DataCell(Center(child: Text(product.category.name))),
          DataCell(Center(child: Text(product.name))),
          DataCell(Center(child: Text(product.basePrice.toString()))),
        ],
      );
    }).toList();

    // Add action button cells to each row
    final actionButtons = ProductTableActions.buildRowActionButtons(context);
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
}
