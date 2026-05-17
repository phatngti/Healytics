import 'package:admin_panel/core/keys/integration_test_keys.dart';
import 'package:admin_panel/features/admin/category/presentation/providers/category.provider.dart';
import 'package:admin_panel/features/common/widgets/table/management_table_controls.dart';
import 'package:common/widgets/table/function_button.dart';
import 'package:admin_panel/utils/device.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoryFunctionButtons {
  static List<TableFunctionButtonWidget> buildFunctionButtons(
    BuildContext context,
    WidgetRef ref,
    CategoryState state,
  ) => [
    _buildSortButton(context, ref, state),
    _buildFilterButton(context, ref, state),
  ];

  static TableFunctionButtonWidget _buildSortButton(
    BuildContext context,
    WidgetRef ref,
    CategoryState state,
  ) {
    final screenWidth = DeviceUtils.getScreenWidth(context);
    final notifier = ref.read(categoryProvider.notifier);

    return TableFunctionButtonWidget(
      key: keys.managementTables.categorySortButton,
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
                value: CategoryTableSort.name,
                state: state,
                onTap: notifier.setSort,
              ),
              _sortOption(
                label: 'Services',
                value: CategoryTableSort.serviceCount,
                state: state,
                onTap: notifier.setSort,
              ),
              _sortOption(
                label: 'Status',
                value: CategoryTableSort.status,
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
    CategoryState state,
  ) {
    final notifier = ref.read(categoryProvider.notifier);

    return TableFunctionButtonWidget(
      key: keys.managementTables.categoryFilterButton,
      label: 'Filter',
      prefixIcon: Icons.filter_alt,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: TableFunctionButtonWidget.maxWidth,
        ),
        child: SizedBox(
          width: 220,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _visibilityOption(
                'All',
                CategoryVisibilityFilter.all,
                state,
                notifier,
              ),
              _visibilityOption(
                'Visible',
                CategoryVisibilityFilter.visible,
                state,
                notifier,
              ),
              _visibilityOption(
                'Hidden',
                CategoryVisibilityFilter.hidden,
                state,
                notifier,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _sortOption({
    required String label,
    required CategoryTableSort value,
    required CategoryState state,
    required ValueChanged<CategoryTableSort> onTap,
  }) {
    final isSelected = state.sortBy == value;
    return ManagementTableMenuOption(
      label: isSelected
          ? '$label (${state.sortAscending ? 'Asc' : 'Desc'})'
          : label,
      selected: isSelected,
      icon: Icons.sort,
      onTap: () => onTap(value),
    );
  }

  static Widget _visibilityOption(
    String label,
    CategoryVisibilityFilter value,
    CategoryState state,
    CategoryNotifier notifier,
  ) {
    return ManagementTableMenuOption(
      label: label,
      selected: state.visibilityFilter == value,
      onTap: () => notifier.setVisibilityFilter(value),
    );
  }
}
