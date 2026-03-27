import 'package:common/widgets/table/function_button.dart';
import 'package:common/utils/demensions.dart';
import 'package:admin_panel/utils/device.dart';
import 'package:flutter/material.dart';

/// Function buttons for the partner verification table
class PartnerFunctionButtons {
  static List<TableFunctionButtonWidget> buildFunctionButtons(
    BuildContext context,
  ) => [_buildSortButton(context)];

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date Submitted (Newest)', style: textTheme.bodyMedium),
              AppDimens.verticalSmall,
              Text('Priority (High to Low)', style: textTheme.bodyMedium),
              AppDimens.verticalSmall,
              Text('Name (A-Z)', style: textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
