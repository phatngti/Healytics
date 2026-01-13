import 'package:admin_panel/features/common/widgets/table/function_button.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:admin_panel/utils/device.dart';
import 'package:flutter/material.dart';

class CategoryFunctionButtons {
  static List<TableFunctionButtonWidget> buildFunctionButtons(
    BuildContext context,
  ) => [_buildSortButton(context), _buildFilterButton(context)];

  static TableFunctionButtonWidget _buildSortButton(BuildContext context) {
    final screenWidth = DeviceUtils.getScreenWidth(context);
    final screenHeight = DeviceUtils.getScreenHeight(context);
    final textTheme = Theme.of(context).textTheme;

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
          child: Column(
            children: [
              Text('Sort by Name', style: textTheme.bodyMedium),
              AppDimens.verticalSmall,
              Text('Sort by Services', style: textTheme.bodyMedium),
              AppDimens.verticalSmall,
              Text('Sort by Status', style: textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }

  static TableFunctionButtonWidget _buildFilterButton(BuildContext context) {
    final screenHeight = DeviceUtils.getScreenHeight(context);
    final textTheme = Theme.of(context).textTheme;

    return TableFunctionButtonWidget(
      label: 'Filter',
      prefixIcon: Icons.filter_alt,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: TableFunctionButtonWidget.maxWidth,
        ),
        child: SizedBox(
          height: screenHeight * 0.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('All', style: textTheme.bodyMedium),
              AppDimens.verticalSmall,
              Text('Visible', style: textTheme.bodyMedium),
              AppDimens.verticalSmall,
              Text('Hidden', style: textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
