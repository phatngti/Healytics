import 'package:admin_panel/features/common/widgets/table/function_button.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:admin_panel/utils/device.dart';
import 'package:flutter/material.dart';

class EmployeeFunctionButtons {
  static List<TableFunctionButtonWidget> buildFunctionButtons(
    BuildContext context,
  ) => [_buildSortButton(context), _buildFilterButton(context)];

  static TableFunctionButtonWidget _buildSortButton(BuildContext context) {
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

  static TableFunctionButtonWidget _buildFilterButton(BuildContext context) {
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
}
