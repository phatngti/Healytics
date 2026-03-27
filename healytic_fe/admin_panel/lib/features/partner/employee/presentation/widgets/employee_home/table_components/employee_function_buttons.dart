import 'package:common/widgets/table/function_button.dart';
import 'package:common/utils/demensions.dart';
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
          child: Column(
            children: [
              Text('Sort', style: Theme.of(context).textTheme.bodyMedium),
              AppDimens.verticalSmall,
              Text('Sort', style: Theme.of(context).textTheme.bodyMedium),
              AppDimens.verticalSmall,
              Text('Sort', style: Theme.of(context).textTheme.bodyMedium),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Filter', style: Theme.of(context).textTheme.bodyMedium),
              AppDimens.verticalSmall,
              Text('Filter', style: Theme.of(context).textTheme.bodyMedium),
              AppDimens.verticalSmall,
              Text('Filter', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
