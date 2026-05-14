import 'package:admin_panel/core/keys/integration_test_keys.dart';
import 'package:admin_panel/features/common/widgets/table/management_table_controls.dart';
import 'package:admin_panel/features/partner/products/presentation/providers/product.provider.dart';
import 'package:common/widgets/table/function_button.dart';
import 'package:common/utils/demensions.dart';
import 'package:admin_panel/utils/device.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductFunctionButtons {
  static List<TableFunctionButtonWidget> buildFunctionButtons(
    BuildContext context,
    WidgetRef ref,
    ProductState state,
  ) => [
    _buildSortButton(context, ref, state),
    _buildFilterButton(context, ref, state),
  ];

  static TableFunctionButtonWidget _buildSortButton(
    BuildContext context,
    WidgetRef ref,
    ProductState state,
  ) {
    final screenWidth = DeviceUtils.getScreenWidth(context);
    final notifier = ref.read(productProvider.notifier);

    return TableFunctionButtonWidget(
      key: keys.managementTables.productSortButton,
      offset: Offset(-screenWidth * 0.1 / 2, 40),
      label: 'Sort',
      prefixIcon: Icons.sort,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: TableFunctionButtonWidget.maxWidth,
        ),
        child: SizedBox(
          width: 220,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sortOption(
                label: 'Name',
                value: ProductTableSort.name,
                state: state,
                onTap: notifier.setSort,
              ),
              _sortOption(
                label: 'Category',
                value: ProductTableSort.category,
                state: state,
                onTap: notifier.setSort,
              ),
              _sortOption(
                label: 'Price',
                value: ProductTableSort.price,
                state: state,
                onTap: notifier.setSort,
              ),
              _sortOption(
                label: 'Status',
                value: ProductTableSort.status,
                state: state,
                onTap: notifier.setSort,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static TableFunctionButtonWidget _buildFilterButton(
    BuildContext context,
    WidgetRef ref,
    ProductState state,
  ) {
    final notifier = ref.read(productProvider.notifier);

    return TableFunctionButtonWidget(
      key: keys.managementTables.productFilterButton,
      label: 'Filter',
      prefixIcon: Icons.filter_alt,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: TableFunctionButtonWidget.maxWidth,
        ),
        child: SizedBox(
          width: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ManagementTableMenuSection(
                title: 'Status',
                children: [
                  _statusOption(
                    'All Statuses',
                    ProductStatusFilter.all,
                    state,
                    notifier,
                  ),
                  _statusOption(
                    'Active',
                    ProductStatusFilter.active,
                    state,
                    notifier,
                  ),
                  _statusOption(
                    'Draft',
                    ProductStatusFilter.draft,
                    state,
                    notifier,
                  ),
                  _statusOption(
                    'Archived',
                    ProductStatusFilter.archived,
                    state,
                    notifier,
                  ),
                ],
              ),
              AppDimens.verticalSmall,
              ManagementTableMenuSection(
                title: 'Category',
                children: [
                  ManagementTableMenuOption(
                    label: 'All Categories',
                    selected: state.categoryFilter == null,
                    onTap: () => notifier.setCategoryFilter(null),
                  ),
                  FutureBuilder<List<String>>(
                    future: notifier.getFilterCategories(),
                    builder: (context, snapshot) {
                      final categories = snapshot.data ?? const <String>[];
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Padding(
                          padding: EdgeInsets.all(8),
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }
                      if (categories.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: categories
                            .map(
                              (category) => ManagementTableMenuOption(
                                label: category,
                                selected: state.categoryFilter == category,
                                onTap: () =>
                                    notifier.setCategoryFilter(category),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _sortOption({
    required String label,
    required ProductTableSort value,
    required ProductState state,
    required ValueChanged<ProductTableSort> onTap,
  }) {
    final isSelected = state.sortBy == value;
    return ManagementTableMenuOption(
      label: isSelected
          ? '$label (${state.sortAscending ? 'A-Z' : 'Z-A'})'
          : label,
      selected: isSelected,
      icon: Icons.sort,
      onTap: () => onTap(value),
    );
  }

  static Widget _statusOption(
    String label,
    ProductStatusFilter value,
    ProductState state,
    ProductNotifier notifier,
  ) {
    return ManagementTableMenuOption(
      label: label,
      selected: state.statusFilter == value,
      onTap: () => notifier.setStatusFilter(value),
    );
  }
}
